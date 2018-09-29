//
//  ViewController.swift
//  ijkswift
//
//  Created by 左权 on 2018/9/17.
//  Copyright © 2018年 YTTV. All rights reserved.
//

import UIKit
import SnapKit

class VideoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let playerView = VideoPlayerView.init(frame: self.view.bounds, strUrl: "http://221.228.226.5/15/t/s/h/v/tshvhsxwkbjlipfohhamjkraxuknsc/sh.yinyuetai.com/88DC015DB03C829C2126EEBBB5A887CB.mp4")
        self.view.addSubview(playerView)
        playerView.backgroundColor = UIColor.black
        playerView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

