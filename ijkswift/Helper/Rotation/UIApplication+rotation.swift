//
//  UIApplication+rotation.swift
//  ijkswift
//
//  Created by 左权 on 2018/9/29.
//  Copyright © 2018 YTTV. All rights reserved.
//

import UIKit

extension AppDelegate {
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if isAllOrientation {
            return UIInterfaceOrientationMask.all
        }
        else{
            UIApplication.shared.statusBarOrientation = UIInterfaceOrientation.portrait
            return UIInterfaceOrientationMask.portrait
        }
    }
    
}
