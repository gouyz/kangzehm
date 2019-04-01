//
//  KZSettingVC.swift
//  kangze
//  我的设置
//  Created by gouyz on 2018/9/5.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

private let settingCell = "settingCell"

class KZSettingVC: GYZBaseVC {

    var titles: [String] = ["修改密码","关于我们","退出登录"]
    var tagImgs: [String] = ["icon_setting_pwd","icon_setting_about","icon_setting_loginout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "我的设置"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(0)
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
        
        table.register(GYZCommonIconArrowCell.self, forCellReuseIdentifier: settingCell)
        
        return table
    }()
    
    /// 修改密码
    func goModifyPwd() {
        let forgetPwdVC = KZForgetPwdVC()
        forgetPwdVC.registerType = .modifypwd
        navigationController?.pushViewController(forgetPwdVC, animated: true)
    }
    /// 关于
    func goAboutVC(){
        let vc = KZAboutVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    ///退出当前账号
    func loginOut(){
        weak var weakSelf = self
        GYZAlertViewTools.alertViewTools.showAlert(title: "提示", message: "确定要退出登录？", cancleTitle: "取消", viewController: self, buttonTitles: "退出") { (index) in
            
            if index != cancelIndex{
                weakSelf?.dealLoginOut()
            }
        }
    }
    
    func dealLoginOut(){
        GYZTool.removeUserInfo()
        
        let vc = BPLoginVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension KZSettingVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: settingCell) as! GYZCommonIconArrowCell
        cell.iconView.image = UIImage.init(named: tagImgs[indexPath.row])
        cell.nameLab.text = titles[indexPath.row]
        
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
        
        switch indexPath.row {
        case 0:// 修改密码
            goModifyPwd()
        case 1:// 关于我们
            goAboutVC()
        case 2:// 退出登录
            loginOut()
        default:
            break
        }
        
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kMargin
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
