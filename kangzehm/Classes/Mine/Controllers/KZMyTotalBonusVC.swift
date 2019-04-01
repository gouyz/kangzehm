//
//  KZMyTotalBonusVC.swift
//  kangze
//  业绩奖金
//  Created by gouyz on 2018/9/27.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class KZMyTotalBonusVC: GYZBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = kWhiteColor
        
        setupUI()
        requestBonusData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupUI(){
        view.addSubview(desLab)
        view.addSubview(managerDesLab)
        view.addSubview(managerBonusLab)
        view.addSubview(bonusDesLab)
        view.addSubview(bonusLab)
        
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.height.equalTo(kTitleHeight)
        }
        managerDesLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(desLab.snp.bottom)
            make.width.equalTo(120)
            make.height.equalTo(30)
        }
        managerBonusLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(managerDesLab)
            make.top.equalTo(managerDesLab.snp.bottom)
        }
        bonusDesLab.snp.makeConstraints { (make) in
            make.left.equalTo(managerDesLab.snp.right).offset(kMargin)
            make.top.height.width.equalTo(managerDesLab)
        }
        bonusLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(bonusDesLab)
            make.height.top.equalTo(managerBonusLab)
        }
    }
    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "奖金日期："
        
        return lab
    }()
    /// 管理奖
    lazy var managerDesLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlueFontColor
        lab.textAlignment = .center
        lab.text = "管理奖金"
        
        return lab
    }()
    /// 管理奖
    lazy var managerBonusLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .center
        lab.text = "￥0"
        
        return lab
    }()
    /// 业绩奖
    lazy var bonusDesLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlueFontColor
        lab.textAlignment = .center
        lab.text = "业绩奖金"
        
        return lab
    }()
    /// 业绩奖
    lazy var bonusLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .center
        lab.text = "￥0"
        
        return lab
    }()
    
    /// 获取业绩奖金数据
    func requestBonusData(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("member_invite&op=get_my_jj", parameters: ["key": userDefaults.string(forKey: "key") ?? ""],method:.get,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                let data = response["datas"]
                weakSelf?.desLab.text = "奖金日期：" +  data["jj_time"].stringValue
                weakSelf?.managerBonusLab.text = String.init(format: "￥%.2f", Double(data["manage_jj"].stringValue)!)
                weakSelf?.bonusLab.text =
                    String.init(format: "￥%.2f", Double(data["yeji_jj"].stringValue)!)
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
