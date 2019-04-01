//
//  GYZTencentShare.swift
//  kangze
//  QQ 分享
//  Created by gouyz on 2018/9/20.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD


//MARK: - 分享
enum GYZTencentFlag {
    //  QQl列表 收藏。     电脑。     空间。   禁止分享到空间
    case QQ, Favorites, Dataline, QZone, QZoneForbid
}

typealias GYZTencentShare_loginFailedhandle = (_ error: String) -> Void
typealias GYZTencentShare_loginSuccessHandle = (_ info: [String: Any]) -> Void
typealias GYZTencentShare_resultHandle = (_ isSuccess: Bool, _ description: String) -> Void

class GYZTencentShare: NSObject {

    static let shared: GYZTencentShare = GYZTencentShare()
    private override init() { }
    
    fileprivate var appID: String = ""
    fileprivate var accessToken: String = ""
    fileprivate var tencentAuth: TencentOAuth!
    fileprivate var loginSuccess: GYZTencentShare_loginSuccessHandle? = nil
    fileprivate var loginFailsure: GYZTencentShare_loginFailedhandle? = nil
    fileprivate var shareResult: GYZTencentShare_resultHandle? = nil
    
    /// 是否安装QQ客户端
    ///
    /// - Returns: true: 安装; false: 未安装
    func isQQInstall() -> Bool {
        
        return TencentOAuth.iphoneQQInstalled()
    }
    
    /// QQ是否支持SSO授权登录
    ///
    /// - Returns: true: 支持; false: 不支持
    func isQQSupportSSO() -> Bool {
        return TencentOAuth.iphoneQQSupportSSOLogin()
    }
    
    func registeApp(_ appID: String) {
        
        GYZTencentShare.shared.appID = appID
        GYZTencentShare.shared.tencentAuth = TencentOAuth(appId: appID, andDelegate: GYZTencentShare.shared)
    }
    
    func handle(_ url: URL) -> Bool {
        
        // host: qzapp ; schem: tencent1105013800
        // response_from_qq    tencent1105013800
        
        if url.host == "qzapp" {
            // QQ授权登录
            return TencentOAuth.handleOpen(url)
        } else if url.host == "response_from_qq" {
            // QQ 分享
            return QQApiInterface.handleOpen(url, delegate: GYZTencentShare.shared)
        }
        
        return  true
    }
    
    func login(_ success: GYZTencentShare_loginSuccessHandle? = nil, failsure: GYZTencentShare_loginFailedhandle? = nil) {
        
        // 需要获取的用户信息
        let permissions = [kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO]
        GYZTencentShare.shared.tencentAuth.authorize(permissions)
        
        GYZTencentShare.shared.loginSuccess = success
        GYZTencentShare.shared.loginFailsure = failsure
    }
}

extension GYZTencentShare {
    
