//
//  SpeedLoadView.swift
//  ijkswift
//
//  Created by 左权 on 2018/9/26.
//  Copyright © 2018 YTTV. All rights reserved.
//

import UIKit

class SpeedLoadView: UIView {
    
    let speedLabel = UILabel.init()
    
    class var sharedInstance: SpeedLoadView {
        struct Static {
            static let instance: SpeedLoadView = SpeedLoadView()
        }
        return Static.instance
    }

    init() {
        super.init(frame: CGRect.zero)
        initUI()
    }
    
    func initUI() {
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        self.layer.cornerRadius = 5
        var i = 1
        var imageList: [UIImage] = []
        while i < 27 {
            imageList.append(UIImage.init(named: "loading"+String.init(i)+".png")!)
            i += 1
        }
        let imageView = UIImageView.init()
        imageView.contentMode = .scaleAspectFit
        imageView.animationImages = imageList
        imageView.animationDuration = 1
        imageView.animationRepeatCount = 0
        imageView.startAnimating()
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(15)
            make.left.equalTo(self).offset(20)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        speedLabel.textAlignment = NSTextAlignment.center
        speedLabel.font = UIFont.systemFont(ofSize: 12)
        speedLabel.textColor = UIColor.white
        addSubview(speedLabel)
        speedLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(5)
            make.bottom.equalTo(self).offset(-5)
            make.size.equalTo(CGSize(width: 60, height: 20))
        }
        NotificationCenter.default.addObserver(self, selector: #selector(networkSpeedChanged(sender:)), name: NSNotification.Name(rawValue: DOWNLOAD_SPEED_NOTIFICATION), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(orientation(noti:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    @objc func networkSpeedChanged(sender: Notification) {
        speedLabel.text = sender.object as? String
    }
    
    class func show(view: UIView) {
        SpeedHelper.sharedInstance.startListen()
        view.addSubview(SpeedLoadView.sharedInstance)
        SpeedLoadView.sharedInstance.snp.makeConstraints { (make) in
            make.center.equalTo(view.center)
            make.size.equalTo(CGSize(width: 70, height: 80))
        }
    }
    
    class func dismiss() {
        SpeedHelper.sharedInstance.stopListen()
        SpeedLoadView.sharedInstance.removeFromSuperview()
    }
    
    @objc func orientation(noti: NSNotification) {
        if SpeedLoadView.sharedInstance.superview != nil {
            SpeedLoadView.sharedInstance.center = (SpeedLoadView.sharedInstance.superview?.center)!
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
