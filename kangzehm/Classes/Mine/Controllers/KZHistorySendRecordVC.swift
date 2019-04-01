//
//  KZHistorySendRecordVC.swift
//  kangze
//  历史发货
//  Created by gouyz on 2018/9/5.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let historySendRecordCell = "historySendRecordCell"

class KZHistorySendRecordVC: GYZBaseVC {
    
    var dataList:[KZHistorySendGoodsModel] = [KZHistorySendGoodsModel]()
    var goodsId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "历史发货"
        
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
    
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        
        // 设置大概高度
        table.estimatedRowHeight = 120
        // 设置行高为自动适配
        table.rowHeight = UITableViewAutomaticDimension
        
        table.register(KZHistorySendCell.self, forCellReuseIdentifier: historySendRecordCell)
        
        
        return table
    }()
    ///获取数据
    func requestDatas(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("my_send&op=send_list",parameters: ["key": userDefaults.string(forKey: "key") ?? "","goods_id": goodsId],method : .post,  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["datas"]["send_list"].array else { return }
                
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = KZHistorySendGoodsModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.tableView.reloadData()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content: "暂无历史发货信息")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                weakSelf?.requestDatas()
                weakSelf?.hiddenEmptyView()
            })
        })
    }
    /// 确认收货
    @objc func onClickedReceive(sender: UIButton){
        requestReceiveGoods(index: sender.tag)
    }
    
    ///确认收货
    func requestReceiveGoods(index: Int){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("my_send&op=sure_get",parameters: ["key": userDefaults.string(forKey: "key") ?? "","id": dataList[index].id!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                MBProgressHUD.showAutoDismissHUD(message: "确认收货成功")
                weakSelf?.dataList[index].status = "3"
                weakSelf?.tableView.reloadData()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
extension KZHistorySendRecordVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: historySendRecordCell) as! KZHistorySendCell
        
        cell.dataModel = dataList[indexPath.row]
        
        cell.receivedBtn.tag = indexPath.row
        cell.receivedBtn.addTarget(self, action: #selector(onClickedReceive(sender:)), for: .touchUpInside)
        
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
        
        //        goGoodsDetail()
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
