//
//  GYZUpdateVersionTool.swift
//  LazyHuiSellers
//
//  Created by gouyz on 2017/3/16.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

/// 更新类型
///
/// - noUpdate:
/// - update//需要更新，但不强制:
/// - updateNeed//强制更新:
enum UpdateVersionType: Int {
    case noUpdate = 0  //不需要更新
    case update     //需要更新，但不强制
    case updateNeed  //强制更新
}

class GYZUpdateVersionTool: NSObject {

    /// 获取当前版本号
    ///
    /// - Returns:
    class func getCurrVersion()->String{
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }
    
    /// 判断是否需要更新
    ///
    /// - Parameter newVersion: 新版本号
    /// - Returns: 更新类型
    class func compareVersion(newVersion: String)->UpdateVersionType{
        if newVersion.isEmpty {
            return .noUpdate
        }
        
        let currVersion = getCurrVersion()
        if currVersion < newVersion {
            let currArr = currVersion.components(separatedBy: ".")
            let currVersionFirst = currArr[0]
//            let currVersionSecond = currArr[1]
            let newArr = newVersion.components(separatedBy: ".")
            let newVersionFirst = newArr[0]
//            let newVersionSecond = newArr[1]
            
            /// 版本号1.0.0，第一位是大版本更新，第二位是紧急bug修改，第三位小bug修改，第一位需要强制更新
            if currVersionFirst < newVersionFirst {
                return .updateNeed
            }
            return .update
        }
        
        return .noUpdate
    }
    
    /// 去App Store下载APP
    class func goAppStore(){
        let url: URL = URL.init(string: "https://itunes.apple.com/us/app/id\(APPID)?ls=1&mt=8")!
        UIApplication.shared.openURL(url)
    }
}
