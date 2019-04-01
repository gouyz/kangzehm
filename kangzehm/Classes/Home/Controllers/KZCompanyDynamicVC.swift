//
//  KZCompanyDynamicVC.swift
//  kangze
//  公司动态
//  Created by gouyz on 2018/8/31.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let companyDynamicCell = "companyDynamicCell"

class KZCompanyDynamicVC: GYZBaseVC {
    
    /// 数据
    var dataList: [KZArticleModel] = [KZArticleModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(0)
        }
        
        requestDynamicDatas()
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
        
        table.register(KZCompanyDynamicCell.self, forCellReuseIdentifier: companyDynamicCell)
        
        return table
    }()
    
    /// 分享界面
    func showShareView(){
        
        let cancelBtn = [
            "title": "取消",
            "type": "danger"
        ]
        let mmShareSheet = MMShareSheet.init(title: "分享至", cards: kSharedCards, duration: nil, cancelBtn: cancelBtn)
        mmShareSheet.callBack = { [weak self](handler) ->() in
            
            if handler != "cancel" {// 取消
                
            }
        }
        mmShareSheet.present()
    }
    
    ///获取动态数据
    func requestDynamicDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("article&op=company_dt",parameters: nil,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["datas"]["article_list"].array else { return }
                
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = KZArticleModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                if weakSelf?.dataList.count > 0{
                    weakSelf?.tableView.reloadData()
                }else{
                    MBProgressHUD.showAutoDismissHUD(message: "暂无动态")
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}

extension KZCompanyDynamicVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: companyDynamicCell) as! KZCompanyDynamicCell
        
        cell.dataModel = dataList[indexPath.row]
        cell.sharedBlock = {[weak self] in
            
            self?.showShareView()
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
        let vc = KZArticleDetailVC()
        vc.articleId = dataList[indexPath.row].article_id!
        vc.articleTitle = dataList[indexPath.row].article_title!
        navigationController?.pushViewController(vc, animated: true)
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kMargin
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
