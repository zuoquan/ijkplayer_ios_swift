//
//  GestureModel.swift
//  ijkswift
//
//  Created by 左权 on 2018/9/19.
//  Copyright © 2018年 YTTV. All rights reserved.
//

import UIKit
public enum GestureType {
    case GestureTypeUnknown
    case GestureTypeSingleTap
    case GestureTypeDoubleTap
    case GestureTypePan
    case GestureTypePinch
}

public enum PanDirection {
    case PanDirectionUnknown
    case PanDirectionV
    case PanDirectionH
}

public enum PanLocation {
    case PanLocationUnknown
    case PanLocationLeft
    case PanLocationRight
}

public enum PanMovingDirection {
    case PanMovingDirectionUnknown
    case PanMovingDirectionTop
    case PanMovingDirectionLeft
    case PanMovingDirectionBottom
    case PanMovingDirectionRight
}


struct  DisableGestureType : OptionSet {
    let rawValue: UInt8
    static let DisableGestureTypeUnknown =  DisableGestureType(rawValue: 1 << 0)
    static let DisableGestureTypeSingleTap =  DisableGestureType(rawValue: 1 << 1)
    static let DisableGestureTypeDoubleTap =  DisableGestureType(rawValue: 1 << 2)
    static let DisableGestureTypePan =  DisableGestureType(rawValue: 1 << 3)
    static let DisableGestureTypePinch = DisableGestureType(rawValue: 1 << 4)
    static let DisableGestureTypeAll = DisableGestureType(rawValue: 1 << 5)
}

