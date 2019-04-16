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
        view.addSubview(managerDesLab)
        view.addSubview(managerBonusLab)
        view.addSubview(bonusDesLab)
        view.addSubview(bonusLab)
        view.addSubview(preMonthDesLab)
        view.addSubview(preMonthBonusLab)
        view.addSubview(monthDesLab)
        view.addSubview(monthBonusLab)
        
        managerDesLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
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
        preMonthDesLab.snp.makeConstraints { (make) in
            make.left.width.height.equalTo(managerDesLab)
            make.top.equalTo(managerBonusLab.snp.bottom).offset(20)
        }
        preMonthBonusLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(preMonthDesLab)
            make.top.equalTo(preMonthDesLab.snp.bottom)
        }
        monthDesLab.snp.makeConstraints { (make) in
            make.left.equalTo(bonusDesLab)
            make.top.height.width.equalTo(preMonthDesLab)
        }
        monthBonusLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(monthDesLab)
            make.top.height.equalTo(preMonthBonusLab)
        }
    }
    /// 管理奖
    lazy var managerDesLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlueFontColor
        lab.textAlignment = .center
        lab.text = "累计市场人数"
        
        return lab
    }()
    /// 管理奖
    lazy var managerBonusLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .center
        lab.text = "0"
        
        return lab
    }()
    /// 业绩奖
    lazy var bonusDesLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlueFontColor
        lab.textAlignment = .center
        lab.text = "累计直推积分"
        
        return lab
    }()
    /// 业绩奖
    lazy var bonusLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .center
        lab.text = "0"
        
        return lab
    }()
    
    /// 上月奖金
    lazy var preMonthDesLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlueFontColor
        lab.textAlignment = .center
        lab.text = "上月业绩积分"
        
        return lab
    }()
    /// 管理奖
    lazy var preMonthBonusLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .center
        lab.text = "0"
        
        return lab
    }()
    /// 业绩奖
    lazy var monthDesLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlueFontColor
        lab.textAlignment = .center
        lab.text = "本月业绩积分"
        
        return lab
    }()
    /// 业绩奖
    lazy var monthBonusLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .center
        lab.text = "0"
        
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
                weakSelf?.managerBonusLab.text = String.init(format: "%d", Double(data["num"].stringValue)!)
                weakSelf?.bonusLab.text =
                    String.init(format: "%.2f", Double(data["lingsou_jj"].stringValue)!)
                weakSelf?.preMonthBonusLab.text =
                    String.init(format: "%.2f", Double(data["yeji_jj_d"].stringValue)!)
                weakSelf?.monthBonusLab.text =
                    String.init(format: "%.2f", Double(data["yeji_jj"].stringValue)!)
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
