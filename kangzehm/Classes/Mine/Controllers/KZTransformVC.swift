//
//  KZTransformVC.swift
//  kangzehm
//  转让
//  Created by gouyz on 2019/5/27.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class KZTransformVC: GYZBaseVC {
    var typeValue: String = "1"
    var typePlace: String = "请输入转让的积分数量"

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        if typeValue == "2" {
            typePlace = "请输入转让的库存数量"
        }
        numberView.textFiled.placeholder = typePlace
    }
    func setUpUI(){
        
        view.addSubview(numberView)
        view.addSubview(lineView)
        view.addSubview(accountView)
        view.addSubview(lineView1)
        
        view.addSubview(submitBtn)
        
        numberView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.height.equalTo(50)
            make.top.equalTo(kMargin + kTitleAndStateHeight)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(numberView.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        accountView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(numberView)
            make.top.equalTo(lineView.snp.bottom)
        }
        lineView1.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(accountView.snp.bottom)
        }
        submitBtn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(kBottomTabbarHeight)
            make.top.equalTo(lineView1.snp.bottom).offset(60)
        }
    }
    /// 转让数量
    lazy var numberView : GYZLabAndFieldView = {
        let lab = GYZLabAndFieldView.init()
        lab.desLab.text = "转让数量："
        lab.textFiled.keyboardType = .numberPad
        
        return lab
    }()
    /// 线
    lazy var lineView: UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    /// 转让账号
    lazy var accountView : GYZLabAndFieldView = {
        let lab = GYZLabAndFieldView.init(desName: "转让账号：", placeHolder: "请输入转让账号", isPhone: true)
        
        return lab
    }()
    /// 线
    lazy var lineView1: UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    /// 完成
    lazy var submitBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("确  定", for: .normal)
        btn.cornerRadius = kCornerRadius
        btn.addTarget(self, action: #selector(clickedSubmitBtn), for: .touchUpInside)
        
        return btn
    }()
    /// 完成
    @objc func clickedSubmitBtn(){
        if numberView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入转让数量")
            return
        }
        if accountView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入转让账号")
            return
        }
        
        requestTransform()
    }
    ///转让
    func requestTransform(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("member&op=exchange",parameters: ["key": userDefaults.string(forKey: "key") ?? ""," num": numberView.textFiled.text!," to_mobile": accountView.textFiled.text!," kind": typeValue],method :.get,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                MBProgressHUD.showAutoDismissHUD(message: "转让成功")
                weakSelf?.clickedBackBtn()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
