//
//  KZMyKuCunVC.swift
//  kangze
//  我的库存
//  Created by gouyz on 2018/9/5.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let myKuCunCell = "myKuCunCell"

class KZMyKuCunVC: GYZBaseVC {
    
    var dataList: [KZMyKuCunModel] = [KZMyKuCunModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "我的库存"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        requestKuCunDatas()
    }
    
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorColor = kGrayLineColor
        
        table.register(KZMyKuCunCell.self, forCellReuseIdentifier: myKuCunCell)
        
        
        return table
    }()
    ///获取库存数据
    func requestKuCunDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("my_stock&op=stock_list",parameters: ["key": userDefaults.string(forKey: "key") ?? ""],method : .post,  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["datas"]["stock_list"].array else { return }
                weakSelf?.dataList.removeAll()
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = KZMyKuCunModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.tableView.reloadData()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content: "暂无库存信息")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                weakSelf?.requestKuCunDatas()
                weakSelf?.hiddenEmptyView()
            })
        })
    }
    /// 申请发货
    @objc func clickedSendBtn(sender: UIButton){
        let tag = sender.tag
        let vc = KZApplySendVC()
        vc.goodsId = dataList[tag].goods_id!
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 历史发货
    @objc func clickedHistoryBtn(sender: UIButton){
        let tag = sender.tag
        
        let vc = KZHistorySendRecordVC()
        vc.goodsId = dataList[tag].goods_id!
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 商品详情
    func goGoodsDetail(index: Int){
        let vc = KZGoodsDetailVC()
        vc.goodsId = dataList[index].goods_id!
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension KZMyKuCunVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: myKuCunCell) as! KZMyKuCunCell
        
        cell.dataModel = dataList[indexPath.row]
        
        cell.sendBtn.tag = indexPath.row
        cell.sendBtn.addTarget(self, action: #selector(clickedSendBtn(sender:)), for: .touchUpInside)
        cell.historySendBtn.tag = indexPath.row
        cell.historySendBtn.addTarget(self, action: #selector(clickedHistoryBtn(sender:)), for: .touchUpInside)
        
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
        
        goGoodsDetail(index: indexPath.row)
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
