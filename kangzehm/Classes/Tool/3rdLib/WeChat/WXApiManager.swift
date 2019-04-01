//
//  WXApiManager.swift
//  LazyHuiUser
//  微信管理类
//  Created by gouyz on 2018/5/2.
//  Copyright © 2018年 jh. All rights reserved.
//

import UIKit
import MBProgressHUD

class WXApiManager: NSObject {
    static let shared = WXApiManager()
    // 用于弹出警报视图，显示成功或失败的信息()
    private weak var sender:GYZBaseVC! //(UIViewController)
    // 支付成功的闭包
    private var paySuccessClosure: (() -> Void)?
    // 支付失败的闭包
    private var payFailClosure: (() -> Void)?
    //登录成功
    private var loginSuccessClosure:((_ code:String) -> Void)?
    //登录失败
    private var loginFailClosure:(() -> Void)?
    // 外部用这个方法调起微信支付
    func payAlertController(_ sender:GYZBaseVC,
                            request:PayReq,
                            paySuccess: @escaping () -> Void,
                            payFail:@escaping () -> Void) {
        // sender 是调用这个方法的控制器，
        // 用于提示用户微信支付结果，可以根据自己需求是否要此参数。
        self.sender = sender
        self.paySuccessClosure = paySuccess
        self.payFailClosure = payFail
        if checkWXInstallAndSupport(){//检查用户是否安装微信
            WXApi.send(request)
        }
    }
    //外部用这个方法调起微信登录
    func login(_ sender:GYZBaseVC,loginSuccess: @escaping ( _ code:String) -> Void,
               loginFail:@escaping () -> Void){
        // sender 是调用这个方法的控制器，
        // 用于提示用户微信支付结果，可以根据自己需求是否要此参数。
        self.sender = sender
        self.loginSuccessClosure = loginSuccess
        self.loginFailClosure = loginFail
        if checkWXInstallAndSupport(){
            let req=SendAuthReq()
            req.scope="snsapi_userinfo"
            req.state="app"
            WXApi.send(req)
        }
    }
    
    /// 发送链接分享
    ///
    /// - Parameters:
    ///   - url: 链接
    ///   - title: 标题
    ///   - description: 描述
    ///   - thumbImage: 图片
    ///   - scene: 类型
    ///   - sender: 控制器
    func sendLinkURL(_ url: String,title:String,description:String,thumbImage:UIImage,scene:WXScene,sender:GYZBaseVC){
        
        self.sender = sender
        if checkWXInstallAndSupport(){
            let message = WXMediaMessage()
            message.title = title
            message.description = description
            message.thumbData = UIImageJPEGRepresentation(thumbImage, 0.5)
//            message.setThumbImage(thumbImage)
            
            let ext = WXWebpageObject()
            ext.webpageUrl = url
            message.mediaObject = ext
            
            let req = SendMessageToWXReq()
            req.bText = false
            req.message = message
            req.scene = Int32(scene.rawValue)
            
            WXApi.send(req)
        }
    }
    
}
extension WXApiManager: WXApiDelegate {
    func onResp(_ resp: BaseResp!) {
        
        var strMsg: String = ""
        if resp is PayResp {//支付
            if resp.errCode == 0 {
                self.paySuccessClosure?()
                strMsg = "微信支付成功"
            }else{
                self.payFailClosure?()
                strMsg = "微信支付失败"
            }
        }else if resp is SendAuthResp{//登录结果
            let authResp = resp as! SendAuthResp
            if authResp.errCode == 0{
                strMsg="微信授权成功"
                self.loginSuccessClosure?(authResp.code)
            }else{
                switch authResp.errCode{
                case -4:
                    strMsg = "您拒绝使用微信登录"
                    break
                case -2:
                    strMsg = "您取消了微信登录"
                    break
                default:
                    strMsg = "微信登录失败"
                    break
                }
                self.loginFailClosure?()
            }
        }else if resp is SendMessageToWXResp{// 分享
            if resp.errCode == WXSuccess.rawValue{//分享成功
                strMsg = "分享成功"
            }else if resp.errCode == WXErrCodeCommon.rawValue {//普通错误类型
                strMsg = "分享失败：普通错误类型"
            }else if resp.errCode == WXErrCodeUserCancel.rawValue {//用户点击取消并返回
                strMsg = "分享失败：用户点击取消并返回"
            }else if resp.errCode == WXErrCodeSentFail.rawValue {//发送失败
                strMsg = "分享失败：发送失败"
            }else if resp.errCode == WXErrCodeAuthDeny.rawValue {//授权失败
                strMsg = "分享失败：授权失败"
            }else if resp.errCode == WXErrCodeUnsupport.rawValue {//微信不支持
                strMsg = "分享失败：微信不支持"
            }
        }
        
        MBProgressHUD.showAutoDismissHUD(message: strMsg)
    }
}

extension WXApiManager {
    // 检查用户是否已经安装微信并且有支付功能
    private func checkWXInstallAndSupport() -> Bool {
        if !WXApi.isWXAppInstalled() {
            ///这里的弹窗是我写的扩展方法
            GYZAlertViewTools.alertViewTools.showAlert(title: "温馨提示", message: "微信未安装", cancleTitle: nil, viewController: sender, buttonTitles: "确定")
            return false
        }
        if !WXApi.isWXAppSupport() {
            ///这里的弹窗是我写的扩展方法
            GYZAlertViewTools.alertViewTools.showAlert(title: "温馨提示", message: "当前微信版本不支持支付", cancleTitle: nil, viewController: sender, buttonTitles: "确定")
            return false
        }
        return true
    }
}
