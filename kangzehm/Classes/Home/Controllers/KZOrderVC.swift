//
//  KZOrderVC.swift
//  kangze
//  我的订单
//  Created by gouyz on 2018/9/3.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON

private let orderCell = "orderCell"
private let orderHeader = "orderHeader"
private let orderFooter = "orderFooter"

class KZOrderVC: GYZBaseVC {
    
    var orderStatus: String = ""
    var currPage : Int = 1
    var dataList: [KZOrderModel] = [KZOrderModel]()
    /// 余额
    var yuEMoney: String = "0"

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(0)
        }
        requestOrderDatas()
        
        if orderStatus != "state_pay" {
            requestYuEInfo()
        }
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
        
        table.register(KZOrderCell.self, forCellReuseIdentifier: orderCell)
        table.register(KZOrderHeaderView.self, forHeaderFooterViewReuseIdentifier: orderHeader)
        table.register(KZOrderFooterView.self, forHeaderFooterViewReuseIdentifier: orderFooter)

        weak var weakSelf = self
        ///添加下拉刷新
        GYZTool.addPullRefresh(scorllView: table, pullRefreshCallBack: {
            weakSelf?.refresh()
        })
//        ///添加上拉加载更多
//        GYZTool.addLoadMore(scorllView: table, loadMoreCallBack: {
//            weakSelf?.loadMore()
//        })
        return table
    }()
    
    ///获取数据
    func requestOrderDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("member_order&op=order_list",parameters: [/*"curpage":currPage,"page":kPageSize,*/"key": userDefaults.string(forKey: "key") ?? "","state_type": orderStatus],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            weakSelf?.closeRefresh()
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["datas"]["order_group_list"].array else { return }
                
                for item in data{
                    guard let dataInfo = item["order_list"].array else { return }
                    guard let itemInfo = dataInfo[0].dictionaryObject else { return }
                    let model = KZOrderModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.tableView.reloadData()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content: "暂无订单信息")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            weakSelf?.closeRefresh()
            GYZLog(error)
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                weakSelf?.requestOrderDatas()
                weakSelf?.hiddenEmptyView()
            })
//            if weakSelf?.currPage == 1{//第一次加载失败，显示加载错误页面
//                weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
//                    weakSelf?.refresh()
//                    weakSelf?.hiddenEmptyView()
//                })
//            }
        })
    }
    
    
    // MARK: - 上拉加载更多/下拉刷新
    /// 下拉刷新
    func refresh(){
        currPage = 1
        requestOrderDatas()
    }

