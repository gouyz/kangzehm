//
//  KZYuERecordVC.swift
//  kangze
//  余额明细
//  Created by gouyz on 2018/9/6.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let yuERecordCell = "yuERecordCell"

class KZYuERecordVC: GYZBaseVC {
    
    var dataList: [KZYuERecordModel] = [KZYuERecordModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "余额明细"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(0)
        }
        requestYuERecordDatas()
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
        
        table.register(KZRecordCell.self, forCellReuseIdentifier: yuERecordCell)
        
        return table
    }()
    
    ///获取余额明细数据
    func requestYuERecordDatas(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("member_invite&op=get_my_pdlog",parameters: ["key": userDefaults.string(forKey: "key") ?? ""],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["datas"].array else { return }
                
                weakSelf?.dataList.removeAll()
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = KZYuERecordModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.tableView.reloadData()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content:"暂无余额明细")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
            //第一次加载失败，显示加载错误页面
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                weakSelf?.requestYuERecordDatas()
            })
        })
    }
}

extension KZYuERecordVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: yuERecordCell) as! KZRecordCell
        
        let model = dataList[indexPath.row]
        cell.titleLab.text = model.lg_add_time?.getDateTime(format: "yyyy-MM-dd HH:mm:ss")
        cell.statusLab.text = ""
//        cell.titleLab.text = model.type
//        cell.statusLab.text = model.lg_add_time?.getDateTime(format: "yyyy-MM-dd HH:mm:ss")
//        cell.statusLab.textColor = kHeightGaryFontColor
//        cell.statusLab.font = k13Font
        cell.moneyLab.text = model.lg_av_amount
        cell.dateLab.text = "余额：￥" + model.lg_cur_amount!
        
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
