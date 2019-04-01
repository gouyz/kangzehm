//
//  BPRegisterVC.swift
//  BenefitPet
//  注册
//  Created by gouyz on 2018/7/27.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class BPRegisterVC: GYZBaseVC {

    ///记录获取的验证码
    var codeStr: String = ""
    /// 选择身份证正面图片
    var selectIDCardImg: UIImage?
    /// 选择身份证反面图片
    var selectIDCardBgImg: UIImage?
    
    /// 选择身份证正面图片
    var selectIDCardImgUrl: String = ""
    /// 选择身份证反面图片
    var selectIDCardBgImgUrl: String = ""
    /// 身份证号
    var idCardNo: String = ""
    /// 是否代注册
    var isDaiRegister: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = kWhiteColor
        
        setupUI()
        
        nameInputView.textFiled.isSecureTextEntry = false
        applyCodeInputView.textFiled.isSecureTextEntry = false
        idCardInputView.textFiled.isSecureTextEntry = false
        
        if isDaiRegister {
            self.navigationItem.title = "代注册"
            applyCodeInputView.textFiled.text = userDefaults.string(forKey: "phone")
        }else{
            self.navigationItem.title = "注 册"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 创建UI
    fileprivate func setupUI(){
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(phoneInputView)
        contentView.addSubview(lineView)
        contentView.addSubview(bgView)
        bgView.addSubview(codeInputView)
        bgView.addSubview(codeBtn)
        bgView.addSubview(lineView1)
        contentView.addSubview(pwdInputView)
        contentView.addSubview(lineView2)
        contentView.addSubview(repwdInputView)
        contentView.addSubview(lineView3)
        contentView.addSubview(nameInputView)
        contentView.addSubview(lineView4)
        contentView.addSubview(applyCodeInputView)
        contentView.addSubview(lineView5)
        contentView.addSubview(idCardInputView)
        contentView.addSubview(des3Lab)
        contentView.addSubview(lineView6)
        contentView.addSubview(des1Lab)
        contentView.addSubview(idCardImgView)
        contentView.addSubview(des2Lab)
        contentView.addSubview(idCardBgImgView)
        
        view.addSubview(okBtn)
        
        scrollView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(view)
            make.bottom.equalTo(okBtn.snp.top)
        }
        okBtn.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(kBottomTabbarHeight)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.left.width.equalTo(scrollView)
            make.top.equalTo(scrollView)
            make.bottom.equalTo(scrollView)
            // 这个很重要！！！！！！
            // 必须要比scroll的高度大一，这样才能在scroll没有填充满的时候，保持可以拖动
            make.height.greaterThanOrEqualTo(scrollView).offset(1)
        }
        
        phoneInputView.snp.makeConstraints { (make) in
            make.top.equalTo(kMargin)
            make.left.right.equalTo(view)
            make.height.equalTo(50)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(phoneInputView.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom)
            make.left.right.equalTo(phoneInputView)
            make.height.equalTo(phoneInputView)
        }
        codeInputView.snp.makeConstraints { (make) in
            make.top.equalTo(bgView)
            make.left.equalTo(bgView)
            make.right.equalTo(codeBtn.snp.left).offset(-kMargin)
            make.bottom.equalTo(lineView1.snp.top)
        }
        lineView1.snp.makeConstraints { (make) in
            make.left.right.equalTo(lineView)
            make.bottom.equalTo(bgView)
            make.height.equalTo(lineView)
        }
        codeBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(bgView)
            make.right.equalTo(bgView).offset(-kMargin)
            make.size.equalTo(CGSize.init(width: 100, height: 30))
        }
        pwdInputView.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom)
            make.left.right.equalTo(phoneInputView)
            make.height.equalTo(phoneInputView)
        }
        lineView2.snp.makeConstraints { (make) in
            make.left.right.equalTo(lineView)
            make.top.equalTo(pwdInputView.snp.bottom)
            make.height.equalTo(lineView)
        }
        
        repwdInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView2.snp.bottom)
            make.left.right.equalTo(phoneInputView)
            make.height.equalTo(phoneInputView)
        }
        lineView3.snp.makeConstraints { (make) in
            make.left.right.equalTo(lineView)
            make.top.equalTo(repwdInputView.snp.bottom)
            make.height.equalTo(lineView)
        }
        nameInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView3.snp.bottom)
            make.left.right.height.equalTo(phoneInputView)
        }
        lineView4.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(nameInputView.snp.bottom)
        }
        applyCodeInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView4.snp.bottom)
            make.left.right.height.equalTo(phoneInputView)
        }
        lineView5.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(applyCodeInputView.snp.bottom)
        }
        idCardInputView.snp.makeConstraints { (make) in
            make.left.height.equalTo(phoneInputView)
            make.right.equalTo(des3Lab.snp.left).offset(-5)
            make.top.equalTo(lineView5.snp.bottom)
        }
        des3Lab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.height.equalTo(idCardInputView)
            make.width.equalTo(100)
        }
        lineView6.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(idCardInputView.snp.bottom)
        }
        
        des1Lab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(lineView6.snp.bottom)
            make.height.equalTo(kTitleHeight)
        }
        idCardImgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(des1Lab)
            make.top.equalTo(des1Lab.snp.bottom).offset(kMargin)
            make.height.equalTo((kScreenWidth - kMargin * 2) * 0.56)
        }
        des2Lab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(des1Lab)
            make.top.equalTo(idCardImgView.snp.bottom).offset(kMargin)
        }
        idCardBgImgView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(idCardImgView)
            make.top.equalTo(des2Lab.snp.bottom).offset(kMargin)
            // 这个很重要，viewContainer中的最后一个控件一定要约束到bottom，并且要小于等于viewContainer的bottom
            // 否则的话，上面的控件会被强制拉伸变形
            // 最后的-10是边距，这个可以随意设置
            make.bottom.lessThanOrEqualTo(contentView).offset(-kMargin)
        }
        
    }
    /// scrollView
    var scrollView: UIScrollView = UIScrollView()
    /// 内容View
    var contentView: UIView = UIView()
    /// 手机号
    fileprivate lazy var phoneInputView : GYZLoginInputView = GYZLoginInputView(iconName: "icon_login_phone", placeHolder: "请输入手机号码", isPhone: true)
    
    /// 分割线
    fileprivate lazy var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 验证码
    fileprivate lazy var codeInputView : GYZLoginInputView = GYZLoginInputView(iconName: "icon_code", placeHolder: "请输入验证码", isPhone: true)
    
    /// 分割线2
    fileprivate lazy var lineView1 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    fileprivate lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        return view
    }()
    /// 密码
    fileprivate lazy var pwdInputView : GYZLoginInputView = GYZLoginInputView(iconName: "icon_login_pwd", placeHolder: "请输入新密码", isPhone: false)
    
    /// 分割线3
    fileprivate lazy var lineView2 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 确认密码
    fileprivate lazy var repwdInputView : GYZLoginInputView = GYZLoginInputView(iconName: "icon_login_pwd", placeHolder: "请再次输入新密码", isPhone: false)
    
    /// 分割线3
    fileprivate lazy var lineView3 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 姓名
    fileprivate lazy var nameInputView : GYZLoginInputView = GYZLoginInputView(iconName: "icon_register_name", placeHolder: "请输入您的姓名", isPhone: false)
    
    /// 分割线4
    fileprivate lazy var lineView4 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 邀请码
    fileprivate lazy var applyCodeInputView : GYZLoginInputView = GYZLoginInputView(iconName: "icon_register_qrcode", placeHolder: "请输入邀请码(选填)", isPhone: false)
    
    /// 分割线5
    fileprivate lazy var lineView5 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 身份证号码
    fileprivate lazy var idCardInputView : GYZLoginInputView = GYZLoginInputView(iconName: "icon_register_idcard", placeHolder: "请输入身份证号", isPhone: false)
    
    var des3Lab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlueFontColor
        lab.textAlignment = .right
        lab.text = "(代理商必填)"
        
        return lab
    }()
    /// 分割线6
    fileprivate lazy var lineView6 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    
    var des1Lab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "1.上传身份证正面照片"
        
        return lab
    }()
    /// 身份证正面照片
    lazy var idCardImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.cornerRadius = kCornerRadius
        imgView.image = UIImage.init(named: "icon_add_img_big")
        imgView.tag = 101
        imgView.addOnClickListener(target: self, action: #selector(onClickedSelectImg(sender:)))
        
        return imgView
    }()
    
    var des2Lab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "2.上传身份证反面照片"
        
        return lab
    }()
    /// 身份证反面照片
    lazy var idCardBgImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.cornerRadius = kCornerRadius
        imgView.image = UIImage.init(named: "icon_add_img_big")
        imgView.tag = 102
        imgView.addOnClickListener(target: self, action: #selector(onClickedSelectImg(sender:)))
        
        return imgView
    }()
    /// 获取验证码按钮
    fileprivate lazy var codeBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("发送验证码", for: .normal)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k13Font
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = kBtnClickBGColor
        btn.addTarget(self, action: #selector(clickedCodeBtn(btn:)), for: .touchUpInside)
        
        btn.cornerRadius = kCornerRadius
        
        return btn
    }()
    
    /// 确定按钮
    fileprivate lazy var okBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.setTitle("确 认", for: .normal)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k15Font
        
        btn.addTarget(self, action: #selector(clickedOkBtn(btn:)), for: .touchUpInside)

        return btn
    }()
    
    
    /// 注册
    @objc func clickedOkBtn(btn: UIButton){
        hiddenKeyBoard()
        
        if !validPhoneNO() {
            return
        }
        if codeInputView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入验证码",isBottom:false)
            return
        }
        if codeInputView.textFiled.text! != codeStr {
            MBProgressHUD.showAutoDismissHUD(message: "验证码不正确",isBottom:false)
            return
        }

        if pwdInputView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入密码")
            return
        }
        if repwdInputView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入确认密码")
            return
        }

        if pwdInputView.textFiled.text != repwdInputView.textFiled.text {
            MBProgressHUD.showAutoDismissHUD(message: "新密码与确认密码不一致")
            return
        }