    /// 视频分享
    func shareVideo(_ url: URL, preImgUrl: URL? = nil, title: String, description: String? = nil, flag: GYZTencentFlag = .QQ, shareResultHandle: GYZTencentShare_resultHandle? = nil) {
        
        GYZTencentShare.shared.shareResult = shareResultHandle
        let obj = QQApiVideoObject(url: url, title: title, description: description, previewImageURL: preImgUrl, targetContentType: QQApiURLTargetTypeVideo)
        
        switch flag {
        case .QQ:
            obj?.cflag = UInt64(kQQAPICtrlFlagQQShare)
        case .Favorites:
            obj?.cflag = UInt64(kQQAPICtrlFlagQQShareFavorites)
        case .Dataline:
            obj?.cflag = UInt64(kQQAPICtrlFlagQQShareDataline)
        case .QZone:
            obj?.cflag = UInt64(kQQAPICtrlFlagQZoneShareOnStart)
        case .QZoneForbid:
            obj?.cflag = UInt64(kQQAPICtrlFlagQZoneShareForbid)
        }
        
        let req = SendMessageToQQReq(content: obj)
        
        // 分享到QZone
        if flag == .QZone {
            QQApiInterface.sendReq(toQZone: req)
        } else {
            // 分享到QQ
            QQApiInterface.send(req)
        }
    }
    /// 音乐分享
    func shareMusic(_ url: URL, title: String, description: String, preImgUrl: URL? = nil, flag: GYZTencentFlag = .QQ, shareResultHandle: GYZTencentShare_resultHandle? = nil) {
        
        GYZTencentShare.shared.shareResult = shareResultHandle
        let obj = QQApiAudioObject(url: url, title: title, description: description, previewImageURL: preImgUrl, targetContentType: QQApiURLTargetTypeAudio)
        //        let obj = QQApiAudioObject(url: URL!, title: String!, description: String!, previewImageData: Data!, targetContentType: QQApiURLTargetType)
        
        switch flag {
        case .QQ:
            obj?.cflag = UInt64(kQQAPICtrlFlagQQShare)
        case .Favorites:
            obj?.cflag = UInt64(kQQAPICtrlFlagQQShareFavorites)
        case .Dataline:
            obj?.cflag = UInt64(kQQAPICtrlFlagQQShareDataline)
        case .QZone:
            obj?.cflag = UInt64(kQQAPICtrlFlagQZoneShareOnStart)
        case .QZoneForbid:
            obj?.cflag = UInt64(kQQAPICtrlFlagQZoneShareForbid)
        }
        
        let req = SendMessageToQQReq(content: obj)
        
        // 分享到QZone
        if flag == .QZone {
            QQApiInterface.sendReq(toQZone: req)
        } else {
            // 分享到QQ
            QQApiInterface.send(req)
        }
    }
    ///新闻链接分享
    func shareNews(_ url: URL, preUrl: URL? = nil, preImage: Data? = nil, title: String? = nil, description: String? = nil, flag: GYZTencentFlag = .QQ, shareResultHandle: GYZTencentShare_resultHandle? = nil) {
        
        var obj : QQApiNewsObject?
        
        GYZTencentShare.shared.shareResult = shareResultHandle
        
        if preUrl != nil {// 网络图片
            obj = QQApiNewsObject(url: url, title: title, description: description, previewImageURL: preUrl, targetContentType: QQApiURLTargetTypeNews)
        }else{// 本地图片
            obj = QQApiNewsObject.init(url: url, title: title, description: description, previewImageData: preImage, targetContentType: QQApiURLTargetTypeNews)
        }
        
        switch flag {
        case .QQ:
            obj?.cflag = UInt64(kQQAPICtrlFlagQQShare)
        case .Favorites:
            obj?.cflag = UInt64(kQQAPICtrlFlagQQShareFavorites)
        case .Dataline:
            obj?.cflag = UInt64(kQQAPICtrlFlagQQShareDataline)
        case .QZone:
            obj?.cflag = UInt64(kQQAPICtrlFlagQZoneShareOnStart)
        case .QZoneForbid:
            obj?.cflag = UInt64(kQQAPICtrlFlagQZoneShareForbid)
        }
        
        let req = SendMessageToQQReq(content: obj)
        
        // 分享到QZone
        if flag == .QZone {
            QQApiInterface.sendReq(toQZone: req)
        } else {
            // 分享到QQ
            QQApiInterface.send(req)
        }
    }
    ///纯图片多图分享
    func shareImages(_ images: [Data], preImage: Data? = nil, title: String? = nil, description: String? = nil, shareResultHandle: GYZTencentShare_resultHandle? = nil) {
        GYZTencentShare.shared.shareResult = shareResultHandle
        // 多图不支持分享到QQ, 如果设置, 默认分享第一张
        // k可以分享多图到QQ收藏
        guard images.count > 0 else {
            return
        }
        
        let imgObj = QQApiImageObject(data: images.first, previewImageData: preImage, title: title, description: description, imageDataArray: images)
        
        imgObj?.cflag = UInt64(kQQAPICtrlFlagQQShareFavorites)
        let req = SendMessageToQQReq(content: imgObj)
        
        if Thread.current.isMainThread {
            QQApiInterface.send(req)
        } else {
            DispatchQueue.main.async {
                QQApiInterface.send(req)
            }
        }
    }
    ///纯图片分享
    func shareImage(_ imgData: Data, thumbData: Data? = nil, title: String? = nil, description: String? = nil, flag: GYZTencentFlag = .QQ, shareResultHandle: GYZTencentShare_resultHandle? = nil) {
        
        GYZTencentShare.shared.shareResult = shareResultHandle
        // 原图 最大5M
        // 预览图 最大 1M
        let imgObj = QQApiImageObject(data: imgData, previewImageData: thumbData, title: title, description: description)
        
        switch flag {
        case .QQ:
            imgObj?.cflag = UInt64(kQQAPICtrlFlagQQShare)
        case .Favorites:
            imgObj?.cflag = UInt64(kQQAPICtrlFlagQQShareFavorites)
        case .Dataline:
            imgObj?.cflag = UInt64(kQQAPICtrlFlagQQShareDataline)
        case .QZone:
            imgObj?.cflag = UInt64(kQQAPICtrlFlagQZoneShareOnStart)
        case .QZoneForbid:
            imgObj?.cflag = UInt64(kQQAPICtrlFlagQZoneShareForbid)
            
        }
        
        let req = SendMessageToQQReq(content: imgObj)
        
        if Thread.current.isMainThread {
            
            if flag == .QZone {
                QQApiInterface.sendReq(toQZone: req)
            } else {
                QQApiInterface.send(req)
            }
        } else {
            
            DispatchQueue.main.async {
                
                if flag == .QZone {
                    QQApiInterface.sendReq(toQZone: req)
                } else {
                    QQApiInterface.send(req)
                }
            }
        }
    }
    ///纯文本分享
    func shareText(_ text: String, flag: GYZTencentFlag = .QQ, shareResultHandle: GYZTencentShare_resultHandle? = nil) {
        
        GYZTencentShare.shared.shareResult = shareResultHandle
        let textObj = QQApiTextObject(text: text)
        textObj?.shareDestType = ShareDestTypeQQ // 分享到QQ 还是TIM, 必须指定
        
        switch flag {
        case .QQ:
            textObj?.cflag = UInt64(kQQAPICtrlFlagQQShare)
        case .Favorites:
            textObj?.cflag = UInt64(kQQAPICtrlFlagQQShareFavorites)
        case .Dataline:
            textObj?.cflag = UInt64(kQQAPICtrlFlagQQShareDataline)
        case .QZone:
            textObj?.cflag = UInt64(kQQAPICtrlFlagQZoneShareOnStart)
        case .QZoneForbid:
            textObj?.cflag = UInt64(kQQAPICtrlFlagQZoneShareForbid)
            
        }
        
        let req = SendMessageToQQReq(content: textObj)
        req?.message = textObj
        QQApiInterface.send(req)
    }
}


