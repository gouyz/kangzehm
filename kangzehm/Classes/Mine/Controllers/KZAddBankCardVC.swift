//
//  KZAddBankCardVC.swift
//  kangze
//  添加银行卡
//  Created by gouyz on 2018/9/6.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class KZAddBankCardVC: GYZBaseVC {
    /// 选择结果回调
    var resultBlock:(() -> Void)?
    
    /// 只能是指定的4个银行
//    var isNeedBank: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "添加银行卡"
        view.addSubview(bgView)
        bgView.addSubview(personLab)
        bgView.addSubview(personField)
        bgView.addSubview(lineView)
        bgView.addSubview(cardNoLab)
        bgView.addSubview(cardNoField)
        bgView.addSubview(lineView1)
        bgView.addSubview(nameLab)
        bgView.addSubview(bankNameField)
        bgView.addSubview(lineView2)
        bgView.addSubview(noteLab)
        bgView.addSubview(saveBtn)
        
        bgView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(kMargin + kTitleAndStateHeight)
        }
        personLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(bgView)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
        personField.snp.makeConstraints { (make) in
            make.left.equalTo(personLab.snp.right).offset(kMargin)
            make.right.equalTo(-kMargin)
            make.top.bottom.equalTo(personLab)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(bgView)
            make.top.equalTo(personLab.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        cardNoLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(personLab)
            make.top.equalTo(lineView.snp.bottom)
        }
        cardNoField.snp.makeConstraints { (make) in
            make.left.right.equalTo(personField)
            make.top.bottom.equalTo(cardNoLab)
        }
        lineView1.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(cardNoLab.snp.bottom)
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(personLab)
            make.top.equalTo(lineView1.snp.bottom)
        }
        bankNameField.snp.makeConstraints { (make) in
            make.left.right.equalTo(personField)
            make.top.bottom.equalTo(nameLab)
        }
        lineView2.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(nameLab.snp.bottom)
        }
        noteLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(saveBtn)
            make.height.equalTo(kTitleHeight)
            make.top.equalTo(lineView2.snp.bottom)
        }
        saveBtn.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(noteLab.snp.bottom).offset(30)
            make.height.equalTo(kUIButtonHeight)
        }
        
//        cardNoField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        
        return view
    }()
    ///
    lazy var personLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "持卡人"
        
        return lab
    }()
    
    /// 输入内容
    lazy var personField : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
        textFiled.placeholder = "请绑定本人的银行卡"
        textFiled.clearButtonMode = .whileEditing
        
        return textFiled
    }()
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
    ///
    lazy var cardNoLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "卡号"
        
        return lab
    }()
    
    /// 输入内容
    lazy var cardNoField : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
        textFiled.placeholder = "请输入您的银行卡号"
        textFiled.keyboardType = .numberPad
        textFiled.clearButtonMode = .whileEditing
        
        return textFiled
    }()
    lazy var lineView1: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
    ///
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "银行"
        
        return lab
    }()
    
    /// 开户行名称输入内容
    lazy var bankNameField : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
        textFiled.placeholder = "请输入开户行名称"
        textFiled.clearButtonMode = .whileEditing
        
        return textFiled
    }()
    lazy var lineView2: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
    /// 备注
    lazy var noteLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kRedFontColor
        lab.numberOfLines = 2
//        lab.text = "目前仅支持建设银行、农业银行、中国银行、交通银行"
        
        return lab
    }()
    
    /// 确定
    lazy var saveBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("确定", for: .normal)
        btn.addTarget(self, action: #selector(clickedSaveBtn), for: .touchUpInside)
        
        return btn
    }()
    
    /// 确定
    @objc func clickedSaveBtn(){
        
        //除去前后空格,防止只输入空格的情况
        let content = personField.text?.trimmingCharacters(in: .whitespaces)
        if (content?.isEmpty)! {
            MBProgressHUD.showAutoDismissHUD(message: "请输入持卡人姓名")
            return
        }
        if (cardNoField.text?.isEmpty)! {
            MBProgressHUD.showAutoDismissHUD(message: "请输入银行卡号")
            return
        }
        if !GYZCheckTool.isBankCard(cardNoField.text!){
            MBProgressHUD.showAutoDismissHUD(message: "请输入正确的银行卡号")
            return
        }
        if (bankNameField.text?.isEmpty)! {
            MBProgressHUD.showAutoDismissHUD(message: "请输入开户行名称")
            return
        }
        requestAddBankCard()
    }
    
    ///添加银行卡
    func requestAddBankCard(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("member_card&op=add_card",parameters: ["card_name":personField.text!,"key": userDefaults.string(forKey: "key") ?? "","card_type": bankNameField.text!,"card_num": cardNoField.text!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                if weakSelf?.resultBlock != nil{
                    weakSelf?.resultBlock!()
                }
                weakSelf?.clickedBackBtn()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
//    func setBankData(){
//        let name = GYZCheckTool.getBankName(cardNoField.text)
//        var imgName: String = ""
//        if (name?.contains("建设银行"))! || (name?.contains("农业银行"))! || (name?.contains("中国银行"))! || (name?.contains("交通银行"))!{
//            isNeedBank = true
//            bankNameLab.text = name
//
//            if (name?.contains("建设银行"))! {
//                imgName = "icon_bank_jianse"
//            }else if (name?.contains("农业银行"))! {
//                imgName = "icon_bank_nongye"
//            }else if (name?.contains("中国银行"))! {
//                imgName = "icon_bank_china"
//            }else if (name?.contains("交通银行"))! {
//                imgName = "icon_bank_jiaotong"
//            }
//
//        }else{
//            MBProgressHUD.showAutoDismissHUD(message: "请绑定指定银行的银行卡")
//            isNeedBank = false
//            bankNameLab.text = ""
//        }
//        iconView.image = UIImage.init(named: imgName)
//    }
}
//extension KZAddBankCardVC : UITextFieldDelegate{
//    //编辑结束
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField.text?.count < 1 || textField.text?.count > 19 {
//            bankNameLab.text = ""
//            iconView.image = nil
//        }
//    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        if cardNoField.text?.count == 8 {
//            setBankData()
//        }
//        return true
//    }
//}
