//
//  KZMyAddressVC.swift
//  kangze
//  我的地址
//  Created by gouyz on 2018/9/5.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

private let myAddressCell = "myAddressCell"

class KZMyAddressVC: GYZBaseVC {
    
    /// 选择结果回调
    var resultBlock:((_ model: KZMyAddressModel) -> Void)?
    var dataList: [KZMyAddressModel] = [KZMyAddressModel]()
    /// 是否是选择地址
    var isSelected: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "我的地址"
        view.addSubview(submitBtn)
        view.addSubview(tableView)
        
        submitBtn.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(kBottomTabbarHeight)
        }
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(submitBtn.snp.top)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view)
            }else{
                make.top.equalTo(kTitleAndStateHeight)
            }
        }
        requestAddressDatas()
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
        table.estimatedRowHeight = 100
        // 设置行高为自动适配
        table.rowHeight = UITableViewAutomaticDimension
        
        table.register(KZMyAddressCell.self, forCellReuseIdentifier: myAddressCell)
        
        return table
    }()
    
    /// 添加新地址
    lazy var submitBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("添加新地址", for: .normal)
        btn.addTarget(self, action: #selector(clickedSubmitBtn), for: .touchUpInside)
        
        return btn
    }()
    /// 添加新地址
    @objc func clickedSubmitBtn(){
        goEditVC(isAdd: true,index: 0)
    }
    
    /// 删除地址
    @objc func onClickedDelBtn(sender: UIButton){
        let tag = sender.tag
        requestDeleteAddress(index: tag)
    }
    /// 编辑地址
    @objc func onClickedEditBtn(sender: UIButton){
        
        let tag = sender.tag
        goEditVC(isAdd: false,index: tag)
    }
    
    /// 编辑/新增地址
    ///
    /// - Parameter isEdit: 是增加还是编辑
    func goEditVC(isAdd: Bool,index: Int){
        let editVC = KZEditAddressVC()
        editVC.isAdd = isAdd
        if !isAdd {
            let model = dataList[index]
            editVC.addressId = model.address_id!
            editVC.addressModel = model
        }
        /// 回调刷新数据
        editVC.resultBlock = {[weak self] in
            self?.requestAddressDatas()
        }
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    ///获取我的地址数据
    func requestAddressDatas(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        showLoadingView()
        
        GYZNetWork.requestNetwork("member_address&op=address_list",parameters: ["key": userDefaults.string(forKey: "key") ?? ""],  success: { (response) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["datas"]["address_list"].array else { return }
                
                weakSelf?.dataList.removeAll()
                for item in data{
                    guard let itemInfo = item.dictionaryObject else { return }
                    let model = KZMyAddressModel.init(dict: itemInfo)
                    
                    weakSelf?.dataList.append(model)
                }
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.tableView.reloadData()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content:"暂无地址")
                    weakSelf?.view.bringSubview(toFront: (weakSelf?.submitBtn)!)
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hiddenLoadingView()
            GYZLog(error)
            
            //第一次加载失败，显示加载错误页面
            weakSelf?.showEmptyView(content: "加载失败，请点击重新加载", reload: {
                weakSelf?.requestAddressDatas()
            })
            weakSelf?.view.bringSubview(toFront: (weakSelf?.submitBtn)!)
        })
    }
    
    ///删除地址
    func requestDeleteAddress(index: Int){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        GYZNetWork.requestNetwork("member_address&op=address_del",parameters: ["address_id":dataList[index].address_id!,"key": userDefaults.string(forKey: "key") ?? ""],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.dataList.remove(at: index)
                if weakSelf?.dataList.count > 0{
                    weakSelf?.hiddenEmptyView()
                    weakSelf?.tableView.reloadData()
                }else{
                    ///显示空页面
                    weakSelf?.showEmptyView(content:"暂无地址")
                    weakSelf?.view.bringSubview(toFront: (weakSelf?.submitBtn)!)
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
extension KZMyAddressVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: myAddressCell) as! KZMyAddressCell
        
        cell.dataModel = dataList[indexPath.row]
        
        cell.delBtn.tag = indexPath.row
        cell.delBtn.addTarget(self, action: #selector(onClickedDelBtn(sender:)), for: .touchUpInside)
        cell.editBtn.tag = indexPath.row
        cell.editBtn.addTarget(self, action: #selector(onClickedEditBtn(sender:)), for: .touchUpInside)
        
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
        if isSelected {
            if resultBlock != nil{
                resultBlock!(dataList[indexPath.row])
            }
            clickedBackBtn()
        }
    }
    
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.00001
    }
}
