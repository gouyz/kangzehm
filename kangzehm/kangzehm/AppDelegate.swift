//
//  AppDelegate.swift
//  kangze
//
//  Created by gouyz on 2018/8/28.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        /// 检测网络状态
        networkManager?.startListening()

        /// 设置键盘控制
        setKeyboardManage()

        //微信注册
        WXApi.registerApp(kWeChatAppID)
        GYZTencentShare.shared.registeApp(kQQAppID)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = kWhiteColor
        
        //如果未登录进入登录界面，登录后进入首页
//                if userDefaults.bool(forKey: kIsLoginTagKey) {
//                    window?.rootViewController = GYZMainTabBarVC()
//                }else{
//                    window?.rootViewController = GYZBaseNavigationVC(rootViewController: BPLoginVC())
//                }
        window?.rootViewController = GYZMainTabBarVC()
        window?.makeKeyAndVisible()
        
        return true
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        return dealPayResult(url: url)
    }
    // NOTE: 9.0以后使用新API接口
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return dealPayResult(url: url)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    /// 设置键盘控制
    func setKeyboardManage(){
        //控制自动键盘处理事件在整个项目内是否启用
        IQKeyboardManager.sharedManager().enable = true
        //点击背景收起键盘
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        //隐藏键盘上的工具条(默认打开)
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
    }

    ///支付宝/微信回调
    func dealPayResult(url: URL) -> Bool{
        
        var result: Bool = true
        if url.host == "safepay" {// 支付宝
            //跳转支付宝钱包进行支付，处理支付结果
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: { (resultDic) in
                GYZLog(resultDic)
                if let alipayjson = resultDic {
                    /// 支付后回调
                    AliPayManager.shared.showResult(result: alipayjson as! [String: Any])
                }
                
            })
            
            //授权回调
            AlipaySDK.defaultService().processAuth_V2Result(url, standbyCallback: { (resultDic) in
                GYZLog(resultDic)
                if let alipayjson = resultDic {
                    /// 支付后回调
                    AliPayManager.shared.showAuth_V2Result(result: alipayjson as! [String : Any])
                }
            })
        }else if url.host == "qzapp" || url.host == "response_from_qq" {// QQ授权登录或QQ 分享
            
            result = GYZTencentShare.shared.handle(url)
        }else{//微信
            result = WXApi.handleOpen(url, delegate:WXApiManager.shared)
        }
        
        return result
    }
}

