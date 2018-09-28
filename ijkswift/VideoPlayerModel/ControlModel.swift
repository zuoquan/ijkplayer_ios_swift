//
//  ControlModel.swift
//  ijkswift
//
//  Created by 左权 on 2018/9/19.
//  Copyright © 2018年 YTTV. All rights reserved.
//

import UIKit

struct ControlModel {

    let topPanel = UIView.init()
    let bottomPanel = UIView.init()
    let overlayPanel = UIView.init()
    
    let backBtn = UIButton.init()
    let titleLabel = UILabel.init()
    
    let playBtn = UIButton.init()
    let pauseBtn = UIButton.init()
    let currentTimeLabel = UILabel.init()
    let totalDurationLabel = UILabel.init()
    let slider = UISlider.init()
    
    static var sharedInstance : ControlModel {
        struct Static {
            static let instance : ControlModel = ControlModel.init()
        }
        return Static.instance
    }
    
    func initUI() {
        backBtn.setImage(UIImage.init(named: "icon_arrow_back"), for: UIControlState.normal)
        totalDurationLabel.backgroundColor = UIColor.clear
        totalDurationLabel.textColor = UIColor.white
        totalDurationLabel.textAlignment = NSTextAlignment.center
        currentTimeLabel.backgroundColor = UIColor.clear
        currentTimeLabel.textColor = UIColor.white
        currentTimeLabel.textAlignment = NSTextAlignment.center
        playBtn.setImage(UIImage.init(named: "icon_play"), for: UIControlState.normal)
        pauseBtn.setImage(UIImage.init(named: "icon_pause"), for: UIControlState.normal)
        slider.setThumbImage(UIImage.init(named: "player_slider_playback_thumb"), for: UIControlState.normal)
        slider.minimumTrackTintColor = UIColor.init(red: 58/255.0, green: 193/255.0, blue: 126/255.0, alpha: 1)
    }
    
    func layoutUI(view: UIView) {
        view.addSubview(overlayPanel)
        overlayPanel.addSubview(topPanel)
        overlayPanel.addSubview(bottomPanel)
        topPanel.addSubview(backBtn)
        topPanel.addSubview(titleLabel)
        bottomPanel.addSubview(currentTimeLabel)
        bottomPanel.addSubview(playBtn)
        bottomPanel.addSubview(pauseBtn)
        bottomPanel.addSubview(slider)
        bottomPanel.addSubview(totalDurationLabel)
        
        overlayPanel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(view).offset(20)
        }
        topPanel.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(overlayPanel)
            make.height.equalTo(40)
        }
        bottomPanel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(overlayPanel)
            make.size.height.equalTo(40)
        }
        
        backBtn.snp.makeConstraints { (make) in
            make.top.bottom.left.equalTo(topPanel)
            make.size.width.equalTo(40)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(topPanel)
            make.left.equalTo(topPanel).offset(50)
            make.right.equalTo(topPanel).offset(-50)
        }
        
        playBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(bottomPanel)
            make.left.equalTo(bottomPanel).offset(10)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        pauseBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(bottomPanel)
            make.left.equalTo(bottomPanel).offset(10)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        currentTimeLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(bottomPanel)
            make.left.equalTo(bottomPanel).offset(60)
            make.size.width.equalTo(80)
        }
        totalDurationLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(bottomPanel)
            make.right.equalTo(bottomPanel).offset(-10)
            make.size.width.equalTo(80)
        }
        slider.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(bottomPanel)
            make.left.equalTo(bottomPanel).offset(150)
            make.right.equalTo(bottomPanel).offset(-100)
        }
    }
    
}
