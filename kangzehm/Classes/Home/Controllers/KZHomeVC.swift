//
//  KZHomeVC.swift
//  kangze
//  首页
//  Created by gouyz on 2018/8/28.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let homeCell = "homeCell"

class KZHomeVC: KZCommonNavBarVC {
    
    var dataModel: KZHomeModel?
    var titleArr: [String] = [String]()
    var iconArr: [String] = [String]()
    /// 未读消息数量
    var msgNumber: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        tableView.tableHeaderView = headerView
        
        headerView.operatorBlock = {[weak self] (tag) in
            self?.dealOperator(index: tag)
        }
        navBarView.searchBtn.addTarget(self, action: #selector(clickedSearchBtn), for: .touchUpInside)
        
        requestHomeDatas()
        requestVersion()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !userDefaults.bool(forKey: kIsLoginTagKey) {
            msgNumber = "0"
            setMsgBadage()
        }else{
            requestMessageNumber()
        }
        
    }
    
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        
        table.register(KZHomeCell.self, forCellReuseIdentifier: homeCell)
        
        weak var weakSelf = self
        ///添加下拉刷新
        GYZTool.addPullRefresh(scorllView: table, pullRefreshCallBack: {
            weakSelf?.requestHomeDatas()
            weakSelf?.requestMessageNumber()
        })
        //        ///添加上拉加载更多
        //        GYZTool.addLoadMore(scorllView: table, loadMoreCallBack: {
        //            weakSelf?.loadMore()
        //        })
        
        return table
    }()
    
    lazy var headerView: KZHomeAdsHeaderView = KZHomeAdsHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: (kScreenWidth - kMargin * 2) * 0.4 + 80))
    
    /// 关闭上拉/下拉刷新
    func closeRefresh(){
        if tableView.mj_header.isRefreshing{//下拉刷新
            GYZTool.endRefresh(scorllView: tableView)
        }
        //        else if tableView.mj_footer.isRefreshing{//上拉加载更多
        //            GYZTool.endLoadMore(scorllView: tableView)
        //        }
    }
    ///获取首页数据
    func requestHomeDatas(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("goods&op=shop_index",parameters: ["key": userDefaults.string(forKey: "key") ?? ""],method : .get,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            weakSelf?.closeRefresh()
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["datas"].dictionaryObject else { return }
                weakSelf?.dataModel = KZHomeModel.init(dict: data)
                weakSelf?.setData()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hud?.hide(animated: true)
            weakSelf?.closeRefresh()
            GYZLog(error)
        })
    }
    
    func setData(){
        headerView.adsImgView.setUrlsGroup([(dataModel?.header_pic)!])
        if dataModel?.goodList != nil {
            for item in (dataModel?.goodList)! {
                if item.goods_type == "1"{
                    titleArr.append("热销商品")
                    iconArr.append("icon_home_hot_sale")
                }else if item.goods_type == "2"{
                    titleArr.append("推荐商品")
                    iconArr.append("icon_home_hehuo")
                }else if item.goods_type == "3"{
                    titleArr.append("续货套餐")
                    iconArr.append("icon_home_xuhuo")
                }
            }
        }
        tableView.reloadData()
    }
    
    ///获取未读消息数量数据
    func requestMessageNumber(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        
        GYZNetWork.requestNetwork("message&op=get_unread_count",parameters: ["key": userDefaults.string(forKey: "key") ?? ""],method : .get,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            weakSelf?.closeRefresh()
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.msgNumber = response["datas"]["unread_count"].stringValue
                weakSelf?.setMsgBadage()
            }
            
        }, failture: { (error) in
            
            weakSelf?.hud?.hide(animated: true)
            weakSelf?.closeRefresh()
            GYZLog(error)
        })
    }
    /// 设置消息角标
    func setMsgBadage(){
        if Int.init(msgNumber) > 0 {
            headerView.messageBtn.badgeView.text = msgNumber
            headerView.messageBtn.showBadge(animated: false)
        }else{
            headerView.messageBtn.clearBadge(animated: false)
        }
        
    }
    
    /// 公司动态、订单、朋友圈素材、消息
    func dealOperator(index : Int){
        switch index {
        case 1://公司动态
            goDynamic()
        case 2://订单
            goOrder()
        case 3://朋友圈素材
            goFriendCircle()
        case 4://消息
            goMsg()
        default:
            break
        }
    }
    ///公司动态
    func goDynamic(){
        let vc = KZCompanyDynamicManagerVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    ///订单
    func goOrder(){
        let vc = KZOrderManagerVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    ///朋友圈
    func goFriendCircle(){
        let vc = KZFriendCircleVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    ///消息
    func goMsg(){
        let vc = KZMessageVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 商品详情
    func goGoodsDetail(index: Int){
        let vc = KZGoodsDetailVC()
        vc.goodsId = (dataModel?.goodList![index].goods_id)!
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension KZHomeVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataModel != nil {
            return (dataModel?.goodList!.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: homeCell) as! KZHomeCell
        
        let model = dataModel?.goodList![indexPath.row]
        
        cell.iconView.image = UIImage.init(named: iconArr[indexPath.row])
        cell.nameLab.text = titleArr[indexPath.row]
        cell.adsImgView.kf.setImage(with: URL.init(string: (model?.goods_image)!), placeholder: UIImage.init(named: "icon_home_goods"), options: nil, progressBlock: nil, completionHandler: nil)
        
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
        return (kScreenWidth - kMargin * 2) * 0.49 + 70
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
extension KZHomeVC{
    /// 获取App Store版本信息
    func requestVersion(){
        
        weak var weakSelf = self
        
        GYZNetWork.requestVersionNetwork("http://itunes.apple.com/cn/lookup?id=\(APPID)", success: { (response) in
            
            //            GYZLog(response)
            if response["resultCount"].intValue == 1{//请求成功
                let data = response["results"].arrayValue
                
                var version: String = GYZUpdateVersionTool.getCurrVersion()
                var content: String = ""
                if data.count > 0{
                    version = data[0]["version"].stringValue//版本号
                    content = data[0]["releaseNotes"].stringValue//更新内容
                }
                
                weakSelf?.checkVersion(newVersion: version, content: content)
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["result"]["msg"].stringValue)
            }
            
        }, failture: { (error) in
            GYZLog(error)
        })
    }
    
    /// 检测APP更新
    func checkVersion(newVersion: String,content: String){
        
        let type: UpdateVersionType = GYZUpdateVersionTool.compareVersion(newVersion: newVersion)
        switch type {
        case .noUpdate:
            break
        default:
            updateVersion(version: newVersion, content: content)
            break
        }
    }
    /**
     * //不强制更新
     * @param version 版本名称
     * @param content 更新内容
     */
    func updateVersion(version: String,content: String){
        
        GYZAlertViewTools.alertViewTools.showAlert(title:"发现新版本\(version)", message: content, cancleTitle: "残忍拒绝", viewController: self, buttonTitles: "立即更新", alertActionBlock: { (index) in
            
            if index == 0{//立即更新
                GYZUpdateVersionTool.goAppStore()
            }
        })
    }
}
