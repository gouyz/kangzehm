//
//  KZCustomerInfoVC.swift
//  kangze
//  客户管理
//  Created by gouyz on 2018/9/7.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class KZCustomerInfoVC: GYZBaseVC {
    
    /// 会员id
    var memberId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = kWhiteColor
        
        setupUI()
        requestCustomerData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupUI(){
        view.addSubview(desLab)
        view.addSubview(saleLab)
        view.addSubview(saleNumberLab)
        view.addSubview(daiLiLab)
        view.addSubview(daiLiNumberLab)
        
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.height.equalTo(kTitleHeight)
        }
        saleLab.snp.makeConstraints { (make) in
            make.left.equalTo(desLab)
            make.top.equalTo(desLab.snp.bottom).offset(kMargin)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        saleNumberLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(saleLab)
            make.top.equalTo(saleLab.snp.bottom)
        }
        daiLiLab.snp.makeConstraints { (make) in
            make.left.equalTo(saleLab.snp.right).offset(kMargin)
            make.top.height.width.equalTo(saleLab)
        }
        daiLiNumberLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(daiLiLab)
            make.height.top.equalTo(saleNumberLab)
        }
    }
    
    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "概述"
        
        return lab
    }()
    /// 零售人数
    lazy var saleLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlueFontColor
        lab.textAlignment = .center
        lab.text = "零售人数"
        
        return lab
    }()
    /// 零售人数
    lazy var saleNumberLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .center
        lab.text = "0"
        
        return lab
    }()
    /// 代理人数
    lazy var daiLiLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlueFontColor
        lab.textAlignment = .center
        lab.text = "招商人数"
        
        return lab
    }()
    /// 代理人数
    lazy var daiLiNumberLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .center
        lab.text = "0"
        
        return lab
    }()
    
    /// 获取客户管理数据
    func requestCustomerData(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("member&op=get_my_sub_member", parameters: ["key": userDefaults.string(forKey: "key") ?? "","member_id":memberId],method:.get,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                let data = response["datas"]
                weakSelf?.saleNumberLab.text = data["ls_member"].stringValue
                weakSelf?.daiLiNumberLab.text = data["dl_member"].stringValue
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
