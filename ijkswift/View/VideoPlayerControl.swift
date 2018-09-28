//
//  VideoPlayerControl.swift
//  ijkswift
//
//  Created by 左权 on 2018/9/18.
//  Copyright © 2018年 YTTV. All rights reserved.
//

import UIKit
import IJKMediaFramework

class VideoPlayerControl: UIControl {

    let topPanel = ControlModel.sharedInstance.topPanel
    let bottomPanel = ControlModel.sharedInstance.bottomPanel
    let overlayPanel = ControlModel.sharedInstance.overlayPanel
    
    let backBtn = ControlModel.sharedInstance.backBtn
    let titleLabel = ControlModel.sharedInstance.titleLabel
    
    let playBtn = ControlModel.sharedInstance.playBtn
    let pauseBtn = ControlModel.sharedInstance.pauseBtn
    let currentTimeLabel = ControlModel.sharedInstance.currentTimeLabel
    let totalDurationLabel = ControlModel.sharedInstance.totalDurationLabel
    let slider = ControlModel.sharedInstance.slider
    
    var delegatePlayer: IJKMediaPlayback?
    
    var isDragged = Bool()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ControlModel.sharedInstance.layoutUI(view: self)
        ControlModel.sharedInstance.initUI()
        addActtion()
        GestureControlModel.sharedInstance.disablegesturetype = DisableGestureType.DisableGestureTypeUnknown
    }
    
    func addActtion() {
        playBtn.addTarget(self, action: #selector(playAction), for: UIControlEvents.touchUpInside)
        pauseBtn.addTarget(self, action: #selector(pauseAction), for: UIControlEvents.touchUpInside)
        slider.addTarget(self, action: #selector(sliderTouchDown), for: UIControlEvents.touchDown)
        slider.addTarget(self, action: #selector(sliderTouchCancel), for: UIControlEvents.touchCancel)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: UIControlEvents.valueChanged)
        slider.addTarget(self, action: #selector(sliderTouchUpInside), for: UIControlEvents.touchUpInside)
    }
    
    func addGesture(view: VideoPlayerView) {
        GestureControlModel.sharedInstance.addGesToView(view: view)
        GestureControlModel.sharedInstance.singleTaped = { (gesModle) in
            view.singleTaped()
        }
        GestureControlModel.sharedInstance.beganPan = { (gesModel,direction,location) in
            view.beginPan(control: gesModel, direction: direction, location: location)
        }
        GestureControlModel.sharedInstance.changedPan = { (gesModle,direction,location,velocity) in
            view.changePan(control: gesModle, direction: direction, location: location, velocity: velocity)
        }
        GestureControlModel.sharedInstance.endPan = { (gesModel,direction,location) in
            view.endPan(control: gesModel, direction: direction, location: location)
        }
    }
    
    @objc func playAction() {
        delegatePlayer?.play()
        refreshVideoControl()
    }
    
    @objc func pauseAction() {
        delegatePlayer?.pause()
        refreshVideoControl()
    }
    
    @objc func sliderTouchDown() {
        beginDrag()
    }
    
    @objc func sliderTouchCancel() {
        endDrag()
    }
    
    @objc func sliderValueChanged() {
        continueDrag()
    }
    
    @objc func sliderTouchUpInside() {
        delegatePlayer?.currentPlaybackTime = TimeInterval(slider.value)
        endDrag()
    }
    
    func showNoFade() {
        self.isHidden = false
        cancelDelayHide()
        refreshVideoControl()
    }
    
    func showAndFade() {
        showNoFade()
        self.perform(#selector(hide), with: nil, afterDelay: DELAY_TIME)
    }
    
    @objc func hide() {
        self.isHidden = true
        cancelDelayHide()
    }
    
    func cancelDelayHide() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(hide), object: nil)
    }
    
    func beginDrag() {
        isDragged = true
    }
    
    func endDrag() {
        isDragged = false
    }
    
    func continueDrag() {
        refreshVideoControl()
    }
    
    @objc func refreshVideoControl() {
        let duration = delegatePlayer?.duration
        let intDuration = duration! + 0.5
        if intDuration > 0 {
            slider.maximumValue = Float(duration!)
            totalDurationLabel.text = String(format: "%02d:%02d", Int(intDuration/60),Int(Int(intDuration)%60))
        }
        else {
            slider.maximumValue = 1
            totalDurationLabel.text = "--:--"
        }
        var position: TimeInterval
        if isDragged {
            position = TimeInterval(slider.value)
        }
        else {
            position = (delegatePlayer?.currentPlaybackTime)!
        }
        let intPosition = position + 0.5
        if intPosition > 0 {
            slider.value = Float(position)
        }
        else {
            slider.value = 0
        }
        currentTimeLabel.text = String(format: "%02d:%02d", Int(position/60),Int(Int(position)%60))
        let isPlaying = delegatePlayer?.isPlaying()
        playBtn.isHidden = isPlaying!
        pauseBtn.isHidden = !isPlaying!
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(refreshVideoControl), object: nil)
        if !overlayPanel.isHidden {
            self.perform(#selector(refreshVideoControl), with: nil, afterDelay: 0.4)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