//    MARK: - QQApiInterfaceDelegate
extension GYZTencentShare: QQApiInterfaceDelegate {
    
    func onReq(_ req: QQBaseReq!) {
        
    }
    
    func onResp(_ resp: QQBaseResp!) {
        
        var strMsg: String = ""
        if resp is SendMessageToQQResp {
            let rs = resp as! SendMessageToQQResp
            if rs.type == 2 {
                // QQ分享返回的回调
                if rs.result == "0" {
                    // 分享成功
                    if let rs = self.shareResult {
                        rs(true, "分享成功")
                        strMsg = "分享成功"
                    }
                } else if rs.result == "-4" {
                    
                    if let rs = self.shareResult {
                        rs(false, "取消分享")
                        strMsg = "取消分享"
                    }
                } else {
                    
                    if let rs = self.shareResult {
                        rs(false, "分享失败")
                        strMsg = "分享失败"
                    }
                }
            }
        }
        
        MBProgressHUD.showAutoDismissHUD(message: strMsg)
    }
    
    func isOnlineResponse(_ response: [AnyHashable : Any]!) {
        
    }
}

//    MARK: - TencentSessionDelegate
extension GYZTencentShare: TencentSessionDelegate {
    
    func tencentDidLogin() {
        
        self.tencentAuth.getUserInfo()
        if let accessToken = self.tencentAuth.accessToken {
            // 获取accessToken
            self.accessToken = accessToken
        }
    }
    
    func tencentDidNotNetWork() {
        if let closure = self.loginFailsure {
            closure("网络异常")
        }
    }
    
    func tencentDidNotLogin(_ cancelled: Bool) {
        var strMsg: String = ""
        if cancelled {
            // 用户取消登录
            if let closure = self.loginFailsure {
                closure("用户取消登录")
                strMsg = "用户取消登录"
            }
        } else {
            // 登录失败
            if let closure = self.loginFailsure {
                closure("登录失败")
                strMsg = "登录失败"
            }
        }
        MBProgressHUD.showAutoDismissHUD(message: strMsg)
    }
    
    func getUserInfoResponse(_ response: APIResponse!) {
        
        let queue = DispatchQueue(label: "aaLoginQueue")
        queue.async {
            
            if response.retCode == 0 {
                
                if let res = response.jsonResponse {
                    
                    var info: [String: Any] = [:]
                    
                    info["rawData"] = res as? Dictionary<String, Any>
                    
                    if let uid = self.tencentAuth.getUserOpenID() {
                        info["uid"] = uid
                    }
                    
                    if let name = res["nickname"] as? String {
                        info["nickName"] = name
                    }
                    
                    if let sex = res["gender"] as? String {
                        info["sex"] = sex
                    }
                    
                    if let img = res["figureurl_qq_2"] as? String {
                        info["advatarStr"] = img
                    }
                    
                    DispatchQueue.main.async {
                        if let closure = self.loginSuccess {
                            
                            closure(info)
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    if let closure = self.loginFailsure {
                        closure("获取授权信息异常")
                    }
                }
            }
        }
    }
}

