//
//  KZCommonNavBarVC.swift
//  kangze
//  首页和商城 NavBar View
//  Created by gouyz on 2018/8/28.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import PYSearch

class KZCommonNavBarVC: GYZBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.titleView = navBarView
        
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = k10Font
        btn.setTitleColor(kBlackFontColor, for: .normal)
        btn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        btn.addTarget(self, action: #selector(onClickedQrcode), for: .touchUpInside)
        btn.set(image: UIImage.init(named: "icon_qrcode"), title: "邀请码", titlePosition: .bottom, additionalSpacing: 1, state: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btn)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /// 邀请码
    @objc func onClickedQrcode(){
        
        let vc = KZApplyFriendsVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    lazy var navBarView: GYZSearchNavBarView = GYZSearchNavBarView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kTitleHeight))
    
    ///搜索
    @objc func clickedSearchBtn(){
        let searchVC: PYSearchViewController = PYSearchViewController.init(hotSearches: [], searchBarPlaceholder: "输入您要搜索的内容") { (searchViewController, searchBar, searchText) in
            
            let searchVC = KZSearchShopVC()
            searchVC.searchContent = searchText!
            searchViewController?.navigationController?.pushViewController(searchVC, animated: true)
        }
        searchVC.hotSearchStyle = .borderTag
        searchVC.searchHistoryStyle = .borderTag
//        searchVC.searchSuggestionHidden = true
        
        let searchNav = GYZBaseNavigationVC(rootViewController:searchVC)
        //        searchNav.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: kBlackColor, NSAttributedStringKey.font: k18Font]
        //
        searchVC.cancelButton.setTitleColor(kBlackFontColor, for: .normal)
        self.present(searchNav, animated: true, completion: nil)
        
    }
}
