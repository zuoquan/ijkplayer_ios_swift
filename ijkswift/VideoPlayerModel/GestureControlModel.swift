//
//  GestureControlModel.swift
//  ijkswift
//
//  Created by 左权 on 2018/9/20.
//  Copyright © 2018年 YTTV. All rights reserved.
//

import UIKit

class GestureControlModel: NSObject {
    
    var triggerCondition: ((_ control: GestureControlModel, _ type: GestureType, _ gesture: UIGestureRecognizer, _ touch: UITouch) -> (Bool))?
    var singleTaped:      ((_ control: GestureControlModel) -> ())?
    var doubleTaped:      ((_ control: GestureControlModel) -> ())?
    var beganPan:         ((_ control: GestureControlModel, _ direction: PanDirection, _                    location: PanLocation) -> ())?
    var changedPan:       ((_ control: GestureControlModel, _ direction: PanDirection, _           location: PanLocation, _ velocity: CGPoint) -> ())?
    var endPan:           ((_ control: GestureControlModel, _ direction: PanDirection, _     location: PanLocation) -> ())?
    var pinched:          ((_ control: GestureControlModel, _ scale: CGFloat) -> ())?
    
    var panDirection: PanDirection?
    var panLocation: PanLocation?
    var panMoveDirection: PanMovingDirection?
    var disablegesturetype = DisableGestureType.DisableGestureTypeUnknown
    private var targetView: UIView?
    
    override init() {
        super.init()
    }
    
    static var sharedInstance : GestureControlModel {
        struct Static {
            static let instance: GestureControlModel = GestureControlModel.init()
        }
        return Static.instance
    }
    
    func addGesToView(view: UIView) {
        targetView = view
        targetView?.isMultipleTouchEnabled = true
        singleTap.require(toFail: doubleTap)
        doubleTap.require(toFail: panGR)
        targetView?.addGestureRecognizer(singleTap)
        targetView?.addGestureRecognizer(doubleTap)
        targetView?.addGestureRecognizer(panGR)
        targetView?.addGestureRecognizer(pinchGR)
    }
    
    func removeGesToView(view: UIView) {
        view.removeGestureRecognizer(singleTap)
        view.removeGestureRecognizer(doubleTap)
        view.removeGestureRecognizer(panGR)
        view.removeGestureRecognizer(pinchGR)
    }
    
