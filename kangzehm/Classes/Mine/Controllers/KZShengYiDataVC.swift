//
//  KZShengYiDataVC.swift
//  kangze
//  生意数据
//  Created by gouyz on 2018/9/7.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class KZShengYiDataVC: GYZBaseVC {
    
    let timeArr: [String] = ["当月","上个月","本季度","半年"]
    let typeArr: [String] = ["1","2","3","4"]
    /// 会员id
    var memberId: String = ""
    /// 选择时间type
    var selectType: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = kWhiteColor
        
        setupUI()
        
        requestDatas()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupUI(){
        view.addSubview(bgView)
        bgView.addSubview(bgTimeView)
        bgTimeView.addSubview(timeDesLab)
        bgTimeView.addSubview(timeLab)
        bgTimeView.addSubview(arrowImgView)
        bgTimeView.addSubview(moneyLab)
        
        view.addSubview(heHuoLab)
        view.addSubview(heHuoMoneyLab)
        view.addSubview(xuHuoLab)
        view.addSubview(xuHuoMoneyLab)
        
        bgView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(view)
            make.height.equalTo(64)
        }
        bgTimeView.snp.makeConstraints { (make) in
            make.left.right.equalTo(bgView)
            make.top.equalTo(kMargin)
            make.bottom.equalTo(-kMargin)
        }
        
        timeDesLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.bottom.equalTo(bgTimeView)
            make.width.equalTo(50)
        }
        timeLab.snp.makeConstraints { (make) in
            make.left.equalTo(timeDesLab.snp.right)
            make.top.bottom.equalTo(timeDesLab)
            make.width.equalTo(55)
        }
        arrowImgView.snp.makeConstraints { (make) in
            make.left.equalTo(timeLab.snp.right)
            make.centerY.equalTo(timeLab)
            make.size.equalTo(CGSize.init(width: 7, height: 4))
        }
        moneyLab.snp.makeConstraints { (make) in
            make.left.equalTo(arrowImgView.snp.right).offset(kMargin)
            make.top.bottom.equalTo(timeLab)
            make.right.equalTo(-kMargin)
        }
        
        heHuoLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(bgView.snp.bottom).offset(kMargin)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        heHuoMoneyLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(heHuoLab)
            make.top.equalTo(heHuoLab.snp.bottom)
        }
        xuHuoLab.snp.makeConstraints { (make) in
            make.left.equalTo(heHuoLab.snp.right).offset(kMargin)
            make.top.height.width.equalTo(heHuoLab)
        }
        xuHuoMoneyLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(xuHuoLab)
            make.height.top.equalTo(heHuoMoneyLab)
        }
    }
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    lazy var bgTimeView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        
        return view
    }()
    /// 时间
    lazy var timeDesLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "时间："
        
        return lab
    }()
    ///
    lazy var timeLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlueFontColor
        lab.textAlignment = .center
        lab.text = timeArr[selectType]
        lab.addOnClickListener(target: self, action: #selector(onClickedSelectTime))
        
        return lab
    }()
    lazy var arrowImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_arrow_down"))
    /// 销售额
    lazy var moneyLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlueFontColor
        lab.textAlignment = .right
        lab.text = "销售额：￥0.00"
        
        return lab
    }()
    
    /// 合伙人套餐
    lazy var heHuoLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlueFontColor
        lab.textAlignment = .center
        lab.text = "合伙人套餐"
        
        return lab
    }()
    /// 合伙人套餐
    lazy var heHuoMoneyLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .center
        lab.text = "￥0.00"
        
        return lab
    }()
    /// 续货套餐
    lazy var xuHuoLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlueFontColor
        lab.textAlignment = .center
        lab.text = "续货套餐"
        
        return lab
    }()
    /// 续货套餐
    lazy var xuHuoMoneyLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .center
        lab.text = "￥0.00"
        
        return lab
    }()
    
    /// 选择时间
    @objc func onClickedSelectTime(){
        
        showSelectTime()
    }
    func showSelectTime(){
        GYZAlertViewTools.alertViewTools.showSheet(title: "选择时间", message: nil, cancleTitle: "取消", titleArray: timeArr, viewController: self) { [weak self](index) in
            
            if index != cancelIndex{
                self?.selectType = index
                self?.timeLab.text = self?.timeArr[index]
                
                self?.requestDatas()
            }
        }
    }
    
    ///获取数据
    func requestDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("member_invite&op=get_taocan_total_by_member",parameters: ["key": userDefaults.string(forKey: "key") ?? "","type":typeArr[selectType],"member_id":memberId],method : .get,  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                let data = response["datas"]
                weakSelf?.moneyLab.text = String.init(format: "销售额：￥%.2f", Double(data["sell_total"].stringValue)!)
                weakSelf?.heHuoMoneyLab.text = String.init(format: "￥%.2f", Double(data["daili_total"].stringValue)!)
                weakSelf?.xuHuoMoneyLab.text = String.init(format: "￥%.2f", Double(data["xuhuo_total"].stringValue)!)
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                weakSelf?.requestDatas()
            })
        })
    }
}