//    /// 上拉加载更多
//    func loadMore(){
//        currPage += 1
//        requestOrderDatas()
//    }

    /// 关闭上拉/下拉刷新
    func closeRefresh(){
        if tableView.mj_header.isRefreshing{//下拉刷新
            dataList.removeAll()
            GYZTool.endRefresh(scorllView: tableView)
        }
//        else if tableView.mj_footer.isRefreshing{//上拉加载更多
//            GYZTool.endLoadMore(scorllView: tableView)
//        }
    }
    
    /// 获取余额数据
    func requestYuEInfo(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        
        GYZNetWork.requestNetwork("member_index&op=my_asset&fields=predepoit", parameters: ["key": userDefaults.string(forKey: "key") ?? ""],  success: { (response) in
            
            GYZLog(response)
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.yuEMoney = response["datas"]["predepoit"].stringValue
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            GYZLog(error)
        })
    }
    
    /// 去结算
    @objc func clickedOperateBtn(btn: UIButton){
        let tag = btn.tag
        showPayView(tag: tag)
    }
    /// 删除订单
    @objc func clickedDeleteBtn(btn: UIButton){
        let tag = btn.tag
        showDeleteOrder(tag: tag)
    }
    func showDeleteOrder(tag: Int){
        weak var weakSelf = self
        GYZAlertViewTools.alertViewTools.showAlert(title: "删除订单", message: "确定要删除该订单吗?", cancleTitle: "取消", viewController: self, buttonTitles: "确定") { (index) in
            
            if index != cancelIndex{
                weakSelf?.requestDeleteOrder(index: tag)
            }
        }
    }
    /// 删除订单
    func requestDeleteOrder(index : Int){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("member_order&op=order_delete", parameters: ["key": userDefaults.string(forKey: "key") ?? "","order_id":dataList[index].order_id!],   success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.dataList.remove(at: index)
                weakSelf?.tableView.reloadData()
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content: "暂无订单信息")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    func showPayView(tag: Int){
        let payView = KZSelectPayMethodView()
        payView.yuEMoneyLab.text = "可用余额：￥\(yuEMoney)"
        payView.selectPayTypeBlock = { [weak self](index) in
            
            payView.hide()
            self?.dealPay(index: index,tag: tag)
        }
        payView.show()
    }
    /// 支付
    func dealPay(index: Int,tag: Int){
        
        switch index {
        case 1://余额支付
            requestPayData(type: "yck",index: tag)
        case 2:// 支付宝支付
            requestPayData(type: "alipay_native",index: tag)
        case 3://微信支付
            requestPayData(type: "wxpay",index: tag)
        case 4://pos支付
            let vc = KZPosPayVC()
            vc.paySN = dataList[tag].pay_sn!
            vc.resultBlock = {[weak self] () in
                
                self?.dataList.removeAll()
                self?.tableView.reloadData()
                self?.requestOrderDatas()
            }
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    /// 获取支付参数
    func requestPayData(type: String,index:Int){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("member_payment&op=pay_new", parameters: ["key": userDefaults.string(forKey: "key") ?? "","payment_code":type,"pay_sn":dataList[index].pay_sn!],method : .get,   success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                if type == "alipay_native"{// 支付宝
                    let payInfo: String = response["datas"]["signStr"].stringValue
                    weakSelf?.goAliPay(orderInfo: payInfo,index:index)
                }else if type == "yck"{// 余额支付
                    weakSelf?.requestYuEInfo()
                    MBProgressHUD.showAutoDismissHUD(message: "支付成功")
                    weakSelf?.dealPayBack(index: index,status: "20")
                }else if type == "wxpay"{// 微信支付
                    weakSelf?.goWeChatPay(data: response["datas"]["prepay_order"],index: index)
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /// 微信支付
    func goWeChatPay(data: JSON,index:Int){
        let req = PayReq()
        req.timeStamp = data["timestamp"].uInt32Value
        req.partnerId = data["partnerid"].stringValue
        req.package = data["package"].stringValue
        req.nonceStr = data["noncestr"].stringValue
        req.sign = data["sign"].stringValue
        req.prepayId = data["prepayid"].stringValue
        
        WXApiManager.shared.payAlertController(self, request: req, paySuccess: { [weak self]  in
            
            self?.dealPayBack(index: index,status: "20")
        }) {
            
        }
    }
    /// 支付宝支付
    func goAliPay(orderInfo: String,index:Int){
        
        AliPayManager.shared.requestAliPay(orderInfo, paySuccess: { [weak self]  in
            
            self?.dealPayBack(index: index,status: "20")
            }, payFail: {
        })
    }
    /// 处理结果
    func dealPayBack(index:Int,status: String){
        
        if orderStatus == "" {// 全部
            dataList[index].order_state = status
        }else{
            dataList.remove(at: index)
        }
        
        tableView.reloadData()
        if dataList.count > 0{
            hiddenEmptyView()
        }else{
            ///显示空页面
            showEmptyView(content: "暂无订单信息")
        }
    }
}

extension KZOrderVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataList.count > 0 {
            return (dataList[section].goodList?.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: orderCell) as! KZOrderCell
        cell.dataModel = dataList[indexPath.section].goodList?[indexPath.row]
        
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: orderHeader) as! KZOrderHeaderView
        
        headerView.dataModel = dataList[section]
        
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: orderFooter) as! KZOrderFooterView
        footerView.dataModel = dataList[section]
        
        footerView.operatorBtn.tag = section
        footerView.operatorBtn.addTarget(self, action: #selector(clickedOperateBtn(btn:)), for: .touchUpInside)
        
        footerView.deleteBtn.tag = section
        footerView.deleteBtn.addTarget(self, action: #selector(clickedDeleteBtn(btn:)), for: .touchUpInside)
        
        return footerView
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kTitleHeight
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 70
    }
}
