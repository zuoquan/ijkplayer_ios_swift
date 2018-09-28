//
//  ForwardView.swift
//  ijkswift
//
//  Created by 左权 on 2018/9/26.
//  Copyright © 2018年 YTTV. All rights reserved.
//

import UIKit

class ForwardView: UIView {
    
    var imageIcon =  UIImageView()
    var timeLabel =  UILabel()
    var progress = UIProgressView()

    class var sharedInstance: ForwardView {
        struct Static {
            static let instance: ForwardView = ForwardView()
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
        addSubview(imageIcon)
        addSubview(timeLabel)
        addSubview(progress)
        imageIcon.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.top.equalTo(self).offset(5)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        timeLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
            make.size.equalTo(CGSize(width: 60, height: 20))
        }
        progress.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(15)
            make.right.equalTo(self).offset(-15)
            make.bottom.equalTo(self).offset(-5)
            make.height.equalTo(2)
        }
        imageIcon.image = UIImage.init(named: "fast_forward")
        imageIcon.contentMode = UIViewContentMode.scaleAspectFit
        timeLabel.textColor = UIColor.white
        timeLabel.font = UIFont.systemFont(ofSize: 11)
        timeLabel.textAlignment = NSTextAlignment.center
        progress.progressTintColor = UIColor.white
    }
    
    class func show(view: UIView) {
        view.addSubview(ForwardView.sharedInstance)
        ForwardView.sharedInstance.snp.makeConstraints { (make) in
            make.center.equalTo(view.center)
            make.size.equalTo(CGSize(width: 100, height: 75))
        }
    }
    
    class func dismiss() {
       ForwardView.sharedInstance.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
