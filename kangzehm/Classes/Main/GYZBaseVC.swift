//
//  GYZBaseVC.swift
//  flowers
//  基控制器
//  Created by gouyz on 2016/11/7.
//  Copyright © 2016年 gouyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class GYZBaseVC: UIViewController {
    
    var hud : MBProgressHUD?
//    var statusBarShouldLight = true
    /// 用户信息
    var userInfo: LHSUserInfoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = kBackgroundColor
        
        if navigationController?.childViewControllers.count > 1 {
            // 添加返回按钮,不被系统默认渲染,显示图像原始颜色
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_back")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(clickedBackBtn))
        }
        
        getUserInfo()
    }
    
    /// 重载设置状态栏样式
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        if statusBarShouldLight {
//
//            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: kWhiteColor, NSAttributedStringKey.font: k18Font]
//
//            navigationController?.navigationBar.barTintColor = kNavBarColor
//            navigationController?.navigationBar.tintColor = kWhiteColor
//
//            return .lightContent
//        } else {
//
//            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: kBlackColor, NSAttributedStringKey.font: k18Font]
//
//            navigationController?.navigationBar.barTintColor = kWhiteColor
//            navigationController?.navigationBar.tintColor = kBlackColor
//
//            return .default
//        }
//    }
//
//    /// 设置状态栏样式为default,设置导航栏透明
//    func setStatusBarStyle(){
//
//        navBarBgAlpha = 0
//        navBarTintColor = kBlackColor
//        statusBarShouldLight = false
//        setNeedsStatusBarAppearanceUpdate()
//    }
    /// 返回
    @objc func clickedBackBtn() {
        _ = navigationController?.popViewController(animated: true)
    }
    /// 创建HUD
    func createHUD(message: String){
        if hud != nil {
            hud?.hide(animated: true)
            hud = nil
        }
        
        hud = MBProgressHUD.showHUD(message: message,toView: view)
    }
    /// 获取用户信息
    func getUserInfo(){
//        let model = userDefaults.data(forKey: USERINFO)
//        if model != nil {
//            
//            userInfo = NSKeyedUnarchiver.unarchiveObject(with: model!) as? LHSUserInfoModel
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
