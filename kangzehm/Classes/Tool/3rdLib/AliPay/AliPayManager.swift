//
//  AliPayManager.swift
//  LazyHuiUser
//  支付宝管理类
//  Created by gouyz on 2018/5/2.
//  Copyright © 2018年 jh. All rights reserved.
//

import UIKit
import MBProgressHUD

class AliPayManager: NSObject {
    static let shared = AliPayManager()
    // 支付成功的闭包
    fileprivate var paySuccessClosure: (() -> Void)?
    // 支付失败的闭包
    fileprivate var payFailClosure: (() -> Void)?
    ///登录成功的闭包
    fileprivate var loginSuccessClosure:((_ auth_code:String) -> Void)?
    ///登录失败的闭包
    fileprivate var loginFailClosure:(() -> Void)?
    // 外部用这个方法调起支付支付
    func requestAliPay(_ request:String,
                         paySuccess: @escaping () -> Void,
                         payFail:@escaping () -> Void) {
        
        //用于提示用户支付宝支付结果，可以根据自己需求是否要此参数。
        self.paySuccessClosure = paySuccess
        self.payFailClosure = payFail
        AlipaySDK.defaultService().payOrder(request, fromScheme:kAliPayScheme,callback:nil)
    }
    //外部用这个方法调起支付宝授权回调
    func login(_ withInfo:String,loginSuccess: @escaping (_ str:String) -> Void,loginFail:@escaping () -> Void){
        
        // 用于提示用户支付宝支付结果，可以根据自己需求是否要此参数。
        self.loginSuccessClosure = loginSuccess
        self.loginFailClosure = loginFail
        AlipaySDK.defaultService().auth_V2(withInfo:withInfo, fromScheme:kAliPayScheme, callback:nil)
    }
    ///授权回调
    func showAuth_V2Result(result:[String: Any]){
        //        9000    请求处理成功
        //        4000    系统异常
        //        6001    用户中途取消
        //        6002    网络连接出错
        let returnCode:String = result["resultStatus"] as! String
        var returnMsg:String = ""
        switch  returnCode{
        case "6001":
            returnMsg = "用户中途取消"
            break
        case "6002":
            returnMsg = "网络连接出错"
            break
        case "4000":
            returnMsg = "系统异常"
            break
        case "9000":
            returnMsg = "授权成功"
            break
        default:
            returnMsg = "系统异常"
            break
        }
        MBProgressHUD.showAutoDismissHUD(message: returnMsg)
        if returnCode == "9000" {
            let r=result["result"] as! String
            self.loginSuccessClosure?(r)
            
        }else{
            self.loginFailClosure?()
        }
    }
    //传入回调参数
    func showResult(result:[String: Any]){
        //        9000    订单支付成功
        //        8000    正在处理中
        //        4000    订单支付失败
        //        6001    用户中途取消
        //        6002    网络连接出错
        let returnCode:String = result["resultStatus"] as! String
        
        var returnMsg:String = ""
        switch  returnCode{
        case "6001":
            returnMsg = "用户中途取消"
            break
        case "6002":
            returnMsg = "网络连接出错"
            break
        case "8000":
            returnMsg = "正在处理中"
            break
        case "4000":
            returnMsg = "订单支付失败"
            break
        case "5000":
            returnMsg = "重复请求"
            break
        case "9000":
            returnMsg = "支付成功"
            break
        default:
            returnMsg = "其它支付错误"
            break
        }
        MBProgressHUD.showAutoDismissHUD(message: returnMsg)
        if returnCode == "9000" {
            self.paySuccessClosure?()
            
        }else{
            self.payFailClosure?()
        }
    }
}