    lazy var singleTap: UITapGestureRecognizer = {
        let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(handleSingleTap(tap:)))
        singleTap.delegate = self
        singleTap.delaysTouchesBegan = true
        singleTap.delaysTouchesEnded = true
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        return singleTap
    }()
    
    lazy var doubleTap: UITapGestureRecognizer = {
        let doubleTap = UITapGestureRecognizer.init(target: self, action: #selector(handleDoubleTap))
        doubleTap.delegate = self
        doubleTap.delaysTouchesBegan = true
        doubleTap.delaysTouchesEnded = true
        doubleTap.numberOfTouchesRequired = 1
        doubleTap.numberOfTapsRequired = 2
        return doubleTap
    }()
    
    lazy var panGR: UIPanGestureRecognizer = {
        let panGR = UIPanGestureRecognizer.init(target: self, action: #selector(handlePanTap))
        panGR.delegate = self
        panGR.delaysTouchesBegan = true
        panGR.delaysTouchesEnded = true
        panGR.maximumNumberOfTouches = 1
        panGR.cancelsTouchesInView = true
        return panGR
    }()
    
    lazy var pinchGR: UIPinchGestureRecognizer = {
        let pinchGR = UIPinchGestureRecognizer.init(target: self, action: #selector(handlePinchTap))
        pinchGR.delegate = self
        pinchGR.delaysTouchesBegan = true
        return pinchGR
    }()
    
    
}

extension GestureControlModel {
    @objc func handleSingleTap(tap: UITapGestureRecognizer) {
        if singleTaped != nil {
            singleTaped!(self)
        }
    }
    
    @objc func handleDoubleTap(tap: UITapGestureRecognizer) {
        if doubleTaped != nil {
            doubleTaped!(self)
        }
    }
    
    @objc func handlePanTap(pan: UIPanGestureRecognizer) {
        let translate = pan.translation(in: pan.view)
        let velocity = pan.velocity(in: pan.view)
        switch pan.state {
        case UIGestureRecognizerState.began:
            panMoveDirection = PanMovingDirection.PanMovingDirectionUnknown
            let x = fabs(velocity.x)
            let y = fabs(velocity.y)
            if x > y {
                panDirection = PanDirection.PanDirectionH
            }
            else {
                panDirection = PanDirection.PanDirectionV
            }
            if beganPan != nil {
                beganPan!(self, panDirection!, panLocation!)
            }
        case UIGestureRecognizerState.changed:
            if panDirection == PanDirection.PanDirectionH {
                if translate.x > 0 {
                    panMoveDirection = PanMovingDirection.PanMovingDirectionRight
                }
                else if translate.y < 0{
                    panMoveDirection = PanMovingDirection.PanMovingDirectionLeft
                }
            }
            else if panDirection == PanDirection.PanDirectionV {
                if translate.y > 0 {
                    panMoveDirection = PanMovingDirection.PanMovingDirectionBottom
                }
                else {
                    panMoveDirection = PanMovingDirection.PanMovingDirectionTop
                }
            }
            if changedPan != nil {
                changedPan!(self, panDirection!, panLocation!, velocity)
            }
        case UIGestureRecognizerState.failed,UIGestureRecognizerState.cancelled, UIGestureRecognizerState.ended:
            if endPan != nil {
                endPan!(self, panDirection!, panLocation!)
            }
        default:
            break
        }
        pan.setTranslation(CGPoint.zero, in: pan.view)
    }
    
    @objc func handlePinchTap(pinch: UIPinchGestureRecognizer) {
        switch pinch.state {
        case UIGestureRecognizerState.ended:
            if pinched != nil {
                pinched!(self, pinch.scale)
            }
        default:
            break
        }
    }
}

extension GestureControlModel: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isKind(of: object_getClass(UISlider())!))! {
            return false
        }
        var gestureType = GestureType.GestureTypeUnknown
        switch gestureRecognizer {
        case singleTap:
            gestureType = GestureType.GestureTypeSingleTap
        case doubleTap:
            gestureType = GestureType.GestureTypeDoubleTap
        case panGR:
            gestureType = GestureType.GestureTypePan
        case pinchGR:
            gestureType = GestureType.GestureTypePinch
        default:
            gestureType = GestureType.GestureTypeUnknown
        }
        let locationPoint = touch.location(in: touch.view)
        if locationPoint.x > (targetView?.bounds.size.width)!/2 {
            panLocation = PanLocation.PanLocationRight
        }
        else {
            panLocation = PanLocation.PanLocationLeft
        }
        var disableTypes = disablegesturetype
        if disableTypes.rawValue & DisableGestureType.DisableGestureTypeAll.rawValue != 0 {
            disableTypes = [.DisableGestureTypeSingleTap, .DisableGestureTypeDoubleTap, .DisableGestureTypePan, .DisableGestureTypePinch]
        }
        switch gestureType {
        case .GestureTypeUnknown:
            break
        case .GestureTypeSingleTap:
            if disableTypes.rawValue & DisableGestureType.DisableGestureTypeSingleTap.rawValue != 0 {
                return false
            }
        case .GestureTypeDoubleTap:
            if disableTypes.rawValue & DisableGestureType.DisableGestureTypeDoubleTap.rawValue != 0 {
                return false
            }
        case .GestureTypePan:
            if disableTypes.rawValue & DisableGestureType.DisableGestureTypePan.rawValue != 0 {
                return false
            }
        case .GestureTypePinch:
            if disableTypes.rawValue & DisableGestureType.DisableGestureTypePinch.rawValue != 0 {
                return false
            }
        }
        if (triggerCondition != nil) {
            return triggerCondition!(self, gestureType, gestureRecognizer, touch)
        }
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (otherGestureRecognizer != singleTap && otherGestureRecognizer != doubleTap && otherGestureRecognizer != panGR && otherGestureRecognizer != pinchGR) {
            return false
        }
        if gestureRecognizer.numberOfTouches >= 2 {
            return false
        }
        return true
    }
}
