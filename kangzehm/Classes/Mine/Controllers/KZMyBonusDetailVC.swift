//
//  KZMyBonusDetailVC.swift
//  kangze
//  一级市场
//  Created by gouyz on 2018/9/6.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let myBonusDetailCell = "myBonusDetailCell"

class KZMyBonusDetailVC: GYZBaseVC {
    
    var dataList:[KZShouRuChildModel] = [KZShouRuChildModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.navigationItem.title = "一级市场"
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
        
        table.register(KZMyShouRuCell.self, forCellReuseIdentifier: myBonusDetailCell)
        
        return table
    }()
    
    ///获取奖金数据
    func requestDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("member_invite&op=invite_one_jj",parameters: ["key": userDefaults.string(forKey: "key") ?? ""],method : .post,  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["datas"]["list"].array else { return }
                
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = KZShouRuChildModel.init(dict: itemInfo)
                    weakSelf?.dataList.append(model)
                }
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.tableView.reloadData()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content: "您还没有下线会员")
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

extension KZMyBonusDetailVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: myBonusDetailCell) as! KZMyShouRuCell
        
        if indexPath.row == 0 {
            cell.nameLab.textColor = kBlueFontColor
            cell.nameLab.text = "客户"
            cell.dateLab.textColor = kBlueFontColor
            cell.dateLab.text = "时间"
            cell.moneyLab.textColor = kBlueFontColor
            cell.moneyLab.text = "金额"
            cell.productLab.textColor = kBlueFontColor
            cell.productLab.text = "产品"
        }else{
            let model = dataList[indexPath.row - 1]
            cell.nameLab.textColor = kBlackFontColor
            cell.nameLab.text = model.buyer_name
            cell.dateLab.textColor = kBlackFontColor
            cell.dateLab.text = model.payment_time
            cell.moneyLab.textColor = kBlackFontColor
            cell.moneyLab.text = String.init(format: "￥%.2f", Double(model.goods_pay_price!)!)
            cell.productLab.textColor = kBlackFontColor
            cell.productLab.text = model.goods_name
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
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = KZMyVIPManagerVC()
        vc.dataModel = dataList[indexPath.row - 1]
        navigationController?.pushViewController(vc, animated: true)
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kTitleHeight
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
