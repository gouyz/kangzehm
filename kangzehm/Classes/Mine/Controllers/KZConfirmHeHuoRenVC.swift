//
//  KZConfirmHeHuoRenVC.swift
//  kangze
//  合伙人认证
//  Created by gouyz on 2018/9/5.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class KZConfirmHeHuoRenVC: GYZBaseVC {
    
    /// 是否实名认证
    var isConfirmUserInfo: Bool = false
    /// 是否购买认证
    var isConfirmBuy: Bool = false
    
    var goodsId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "合伙人认证"
        self.view.backgroundColor = kWhiteColor
        
        setupUI()
        
        requestGetGoodsId()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestConfirmUserInfo()
    }
    
    func setupUI(){
        view.addSubview(bgView)
        bgView.addSubview(realNameLab)
        bgView.addSubview(nameStatusLab)
        bgView.addSubview(rightIconView1)
        view.addSubview(lineView1)
        
        view.addSubview(personView)
        personView.addSubview(heHuoPersonLab)
        personView.addSubview(buyStatusLab)
        personView.addSubview(rightIconView2)
        view.addSubview(lineView2)
        
        bgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(kTitleAndStateHeight)
            make.height.equalTo(50)
        }
        realNameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(nameStatusLab.snp.left).offset(-kMargin)
            make.top.bottom.equalTo(bgView)
        }
        nameStatusLab.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(realNameLab)
            make.right.equalTo(rightIconView1.snp.left).offset(-kMargin)
            make.width.equalTo(60)
        }
        rightIconView1.snp.makeConstraints { (make) in
            make.centerY.equalTo(realNameLab)
            make.right.equalTo(-kMargin)
            make.size.equalTo(CGSize.init(width: 7, height: 12))
        }
        lineView1.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(bgView.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        
        personView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(bgView)
            make.top.equalTo(lineView1.snp.bottom)
        }
        heHuoPersonLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(buyStatusLab.snp.left).offset(-kMargin)
            make.top.bottom.equalTo(personView)
        }
        buyStatusLab.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(heHuoPersonLab)
            make.right.equalTo(rightIconView2.snp.left).offset(-kMargin)
            make.width.equalTo(nameStatusLab)
        }
        rightIconView2.snp.makeConstraints { (make) in
            make.centerY.equalTo(heHuoPersonLab)
            make.right.size.equalTo(rightIconView1)
        }
        lineView2.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView1)
            make.top.equalTo(personView.snp.bottom)
        }
    }

    ///
    lazy var bgView : UIView = {
        let view = UIView()
        view.addOnClickListener(target: self, action: #selector(onClickedRealNameConfirm))
        
        return view
    }()
    /// 实名身份认证
    lazy var realNameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "实名身份认证"
        
        return lab
    }()
    
    /// 实名身份认证 状态
    var nameStatusLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kGaryFontColor
        lab.textAlignment = .right
        lab.text = "未完成"
        
        return lab
    }()
    /// 右侧箭头图标
    lazy var rightIconView1: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_arrow"))
    
    /// 分割线
    var lineView1 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    
    ///
    lazy var personView : UIView = {
        let view = UIView()
        view.addOnClickListener(target: self, action: #selector(onClickedHeHuoRenConfirm))
        
        return view
    }()
    /// 合伙人套餐购买认证
    lazy var heHuoPersonLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "合伙人套餐购买认证"
        
        return lab
    }()
    
    /// 合伙人套餐购买认证 状态
    var buyStatusLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kGaryFontColor
        lab.textAlignment = .right
        lab.text = "未完成"
        
        return lab
    }()
    /// 右侧箭头图标
    lazy var rightIconView2: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_arrow"))
    
    /// 分割线
    var lineView2 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    ///实名身份认证
    @objc func onClickedRealNameConfirm(){
        
        if isConfirmUserInfo {
            MBProgressHUD.showAutoDismissHUD(message: "已认证，不需要再次认证")
            return
        }
        
        let vc = KZRealNameConfirmVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    ///合伙人套餐购买认证
    @objc func onClickedHeHuoRenConfirm(){
        if isConfirmBuy {
            MBProgressHUD.showAutoDismissHUD(message: "已认证，不需要再次认证")
            return
        }
        
//        self.tabBarController?.selectedIndex = 0
//        navigationController?.popToRootViewController(animated: true)
        let vc = KZGoodsDetailVC()
        vc.goodsId = goodsId
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 获取代理型套餐商品id
    func requestGetGoodsId(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        
        GYZNetWork.requestNetwork("goods&op=get_hhr_goods_id",parameters: ["key": userDefaults.string(forKey: "key") ?? ""],  success: { (response) in
            
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.goodsId = response["datas"]["goods_id"].stringValue
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            
            GYZLog(error)
        })
    }
    
    ///查看当前用户是否完善了信息
    func requestConfirmUserInfo(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("member&op=check_hur_rz",parameters: ["key": userDefaults.string(forKey: "key") ?? ""],  success: { (response) in
            
//            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.requestConfirmBuy()
                let data = response["datas"]["is_rz"].stringValue
                var str = "未完成"
                if data == "1"{
                    str = "已完成"
                    weakSelf?.isConfirmUserInfo = true
                    weakSelf?.nameStatusLab.textColor = kBlueFontColor
                }else{
                    weakSelf?.isConfirmUserInfo = false
                    weakSelf?.nameStatusLab.textColor = kGaryFontColor
                }
                
                weakSelf?.nameStatusLab.text = str
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
                weakSelf?.hud?.hide(animated: true)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    ///查看当前用户是否完成了合伙人套餐购买认证
    func requestConfirmBuy(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        
        GYZNetWork.requestNetwork("member&op=check_hur_rz2",parameters: ["key": userDefaults.string(forKey: "key") ?? ""],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                let data = response["datas"]["is_rz"].stringValue
                var str = "未完成"
                if data == "1"{
                    str = "已完成"
                    weakSelf?.isConfirmBuy = true
                    weakSelf?.buyStatusLab.textColor = kBlueFontColor
                }else{
                    weakSelf?.isConfirmBuy = false
                    weakSelf?.buyStatusLab.textColor = kGaryFontColor
                }
                
                weakSelf?.buyStatusLab.text = str
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
