//
//  KZCashVC.swift
//  kangze
//  提现
//  Created by gouyz on 2018/9/6.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class KZCashVC: GYZBaseVC {
    
    /// 选择结果回调
    var resultBlock:(() -> Void)?

    ///修改价格时输入是否有小数点
    var isHaveDian: Bool = false
    ///修改价格时输入第一位是否是0
    var isFirstZero: Bool = false
    
    var selectBankCardModel: KZBankModel?
    /// 余额
    var yuEMoney: String = "0"
    /// 提现规则
    var ruleModel: KZArticleModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "我的提现"
        
        let rightBtn = UIButton(frame: CGRect.init(x: 0, y: 0, width: 60, height: kTitleHeight))
        rightBtn.setTitle("提现记录", for: .normal)
        rightBtn.setTitleColor(kBlackFontColor, for: .normal)
        rightBtn.titleLabel?.font = k14Font
        rightBtn.addTarget(self, action: #selector(onClickedCashRecord), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        
        setUpUI()
        cashField.delegate = self
        
        bgBankView.isHidden = true
        requestYuEInfo()
        requestRuleDatas()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI(){
        
        view.addSubview(bgEmptyBankView)
        bgEmptyBankView.addSubview(checkBankLab)
        bgEmptyBankView.addSubview(rightIconView)
        
        view.addSubview(bgBankView)
        bgBankView.addSubview(iconView)
        bgBankView.addSubview(nameLab)
        bgBankView.addSubview(numberLab)
        bgBankView.addSubview(rightIconView1)
        
        view.addSubview(bgView)
        bgView.addSubview(cashLab)
        bgView.addSubview(moneyUnitLab)
        bgView.addSubview(cashField)
        bgView.addSubview(lineView)
        bgView.addSubview(cashMoneyLab)
        bgView.addSubview(allCashBtn)
        
        view.addSubview(cashNoteLab)
        view.addSubview(saveBtn)
        
        bgEmptyBankView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(kMargin + kTitleAndStateHeight)
            make.height.equalTo(60)
        }
        checkBankLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(rightIconView.snp.left).offset(-kMargin)
            make.centerY.equalTo(bgEmptyBankView)
            make.height.equalTo(30)
        }
        rightIconView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(bgEmptyBankView)
            make.size.equalTo(CGSize.init(width: 7, height: 12))
        }
        
        bgBankView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(kMargin + kTitleAndStateHeight)
            make.height.equalTo(60)
        }
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(bgBankView)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        }
        
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(kMargin)
            make.top.equalTo(iconView)
            make.right.equalTo(rightIconView1.snp.left).offset(-kMargin)
            make.height.equalTo(20)
        }
        numberLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
        }
        rightIconView1.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(bgEmptyBankView)
            make.size.equalTo(CGSize.init(width: 7, height: 12))
        }
        
        bgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.height.equalTo(120 + klineWidth)
            make.top.equalTo(kMargin * 2 + kTitleAndStateHeight + 60)
        }
        cashLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(bgView)
            make.right.equalTo(-kMargin)
            make.height.equalTo(30)
        }
        moneyUnitLab.snp.makeConstraints { (make) in
            make.left.equalTo(cashLab)
            make.top.equalTo(cashLab.snp.bottom)
            make.height.equalTo(50)
            make.width.equalTo(30)
        }
        cashField.snp.makeConstraints { (make) in
            make.left.equalTo(moneyUnitLab.snp.right)
            make.right.equalTo(-kMargin)
            make.top.bottom.equalTo(moneyUnitLab)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(cashLab)
            make.top.equalTo(moneyUnitLab.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        cashMoneyLab.snp.makeConstraints { (make) in
            make.left.equalTo(cashLab)
            make.top.equalTo(lineView.snp.bottom)
            make.height.equalTo(40)
            make.right.equalTo(allCashBtn.snp.left).offset(-kMargin)
            
        }
        allCashBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(cashMoneyLab)
            make.size.equalTo(CGSize.init(width: 80, height: 30))
        }
        cashNoteLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(bgView.snp.bottom).offset(20)
            make.height.equalTo(100)
        }
        saveBtn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(cashNoteLab.snp.bottom).offset(30)
            make.height.equalTo(kUIButtonHeight)
        }
    }
    
    //// 未选择银行卡显示
    lazy var bgEmptyBankView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        
        view.addOnClickListener(target: self, action: #selector(onClickedSelectBank))
        
        return view
    }()
    
    /// 选择银行卡
    var checkBankLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "选择银行卡"
        
        return lab
    }()
    /// 右侧箭头图标
    lazy var rightIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_arrow"))
    
    /// 选择银行卡显示
    lazy var bgBankView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        view.addOnClickListener(target: self, action: #selector(onClickedSelectBank))
        
        return view
    }()
    /// 图标
    lazy var iconView: UIImageView = UIImageView()
    
    /// 银行名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        
        return lab
    }()
    
    /// 银行卡尾号
    var numberLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kHeightGaryFontColor
        
        return lab
    }()
    /// 右侧箭头图标
    lazy var rightIconView1: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_arrow"))
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        
        return view
    }()
    /// 提现金额
    lazy var cashLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "提现金额（收取0.1%的手续费）"
        
        return lab
    }()
    /// 提现金额单位
    lazy var moneyUnitLab : UILabel = {
        let lab = UILabel()
        lab.font = k18Font
        lab.textColor = kBlackFontColor
        lab.text = "￥"
        
        return lab
    }()
    
    /// 输入内容
    lazy var cashField : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k18Font
        textFiled.textColor = kBlackFontColor
        textFiled.placeholder = "请输入提现金额"
        textFiled.keyboardType = .decimalPad
        textFiled.clearButtonMode = .whileEditing
        
        return textFiled
    }()
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
    /// 可提现金额
    lazy var cashMoneyLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kGaryFontColor
        lab.text = "可用余额￥0"
        
        return lab
    }()
    /// 全部提现
    lazy var allCashBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kWhiteColor
        btn.titleLabel?.font = k13Font
        btn.setTitleColor(kBlueFontColor, for: .normal)
        btn.setTitle("全部提现", for: .normal)
        btn.addTarget(self, action: #selector(clickedAllCashBtn), for: .touchUpInside)
        
        return btn
    }()
    
    /// 提现注意
    lazy var cashNoteLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kHeightGaryFontColor
        lab.numberOfLines = 0
