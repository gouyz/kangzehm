//
//  KZFriendCircleVC.swift
//  kangze
//  朋友圈
//  Created by gouyz on 2018/9/3.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let friendCircleCell = "friendCircleCell"

class KZFriendCircleVC: GYZBaseVC {
    
    var currPage : Int = 1
    var dataList: [KZFriendCircleModel] = [KZFriendCircleModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "朋友圈"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named:"icon_add_black")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(onClickedAdd))
        
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
        
        // 设置大概高度
        table.estimatedRowHeight = 100
        // 设置行高为自动适配
        table.rowHeight = UITableViewAutomaticDimension
        
        table.register(KZFriendCircleCell.self, forCellReuseIdentifier: friendCircleCell)
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
    func requestDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("friend_message&op=message_list",parameters: [/*"curpage":currPage,"page":kPageSize,*/"key": userDefaults.string(forKey: "key") ?? ""],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            weakSelf?.closeRefresh()
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["datas"]["list"].array else { return }
                
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = KZFriendCircleModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.tableView.reloadData()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content: "暂无信息")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            weakSelf?.closeRefresh()
            GYZLog(error)
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                weakSelf?.requestDatas()
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
        requestDatas()
    }
    
    //    /// 上拉加载更多
    //    func loadMore(){
    //        currPage += 1
    //        requestDatas()
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
    /// add
    @objc func onClickedAdd(){
        let vc = KZPublicFriendCircleVC()
        vc.resultBlock = {[weak self] () in
            self?.dataList.removeAll()
            self?.tableView.reloadData()
            self?.refresh()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 一键转发
    @objc func onClickedShared(sender:UITapGestureRecognizer){
        
        let tag = sender.view?.tag
        let model = dataList[tag!]
        /// 复制内容到剪贴板
        UIPasteboard.general.string = model.content
        MBProgressHUD.showAutoDismissHUD(message: "朋友圈内容已复制")
        
        var shareItems: [GYZSharedItem] = [GYZSharedItem]()
        let docPath: String = NSHomeDirectory()
        
        var sharedUrls: [URL] = [URL]()
        for (index,item) in model.imageList!.enumerated() {
            
            //把图片转成NSData类型
            if let data: NSData = try? NSData.init(contentsOf: URL.init(string: item)!){
                
                //写入图片中
                if let img: UIImage = UIImage.init(data: data as Data){
                    //图片缓存的地址，自己进行替换
                    let imgPath: String = docPath.appending(String.init(format: "/Documents/ShareWX%d.jpg", index))
                    
                    //把图片写进缓存，一定要先写入本地，不然会分享出错
                    let imgData: NSData = UIImageJPEGRepresentation(img, 0.5)! as NSData
                    imgData.write(toFile: imgPath, atomically: true)
                    
                    //把缓存图片的地址转成NSUrl格式
                    let pathUrl = URL.init(fileURLWithPath: imgPath)
                    //这个部分是自定义ActivitySource
                    let itemSource: GYZSharedItem = GYZSharedItem.init(data: img, andFile: pathUrl)
                    shareItems.append(itemSource)
                    sharedUrls.append(pathUrl)
                }
                
            }
            
        }
        
        TSShareHelper.share(with: .others, andController: self, andItems: shareItems) { (sharedHelp, isSuccess) in

            var desStr: String = "分享失败"
            if isSuccess{
                desStr = "分享成功"
            }
            
            MBProgressHUD.showAutoDismissHUD(message: desStr)
        }
        
    }
}

extension KZFriendCircleVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: friendCircleCell) as! KZFriendCircleCell
        
        cell.dataModel = dataList[indexPath.row]
        
        cell.sharedLab.tag = indexPath.row
        cell.sharedLab.addOnClickListener(target: self, action: #selector(onClickedShared(sender:)))
        
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.000001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.000001
    }
}
