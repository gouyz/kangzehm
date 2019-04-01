//
//  KZMyBonusVC.swift
//  kangze
//  零售奖金
//  Created by gouyz on 2018/9/6.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let myBonusCell = "myBonusCell"

class KZMyBonusVC: GYZBaseVC {
    
    let titleArr : [String] = ["一级市场","二级市场","三级市场"]
    
    var contentArr:[String] = [String]()
    /// 零售奖金
    var saleBonus: String = "0"

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
        
        table.register(KZMyBonusCell.self, forCellReuseIdentifier: myBonusCell)
        weak var weakSelf = self
        ///添加下拉刷新
        GYZTool.addPullRefresh(scorllView: table, pullRefreshCallBack: {
            weakSelf?.requestDatas()
        })
        
        return table
    }()
    /// 关闭上拉/下拉刷新
    func closeRefresh(){
        if tableView.mj_header.isRefreshing{//下拉刷新
            GYZTool.endRefresh(scorllView: tableView)
        }
        //        else if tableView.mj_footer.isRefreshing{//上拉加载更多
        //            GYZTool.endLoadMore(scorllView: tableView)
        //        }
    }
    
    ///获取奖金数据
    func requestDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("member_invite&op=invite_jj",parameters: ["key": userDefaults.string(forKey: "key") ?? ""],method : .get,  success: { (response) in
            
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
            
                guard let data = response["datas"].array else { return }
                
                weakSelf?.contentArr.removeAll()
                for item in data{
                    weakSelf?.contentArr.append(item.stringValue)
                }
                
                weakSelf?.requestBonusDatas()
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
                weakSelf?.hiddenLoadingView()
                weakSelf?.closeRefresh()
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            weakSelf?.closeRefresh()
            GYZLog(error)
            
        })
    }
    
    ///获取零售奖金数据
    func requestBonusDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        
        GYZNetWork.requestNetwork("member_invite&op=get_ls_jj",parameters: ["key": userDefaults.string(forKey: "key") ?? ""],method : .get,  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            weakSelf?.closeRefresh()
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                let data = response["datas"]
                
                weakSelf?.saleBonus = data["lingsou_jj"].stringValue
                
                weakSelf?.tableView.reloadData()
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            
            GYZLog(error)
            weakSelf?.hiddenLoadingView()
            weakSelf?.closeRefresh()
        })
    }
    
}

extension KZMyBonusVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: myBonusCell) as! KZMyBonusCell
        
        if indexPath.row == titleArr.count {
            cell.lineView.isHidden = true
            cell.nameLab.text = ""
            cell.moneyLab.text = "零售奖金：￥" + String.init(format: "%.2f", Double(saleBonus)!)
        }else{
            cell.lineView.isHidden = false
            cell.nameLab.text = titleArr[indexPath.row]
            if contentArr.count == titleArr.count {
                cell.moneyLab.text = "本月销售业绩：￥" + String.init(format: "%.2f", Double(contentArr[indexPath.row])!)
            }
        }
        if indexPath.row == 0 {
            cell.rightIconView.isHidden = false
        }else{
            cell.rightIconView.isHidden = true
        }
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = KZMyBonusDetailVC()
            navigationController?.pushViewController(vc, animated: true)
        }
    
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kTitleHeight + kMargin
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
