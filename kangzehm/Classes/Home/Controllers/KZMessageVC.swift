//
//  KZMessageVC.swift
//  kangze
//  消息
//  Created by gouyz on 2018/9/3.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD


private let messageListCell = "messageListCell"

class KZMessageVC: GYZBaseVC {
    
    var dataList: [KZMessageModel] = [KZMessageModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "消息"
        
//        let rightBtn = UIButton(type: .custom)
//        rightBtn.setTitle("全部已读", for: .normal)
//        rightBtn.titleLabel?.font = k13Font
//        rightBtn.frame = CGRect.init(x: 0, y: 0, width: 60, height: kTitleHeight)
//        rightBtn.addTarget(self, action: #selector(allReadClick), for: .touchUpInside)
//        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        requestMessageDatas()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorColor = kGrayLineColor
        
        // 设置大概高度
        table.estimatedRowHeight = 80
        // 设置行高为自动适配
        table.rowHeight = UITableViewAutomaticDimension
        
        table.register(KZMessageCell.self, forCellReuseIdentifier: messageListCell)
        
        
        return table
    }()
    
    
    ///获取数据
    func requestMessageDatas(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("message&op=get_message",parameters: ["key": userDefaults.string(forKey: "key") ?? ""],method:.get,  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["datas"]["article_list"].array else { return }
                
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = KZMessageModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.tableView.reloadData()
                }else{
                    weakSelf?.showEmptyView(content: "亲，暂时没有消息~", iconImgName: "icon_empty_msg", reload: nil)
                    weakSelf?.emptyView?.iconImgView.snp.updateConstraints({ (make) in
                        make.height.equalTo(65)
                        make.width.equalTo(136)
                    })
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                weakSelf?.requestMessageDatas()
                weakSelf?.hiddenEmptyView()
            })
        })
    }
    
    /// 全部已读
//    @objc func allReadClick(){
//        weak var weakSelf = self
//        GYZAlertViewTools.alertViewTools.showAlert(title: "提示", message: "确定要设置全部已读吗？", cancleTitle: "取消", viewController: self, buttonTitles: "确定") { (index) in
//
//            if index != cancelIndex{
//                weakSelf?.requestSetRead(msgId: "")
//            }
//        }
//    }
    
    
    /// 长按删除
    ///
    /// - Parameter sender:
//    @objc func longPressDelete(sender: UILongPressGestureRecognizer){
//        
//        let tag = sender.view?.tag
//        
//        if sender.state == .ended {
//            weak var weakSelf = self
//            GYZAlertViewTools.alertViewTools.showAlert(title: "提示", message: "确定要删除消息吗？", cancleTitle: "取消", viewController: self, buttonTitles: "确定") { (index) in
//                
//                if index != cancelIndex{
//                    let model = weakSelf?.dataList[tag!]
//                    weakSelf?.requestDeleteMsg(msgId: (model?.id)!,index: tag!)
//                }
//            }
//        }
//    }
//    
//    /// 删除单个 消息
//    func requestDeleteMsg(msgId: String,index: Int){
//        
//        weak var weakSelf = self
//        createHUD(message: "加载中...")
//        
//        GYZNetWork.requestNetwork("sms/delMsg.do", parameters: ["uId":userInfo?.id ?? "","mId":msgId],  success: { (response) in
//            
//            weakSelf?.hud?.hide(animated: true)
//            GYZLog(response)
//            if response["code"].intValue == kQuestSuccessTag{//请求成功
//                
//                weakSelf?.dataList.remove(at: index)
//                if weakSelf?.dataList.count > 0{
//                    weakSelf?.hiddenEmptyView()
//                    weakSelf?.tableView.reloadData()
//                }else{
//                    ///显示空页面
//                    weakSelf?.showEmptyView(content:"暂无消息")
//                }
//                
//            }else{
//                MBProgressHUD.showAutoDismissHUD(message: response["message"].stringValue)
//            }
//            
//        }, failture: { (error) in
//            weakSelf?.hud?.hide(animated: true)
//            GYZLog(error)
//        })
//    }
}
extension KZMessageVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: messageListCell) as! KZMessageCell
        
        cell.dataModel = dataList[indexPath.row]
        
        /// 长按删除
//        let tap: UILongPressGestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressDelete(sender:)))
//        tap.minimumPressDuration = 1.0
//        cell.tag = indexPath.row
//        cell.addGestureRecognizer(tap)
        
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
        
        let model = dataList[indexPath.row]
        
        if model.read_status == "0" {//如果是未读
            model.read_status = "1"
        }
        
        let detailVC = KZMessageDetailVC()
        detailVC.msgId = model.article_id!
        detailVC.resultBlock = {[weak self] () in
            
            self?.tableView.reloadData()
        }
        navigationController?.pushViewController(detailVC, animated: true)
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
