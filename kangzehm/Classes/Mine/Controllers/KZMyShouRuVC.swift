//
//  KZMyShouRuVC.swift
//  kangze
//  零售收入
//  Created by gouyz on 2018/9/6.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let myShouRuCell = "myShouRuCell"
private let myShouRuHeader = "myShouRuHeader"

class KZMyShouRuVC: GYZBaseVC {
    
    let timeArr: [String] = ["当月","上个月","本季度","半年"]
    let typeArr: [String] = ["1","2","3","4"]
    var dataModel: KZShouRuModel?
    /// 选择时间type
    var selectType: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(0)
        }
        requestDatas()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /// 懒加载UITableView
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        
        table.register(KZMyShouRuCell.self, forCellReuseIdentifier: myShouRuCell)
        table.register(KZMyShouRuHeaderView.self, forHeaderFooterViewReuseIdentifier: myShouRuHeader)
        
        return table
    }()
    /// 选择时间
    @objc func onClickedSelectTime(){
        
        showSelectTime()
    }
    func showSelectTime(){
        GYZAlertViewTools.alertViewTools.showSheet(title: "选择时间", message: nil, cancleTitle: "取消", titleArray: timeArr, viewController: self) { [weak self](index) in
            
            if index != cancelIndex{
                self?.selectType = index
                
                self?.requestDatas()
            }
        }
    }
    
    ///获取收入数据
    func requestDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("member_invite&op=invite_one_ls",parameters: ["key": userDefaults.string(forKey: "key") ?? "","type":typeArr[selectType]],method : .post,  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["datas"].dictionaryObject else { return }
                
                weakSelf?.dataModel = KZShouRuModel.init(dict: data)
                if weakSelf?.dataModel?.is_have == "0"{
                    MBProgressHUD.showAutoDismissHUD(message: (weakSelf?.dataModel?.msg)!)
                }else{
                    weakSelf?.tableView.reloadData()
                }
                
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

extension KZMyShouRuVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataModel != nil {
            return (dataModel?.detailList?.count)! + 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: myShouRuCell) as! KZMyShouRuCell
        
        if indexPath.row == 0 {
            cell.nameLab.textColor = kBlueFontColor
            cell.nameLab.text = "姓名"
            cell.dateLab.textColor = kBlueFontColor
            cell.dateLab.text = "时间"
            cell.moneyLab.textColor = kBlueFontColor
            cell.moneyLab.text = "零售金额"
            cell.productLab.textColor = kBlueFontColor
            cell.productLab.text = "产品"
        }else{
            let model = dataModel?.detailList![indexPath.row - 1]
            cell.nameLab.textColor = kBlackFontColor
            cell.nameLab.text = model?.buyer_name
            cell.dateLab.textColor = kBlackFontColor
            cell.dateLab.text = model?.payment_time
            cell.moneyLab.textColor = kBlackFontColor
            cell.moneyLab.text = String.init(format: "￥%.2f", Double((model?.goods_pay_price)!)!)
            cell.productLab.textColor = kBlackFontColor
            cell.productLab.text = model?.goods_name
        }
        
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = kBackgroundColor
        }else{
            cell.contentView.backgroundColor = kWhiteColor
        }
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: myShouRuHeader) as! KZMyShouRuHeaderView
        
        headerView.timeLab.addOnClickListener(target: self, action: #selector(onClickedSelectTime))
        
        headerView.timeLab.text = timeArr[selectType]
        if dataModel != nil {
            headerView.moneyLab.text = String.init(format: "零售收入：￥%.2f", Double((dataModel?.total)!)!)
        }
        
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kTitleHeight
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kTitleHeight
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
