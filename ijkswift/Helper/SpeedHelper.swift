//
//  SpeedHelper.swift
//  ijkswift
//
//  Created by 左权 on 2018/9/26.
//  Copyright © 2018 YTTV. All rights reserved.
//

import UIKit

class SpeedHelper: NSObject {
    
    /// 总网速
    var _iBytes: Int = 0
    var _oBytes: Int = 0
    var _allFlow: Int = 0
    
    /// wifi网速
    var _wifiIBytes: Int = 0
    var _wifiOBytes: Int = 0
    var _wifiFlow: Int = 0
    
    /// 3G网速
    var _wwanIBytes: Int = 0
    var _wwanOBytes: Int = 0
    var _wwanFlow:Int = 0
    
    var downloadNetworkSpeed = ""
    var uploadNetworkSpeed = ""
    var timer: Timer?
    
    class var sharedInstance: SpeedHelper {
        struct Static {
            static let instance: SpeedHelper = SpeedHelper()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
    }
    
    func startListen() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkNetworkSpeed), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
            timer?.fire()
        }
    }
    
    func stopListen() {
        if timer != nil {
            if (timer?.isValid)! {
                timer?.invalidate()
                timer = nil
            }
        }
    }
    
    @objc func checkNetworkSpeed() {
        var ifa_list: UnsafeMutablePointer<ifaddrs>? = nil
        var iBytes = 0
        var oBytes = 0
        var wifiIBytes = 0
        var wifiOBytes = 0
        var wwanIBytes = 0
        var wwanOBytes = 0

        if getifaddrs(&ifa_list) == 0 {
            var ifa = ifa_list
            while ifa != nil {
                if let addrs = ifa?.pointee {
                    let name = String(cString: addrs.ifa_name)
                    if addrs.ifa_addr.pointee.sa_family == UInt8(AF_LINK) {
                        if name.hasPrefix("lo") {
                            let networkData = unsafeBitCast(addrs.ifa_data, to: UnsafeMutablePointer<if_data>.self)
                            iBytes += Int(networkData.pointee.ifi_ibytes)
                            oBytes += Int(networkData.pointee.ifi_obytes)
                        }
                        else if name.hasPrefix("en") { // Wifi
                            let networkData = unsafeBitCast(addrs.ifa_data, to: UnsafeMutablePointer<if_data>.self)
                            wifiIBytes += Int(networkData.pointee.ifi_ibytes)
                            wifiOBytes += Int(networkData.pointee.ifi_obytes)
                        } else if name.hasPrefix("pdp_ip") { // WWAN
                            let networkData = unsafeBitCast(addrs.ifa_data, to: UnsafeMutablePointer<if_data>.self)
                            wwanIBytes += Int(networkData.pointee.ifi_ibytes)
                            wwanOBytes += Int(networkData.pointee.ifi_obytes)
                        }
                    }
                }
                ifa = ifa?.pointee.ifa_next
            }
            freeifaddrs(ifa_list)
        }
        if _iBytes != 0 {
            downloadNetworkSpeed = stringWithBytes(bytes: iBytes - _iBytes) + "/s"
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: DOWNLOAD_SPEED_NOTIFICATION), object: downloadNetworkSpeed, userInfo: nil)
        }
        _iBytes = iBytes
        if _oBytes != 0 {
            uploadNetworkSpeed = stringWithBytes(bytes: oBytes - _oBytes) + "/s"
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: UPLOAD_SPEED_NOTIFICATION), object: [uploadNetworkSpeed], userInfo: nil)
        }
        _oBytes = oBytes
    }
    
    func stringWithBytes(bytes: Int) -> String {
        if bytes < 1024 {
            return String(format: "%dB", bytes)
        }
        else if bytes >= 1024 && bytes < 1024*1024 {
            return String(format: "%.0fKB", Double(bytes/1024))
        }
        else if bytes >= 1024*1024 && bytes < 1024*1024*1024 {
            return String(format: "%.1fMB", Double(bytes/1024/1024))
        }
        else {
            return String(format: "%.1fGB", Double(bytes/1024/1024/1024))
        }
    }
}
