//
//  KZApplyFriendsVC.swift
//  kangze
//  邀请好友
//  Created by gouyz on 2018/9/5.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class KZApplyFriendsVC: GYZBaseVC {
    
    /// 生成二维码内容
    var qrCodeConment: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "邀请好友"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_shared_black")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(clickedSharedBtn))
        
        setupUI()
        logoImgView.image = qrCodeConment.generateQRCode(size: 200, logo: UIImage.init(named: "icon_logo"))
        requestApplyFriend()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupUI(){
        view.addSubview(logoImgView)
        view.addSubview(desLab)
        view.addSubview(desLab1)
        view.addSubview(codeLab)
        
        desLab.snp.makeConstraints { (make) in
            make.top.equalTo(kTitleAndStateHeight + kMargin)
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.height.equalTo(kTitleHeight)
        }
        logoImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(desLab.snp.bottom).offset(kMargin)
            make.size.equalTo(CGSize.init(width: 200, height: 200))
        }
        desLab1.snp.makeConstraints { (make) in
            make.left.right.equalTo(desLab)
            make.top.equalTo(logoImgView.snp.bottom).offset(kTitleHeight)
            make.height.equalTo(kTitleHeight)
        }
        codeLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(desLab)
            make.top.equalTo(desLab1.snp.bottom)
            make.height.equalTo(kTitleHeight)
        }
    }
    
    /// 生成二维码logo
    lazy var logoImgView: UIImageView = UIImageView()
    
    /// 您的邀请二维码
    lazy var desLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "您的邀请二维码："
        lab.textAlignment = .center
        
        return lab
    }()
    /// 您的邀请链接
    lazy var desLab1: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "您的邀请码："
        lab.textAlignment = .center
        
        return lab
    }()
    ///
    fileprivate lazy var codeLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .center
        lab.backgroundColor = kWhiteColor
        lab.cornerRadius = kCornerRadius
        lab.text = userDefaults.string(forKey: "phone")
        
        return lab
    }()
    /// 分享
    @objc func clickedSharedBtn(){
        if qrCodeConment.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "您还不是代理型会员，无法邀请他人")
            return
        }
        showShareView()
    }
    
    /// 分享界面
    func showShareView(){
        
        let cancelBtn = [
            "title": "取消",
            "type": "danger"
        ]
        let mmShareSheet = MMShareSheet.init(title: "分享至", cards: kSharedCards, duration: nil, cancelBtn: cancelBtn)
        mmShareSheet.callBack = { [weak self](handler) ->() in
            
            if handler != "cancel" {// 取消
                if handler == kWXFriendShared || handler == kWXMomentShared{/// 微信分享
                    self?.weChatShared(tag: handler)
                }else{// QQ
                    self?.qqShared(tag: handler)
                }
            }
        }
        mmShareSheet.present()
    }
    /// 微信分享
    func weChatShared(tag: String){
        //发送给好友还是朋友圈（默认好友）
        var scene = WXSceneSession
        if tag == kWXMomentShared {//朋友圈
            scene = WXSceneTimeline
        }
        
        WXApiManager.shared.sendLinkURL(qrCodeConment, title: "邀请好友", description: "邀请好友", thumbImage: UIImage.init(named: "icon_logo")!, scene: scene,sender: self)
    }
    /// qq 分享
    func qqShared(tag: String){
        
        if !GYZTencentShare.shared.isQQInstall() {
            GYZAlertViewTools.alertViewTools.showAlert(title: "温馨提示", message: "QQ未安装", cancleTitle: nil, viewController: self, buttonTitles: "确定")
            return
        }
        //发送给好友还是QQ空间（默认好友）
        var scene: GYZTencentFlag = .QQ
        if tag == kQZoneShared {//QQ空间
            scene = .QZone
        }
        let imgData = UIImageJPEGRepresentation(UIImage.init(named: "icon_logo")!, 0.6)
        GYZTencentShare.shared.shareNews(URL.init(string: qrCodeConment)!, preUrl: nil, preImage: imgData, title: "邀请好友", description: "邀请好友", flag: scene) { (success, description) in
            
        }
    }
    
    /// 邀请好友
    func requestApplyFriend(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("member&op=get_yqm", parameters: ["key": userDefaults.string(forKey: "key") ?? ""],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                let data = response["datas"]
                
                weakSelf?.qrCodeConment = data["yqm_url"].stringValue
                weakSelf?.logoImgView.image = weakSelf?.qrCodeConment.generateQRCode(size: 200, logo: UIImage.init(named: "icon_logo"))
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
