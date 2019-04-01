//
//  KZCashRecordVC.swift
//  kangze
//
//  Created by gouyz on 2018/9/6.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let cashRecordCell = "cashRecordCell"

class KZCashRecordVC: GYZBaseVC {

    /// 状态值 0待打款 1已打款 2，已拒绝 99，全部记录
    var status: String = "99"
    var dataList: [KZCashRecordModel] = [KZCashRecordModel]()
    var currPage : Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(0)
        }
        requestRecordDatas()
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
        table.separatorColor = kGrayLineColor
        
        table.register(KZRecordCell.self, forCellReuseIdentifier: cashRecordCell)
        
        return table
    }()
    
    ///获取提现记录数据
    func requestRecordDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("member_fund&op=pdcashlist",parameters: ["key": userDefaults.string(forKey: "key") ?? "","type": status],method : .get,  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["datas"]["list"].array else { return }
                
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = KZCashRecordModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.tableView.reloadData()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content: "暂无提现记录")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                weakSelf?.requestRecordDatas()
                weakSelf?.hiddenEmptyView()
            })
        })
    }
   
}

extension KZCashRecordVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cashRecordCell) as! KZRecordCell
        
        let model = dataList[indexPath.row]
        cell.titleLab.text = "提现"
        cell.dateLab.text = model.pdc_add_time?.getDateTime(format: "yyyy-MM-dd HH:mm:ss")
        cell.moneyLab.text = "+" + model.pdc_amount!
        
        ///提现状态0未打款 1已打款 2已拒绝
        var cashStatus = ""
        if model.pdc_payment_state == "0" {
            cashStatus = "待打款"
        }else if model.pdc_payment_state == "1" {
            cashStatus = "已打款"
        }else if model.pdc_payment_state == "2" {
            cashStatus = "已拒绝"
        }
        
        cell.statusLab.text = cashStatus
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