//        if applyCodeInputView.textFiled.text!.isEmpty {
//            MBProgressHUD.showAutoDismissHUD(message: "请输入邀请码")
//            return
//        }
        if nameInputView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入姓名")
            return
        }
        if !idCardInputView.textFiled.text!.isEmpty {
            if !(idCardInputView.textFiled.text?.IsIdentityCard())!{
                MBProgressHUD.showAutoDismissHUD(message: "请输入正确的身份证号")
                return
            }
            
            idCardNo = idCardInputView.textFiled.text!
        }
        createHUD(message: "注册中...")
        if selectIDCardImg != nil {
            requestUpLoadImg(img: selectIDCardImg!, isBgImg: false)
        }else if selectIDCardBgImg != nil {
            requestUpLoadImg(img: selectIDCardBgImg!, isBgImg: true)
        }else{
           requestRegister()
        }
    }
    /// 判断手机号是否有效
    ///
    /// - Returns:
    func validPhoneNO() -> Bool{
        
        if phoneInputView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入手机号")
            return false
        }
        if phoneInputView.textFiled.text!.isMobileNumber(){
            return true
        }else{
            MBProgressHUD.showAutoDismissHUD(message: "请输入正确的手机号")
            return false
        }
        
    }
    /// 获取验证码
    @objc func clickedCodeBtn(btn: UIButton){
        hiddenKeyBoard()
//        codeBtn.startSMSWithDuration(duration: 60)
        if validPhoneNO() {
            requestCode()
        }
    }
    
    /// 注册
    func requestRegister(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        
        GYZNetWork.requestNetwork("login&op=register", parameters: ["username":nameInputView.textFiled.text!,"password": pwdInputView.textFiled.text!,"mobile": phoneInputView.textFiled.text!,"password_confirm": repwdInputView.textFiled.text!,"inviter_code": applyCodeInputView.textFiled.text!,"shenfen_code": idCardNo,"sf_code_img1":selectIDCardImgUrl,"sf_code_img2":selectIDCardBgImgUrl,"mobilecode":codeInputView.textFiled.text!,"client": "ios"],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            //            GYZLog(response)
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                if !(weakSelf?.isDaiRegister)! {///注册时保存数据，代注册时直接返回
                    let data = response["datas"]
                    
                    userDefaults.set(true, forKey: kIsLoginTagKey)//是否登录标识
                    userDefaults.set(data["userid"].stringValue, forKey: "userId")//用户ID
                    userDefaults.set(weakSelf?.phoneInputView.textFiled.text!, forKey: "phone")//用户电话
                    userDefaults.set(data["is_shehe"].stringValue, forKey: "is_shehe")//是否完成实名认证
                    userDefaults.set(data["is_buydl"].stringValue, forKey: "is_buydl")//是否完成合伙人套餐购买认证   1.是     0.否
                    userDefaults.set(data["username"].stringValue, forKey: "username")//用户名称
                    userDefaults.set(data["key"].stringValue, forKey: "key")//key
                }
                KeyWindow.rootViewController = GYZMainTabBarVC()
//                _ = weakSelf?.navigationController?.popViewController(animated: true)
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /// 隐藏键盘
    func hiddenKeyBoard(){
        phoneInputView.textFiled.resignFirstResponder()
        pwdInputView.textFiled.resignFirstResponder()
        codeInputView.textFiled.resignFirstResponder()
        repwdInputView.textFiled.resignFirstResponder()
        nameInputView.textFiled.resignFirstResponder()
        applyCodeInputView.textFiled.resignFirstResponder()
        idCardInputView.textFiled.resignFirstResponder()
    }
    
    ///获取验证码
    func requestCode(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "获取中...")
        
        GYZNetWork.requestNetwork("connect&op=get_sms_captcha", parameters: ["phone":phoneInputView.textFiled.text!,"type": "1"],method :.get,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                let data = response["datas"]
                weakSelf?.codeStr = data["captcha"].stringValue
                weakSelf?.codeBtn.startSMSWithDuration(duration: data["sms_time"].intValue)
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 选择图片
    @objc func onClickedSelectImg(sender: UITapGestureRecognizer){
        
        let tag = sender.view?.tag
        GYZOpenCameraPhotosTool.shareTool.choosePicture(self, editor: false, finished: { [weak self] (image) in
            
            if tag == 101 {
                self?.selectIDCardImg = image
                self?.idCardImgView.image = image
            }else{
                self?.selectIDCardBgImg = image
                self?.idCardBgImgView.image = image
            }
        })
    }
    
    /// 上传头像
    func requestUpLoadImg(img : UIImage,isBgImg: Bool){
        
        if !GYZTool.checkNetWork() {
            return
        }
        weak var weakSelf = self
        
        let imgParam: ImageFileUploadParam = ImageFileUploadParam()
        imgParam.name = "image"
        imgParam.fileName = "idCardImg.png"
        imgParam.mimeType = "image/png"
        imgParam.data = UIImageJPEGRepresentation(img, 0.5)
        
        GYZNetWork.uploadImageRequest("upload&op=sfz_upload", uploadParam: [imgParam], success: { (response) in
            
            GYZLog(response)
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                let data = response["datas"]
                if isBgImg{/// 身份证反面
                    weakSelf?.selectIDCardBgImgUrl = data["img"].stringValue
                    weakSelf?.requestRegister()
                }else{
                    weakSelf?.selectIDCardImgUrl = data["img"].stringValue
                    
                    if weakSelf?.selectIDCardBgImg != nil{
                        weakSelf?.requestUpLoadImg(img: (weakSelf?.selectIDCardBgImg)!, isBgImg: true)
                    }else{
                        weakSelf?.requestRegister()
                    }
                }
                
            }else{
                weakSelf?.hud?.hide(animated: true)
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
