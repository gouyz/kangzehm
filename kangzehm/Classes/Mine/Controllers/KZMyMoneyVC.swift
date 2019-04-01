//
//  KZMyMoneyVC.swift
//  kangze
//  我的财产
//  Created by gouyz on 2018/9/6.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class KZMyMoneyVC: GYZBaseVC {

    let titleArr : [String] = ["市场","业绩奖金"]
    var scrollPageView: ScrollPageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "我的账户"
        
        view.addSubview(headerView)
        setupUI()
        
        requestYuEInfo()
        setScrollView()
        
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    ///设置控制器
    func setChildVcs() -> [GYZBaseVC] {
        
//        let shouRuVC = KZMyShouRuVC()
//        let salebonusVC = KZMyBonusVC()
        let salebonusVC = KZMyBonusDetailVC()
        let bonusVC = KZMyTotalBonusVC()
        
        return [salebonusVC,bonusVC]
    }
    
    /// 设置scrollView
    func setScrollView(){
        // 这个是必要的设置
        automaticallyAdjustsScrollViewInsets = false
        
        var style = SegmentStyle()
        // 滚动条
        style.showLine = true
        style.scrollTitle = false
        // 颜色渐变
        style.gradualChangeTitleColor = true
        // 滚动条颜色
        style.scrollLineColor = kWhiteColor
        style.normalTitleColor = kBlackFontColor
        style.selectedTitleColor = kBlueFontColor
        /// 显示角标
        style.showBadge = false
        
        scrollPageView = ScrollPageView.init(frame: CGRect.init(x: 0, y: headerView.bottomY, width: kScreenWidth, height: self.view.frame.height - headerView.bottomY), segmentStyle: style, titles: titleArr, childVcs: setChildVcs(), parentViewController: self)
        view.addSubview(scrollPageView!)
    }
    /// header
    lazy var headerView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: kTitleAndStateHeight, width: kScreenWidth, height: 120))
        view.backgroundColor = kBlueFontColor
        
        return view
    }()
    
    func setupUI(){
        headerView.addSubview(desLab)
        headerView.addSubview(recordLab)
        headerView.addSubview(totalMoneyLab)
        headerView.addSubview(rechargeLab)
        headerView.addSubview(cashLab)
        
        desLab.snp.makeConstraints { (make) in
            make.top.equalTo(kMargin)
            make.left.equalTo(20)
            make.right.equalTo(recordLab.snp.left).offset(-kMargin)
            make.height.equalTo(34)
        }
        recordLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.height.equalTo(desLab)
            make.width.equalTo(60)
        }
        totalMoneyLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(desLab)
            make.top.equalTo(desLab.snp.bottom)
            make.bottom.equalTo(cashLab.snp.top).offset(-kMargin)
        }
        
        cashLab.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.bottom.equalTo(-kMargin)
            make.height.equalTo(20)
            make.width.equalTo(60)
        }
        rechargeLab.snp.makeConstraints { (make) in
            make.right.equalTo(cashLab.snp.left).offset(-20)
            make.bottom.width.height.equalTo(cashLab)
        }
    }
    
    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kWhiteColor
        lab.text = "我的余额："
        
        return lab
    }()
    /// 明细
    lazy var recordLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kWhiteColor
        lab.text = "明细"
        lab.textAlignment = .center
        lab.addOnClickListener(target: self, action: #selector(onClickedRecord))
        
        return lab
    }()
    
    /// 总额
    lazy var totalMoneyLab : UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 24.0)
        lab.textColor = kWhiteColor
        lab.text = "0.00"
        
        return lab
    }()
    /// 充值
    lazy var rechargeLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kWhiteColor
        lab.text = "充值"
        lab.textAlignment = .center
        lab.borderColor = kWhiteColor
        lab.borderWidth = klineWidth
        lab.cornerRadius = 10
        lab.addOnClickListener(target: self, action: #selector(onClickedRecharge))
        
        return lab
    }()
    /// 提现
    lazy var cashLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kWhiteColor
        lab.text = "提现"
        lab.textAlignment = .center
        lab.borderColor = kWhiteColor
        lab.borderWidth = klineWidth
        lab.cornerRadius = 10
        lab.addOnClickListener(target: self, action: #selector(onClickedCash))
        
        return lab
    }()
    /// 明细
    @objc func onClickedRecord(){
        
        let vc = KZYuERecordVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 充值
    @objc func onClickedRecharge(){
        let vc = KZRechargeVC()
        vc.resultBlock = {[weak self] () in
            self?.requestYuEInfo()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 提现
    @objc func onClickedCash(){
        let vc = KZCashVC()
        vc.resultBlock = {[weak self] () in
            self?.requestYuEInfo()
        }
        navigationController?.pushViewController(vc, animated: true)
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
                
                weakSelf?.totalMoneyLab.text = response["datas"]["predepoit"].stringValue
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