//        lab.text = "说明\n1.每月最多提现一次\n2.每次最少提现100元\n3.提现1000元以上时，需出具发票寄回公司方可办理\n4.提现申请后预计三十个工作日内完成。"
        
        return lab
    }()
    
    /// 提  现
    lazy var saveBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("提现", for: .normal)
        btn.cornerRadius = kCornerRadius
        btn.addTarget(self, action: #selector(clickedSaveBtn), for: .touchUpInside)
        
        return btn
    }()
    
    /// 选择银行卡
    @objc func onClickedSelectBank(){
        let vc = KZMyBankVC()
        vc.resultBlock = {[weak self] (model) in
            self?.selectBankCardModel = model
            
            self?.setBankInfo()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setBankInfo(){
        if selectBankCardModel != nil {
            bgBankView.isHidden = false
            bgEmptyBankView.isHidden = true
            
            let name: String = (selectBankCardModel?.card_type)!
            var imgName: String = ""
            if name.contains("建设银行") {
                imgName = "icon_bank_jianse"
            }else if name.contains("农业银行") {
                imgName = "icon_bank_nongye"
            }else if name.contains("中国银行") {
                imgName = "icon_bank_china"
            }else if name.contains("交通银行") {
                imgName = "icon_bank_jiaotong"
            }
            iconView.image = UIImage.init(named: imgName)
            nameLab.text = name
            numberLab.text = selectBankCardModel?.end_num
            
        }else{
            bgBankView.isHidden = true
            bgEmptyBankView.isHidden = false
        }
        
    }
    
    /// 提现
    @objc func clickedSaveBtn(){
        
        if (cashField.text?.isEmpty)! {
            MBProgressHUD.showAutoDismissHUD(message: "请输入提现金额")
            return
        }
        if Double.init(cashField.text!) > Double.init(yuEMoney) {
            MBProgressHUD.showAutoDismissHUD(message: "提现金额不能大于可提现金额")
            return
        }
        
        if Double.init(cashField.text!) < 100 {
            MBProgressHUD.showAutoDismissHUD(message: "提现金额不能小于100元")
            return
        }
        
        if selectBankCardModel == nil {
            MBProgressHUD.showAutoDismissHUD(message: "请选择银行卡")
            return
        }
        
        requestApplyCash()
        
    }
    // 佣金提现申请
    func requestApplyCash(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("recharge&op=pd_cash_add",parameters: ["card_id":(selectBankCardModel?.id)!,"key": userDefaults.string(forKey: "key") ?? "","pdc_amount": cashField.text!],  success: { (response) in
            
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
    
    ///获取提现规则数据
    func requestRuleDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        weak var weakSelf = self
        GYZNetWork.requestNetwork("article&op=tx_rule",parameters: nil,  success: { (response) in
            
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["datas"].dictionaryObject else { return }
                
                weakSelf?.ruleModel = KZArticleModel.init(dict: data)
                weakSelf?.setRuleLab()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            
            GYZLog(error)
        })
    }
    
    func setRuleLab(){
        let attrStr = try! NSMutableAttributedString.init(data: (ruleModel?.article_content?.dealFuTextImgSize().data(using: .unicode, allowLossyConversion: true))!, options: [.documentType: NSAttributedString.DocumentType.html,
                                                                                                                                                                   .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        
        //调整行间距
        let paragraphStye = NSMutableParagraphStyle()
        
        paragraphStye.lineSpacing = 5
        let rang = NSMakeRange(0, attrStr.length)
        attrStr.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStye, range: rang)
        
        cashNoteLab.attributedText = attrStr
    }
    /// 全部提现
    @objc func clickedAllCashBtn(){
        
        cashField.text = yuEMoney
    }
    
    /// 提现记录
    @objc func onClickedCashRecord(){
        
        let recordVC = KZCashRecordManagerVC()
        navigationController?.pushViewController(recordVC, animated: true)
    }
    
    /// 获取余额数据
    func requestYuEInfo(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("member_index&op=my_asset&fields=predepoit", parameters: ["key": userDefaults.string(forKey: "key") ?? ""],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.yuEMoney = response["datas"]["predepoit"].stringValue
                weakSelf?.cashMoneyLab.text = "可用余额￥" + (weakSelf?.yuEMoney)!
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}

extension KZCashVC: UITextFieldDelegate{
    ////  MARK: UITextFieldDelegate
    //1.要求用户输入首位不能为小数点;
    //2.小数点后不超过两位，小数点无法输入超过一个;
    //3.如果首位为0，后面仅能输入小数点
    //MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        if ((textField.text?.range(of: ".")) == nil) {//是否输入点.
            isHaveDian = false
        }
        if ((textField.text?.range(of: "0")) == nil) {//首位是否输入0.
            isFirstZero = false
        }
        
        if string.count > 0 {
            //当前输入的字符
            let single = string[string.startIndex]
            //数据格式正确
            if (single >= "0" && single <= "9") || single == "." {
                if textField.text?.count == 0 {
                    //首字母不能为小数点
                    if single == "." {
                        return false
                    }else if single == "0" {
                        isFirstZero = true
                        return true
                    }
                }else{
                    if single == "." {
                        if isHaveDian {//不允许输入多个小数点
                            return false
                        } else {//text中还没有小数点
                            isHaveDian = true
                            return true
                        }
                    }else if single == "0" {
                        //首位有0有.（0.01）或首位没0有.（10200.00）可输入两位数的0
                        if (isHaveDian && isFirstZero) || (!isFirstZero && isHaveDian) {
                            
                            if textField.text == "0.0" {
                                return false
                            }
                            let ran = textField.text?.nsRange(from: (textField.text?.range(of: "."))!)
                            let tt = range.location - (ran?.location)!
                            //判断小数点后的位数,只允许输入2位
                            if tt <= 2 {
                                return true
                            }else{
                                return false
                            }
                        } else if isFirstZero && !isHaveDian{
                            //首位有0没.不能再输入0
                            return false
                        }else{
                            ///整数部分不能超过8位，与数据库匹配
                            if textField.text?.count > 7 {
                                return false
                            }
                            return true
                        }
                    }else{
                        if isHaveDian {//存在小数点，保留两位小数
                            let ran = textField.text?.nsRange(from: (textField.text?.range(of: "."))!)
                            let tt = range.location - (ran?.location)!
                            //判断小数点后的位数,只允许输入2位
                            if tt <= 2 {
                                return true
                            }else{
                                return false
                            }
                        } else if isFirstZero && !isHaveDian{
                            //首位有0没.不能再输入0
                            return false
                        }else{
                            ///整数部分不能超过8位，与数据库匹配
                            if textField.text?.count > 7 {
                                return false
                            }
                            return true
                        }
                    }
                }
            }else{
                //输入的数据格式不正确
                return false
            }
        }else{
            return true
        }
        return true
    }
}
