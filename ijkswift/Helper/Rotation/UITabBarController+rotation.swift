//
//  UITabBarController+rotation.swift
//  ijkswift
//
//  Created by 左权 on 2018/9/29.
//  Copyright © 2018 YTTV. All rights reserved.
//

import UIKit

extension UITabBarController {

    open override var shouldAutorotate: Bool {
        return (self.viewControllers?.last?.shouldAutorotate)!
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return (self.viewControllers?.last?.supportedInterfaceOrientations)!
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return (self.viewControllers?.last?.preferredInterfaceOrientationForPresentation)!
    }
    
    open override var prefersStatusBarHidden: Bool {
        return (self.viewControllers?.last?.prefersStatusBarHidden)!
    }
}
