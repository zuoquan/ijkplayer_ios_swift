//
//  VideoPlayerView.swift
//  ijkswift
//
//  Created by 左权 on 2018/9/25.
//  Copyright © 2018年 YTTV. All rights reserved.
//

import UIKit
import IJKMediaFramework

class VideoPlayerView: UIView {
    
    var player: IJKFFMoviePlayerController?
    var mediaControl: VideoPlayerControl?
    var curTime: TimeInterval?

    init(frame: CGRect, strUrl: String) {
        super.init(frame: frame)
        setPlayer(url: NSURL.init(string: strUrl)!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPlayer(url: NSURL) {
        let options = IJKFFOptions.byDefault()
        player = IJKFFMoviePlayerController.init(contentURL:url as URL? , with: options)
        addSubview((player?.view)!)
        player?.view.snp.makeConstraints({ (make) in
            make.edges.equalTo(self)
        })
        player?.scalingMode = IJKMPMovieScalingMode.aspectFit
        player?.shouldAutoplay = true
        player?.prepareToPlay()
        player?.play()
        mediaControl = VideoPlayerControl.init(frame: self.bounds)
        addSubview(mediaControl!)
        mediaControl?.snp.makeConstraints({ (make) in
            make.edges.equalTo(self)
        })
        mediaControl?.delegatePlayer = player
        mediaControl?.addGesture(view: self)
        mediaControl?.showAndFade()
        installIJKNotification()
    }
}

extension VideoPlayerView {
    func singleTaped() {
        if (mediaControl?.isHidden)! {
            mediaControl?.showAndFade()
            SpeedHelper().checkNetworkSpeed()
        }
        else {
            mediaControl?.hide()
        }
    }
    func beginPan(control: GestureControlModel, direction: PanDirection, location: PanLocation) {
        curTime = player?.currentPlaybackTime
        ForwardView.show(view: self)
    }
    func changePan(control: GestureControlModel, direction: PanDirection, location: PanLocation, velocity: CGPoint) {
        if direction == PanDirection.PanDirectionH {
            curTime = TimeInterval(velocity.x/200) + curTime!
            let totalMovieDuration = player?.duration
            if totalMovieDuration == 0 {
                return
            }
            if Double(curTime!) > Double(totalMovieDuration!) {
                curTime = totalMovieDuration
            }
            mediaControl?.slider.value = Float(curTime!)
            mediaControl?.isDragged = true
            mediaControl?.refreshVideoControl()
            if velocity.x < 0 {
                ForwardView.sharedInstance.imageIcon.image = UIImage.init(named: "fast_backward")
            }
            else {
                ForwardView.sharedInstance.imageIcon.image = UIImage.init(named: "fast_forward")
            }
            ForwardView.sharedInstance.progress.progress = Float(curTime!/totalMovieDuration!)
            ForwardView.sharedInstance.timeLabel.text = String(format: "%02d:%02d", Int(curTime!/60),Int(Int(curTime!)%60)) + "/" + String(format: "%02d:%02d", Int(totalMovieDuration!/60),Int(Int(totalMovieDuration!)%60))
        }
    }
    func endPan(control: GestureControlModel, direction: PanDirection, location: PanLocation) {
        mediaControl?.isDragged = false
        player?.currentPlaybackTime = curTime!
        ForwardView.dismiss()
    }
}

extension VideoPlayerView {
    func installIJKNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(playerLoadStateDidChange), name: NSNotification.Name.IJKMPMoviePlayerLoadStateDidChange, object: player)
        NotificationCenter.default.addObserver(self, selector: #selector(seekComplete), name: NSNotification.Name.IJKMPMoviePlayerDidSeekComplete, object: player)
    }
    
    @objc func playerLoadStateDidChange() {
        let loadState = player?.loadState
        switch loadState {
        case IJKMPMovieLoadState.playable:
            SpeedLoadView.dismiss()
        case IJKMPMovieLoadState.stalled:
            SpeedLoadView.show(view: self)
        default:
            SpeedLoadView.dismiss()
        }
        
    }
    @objc func seekComplete() {
        SpeedLoadView.show(view: self)
    }
}
