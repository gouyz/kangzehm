//
//  KZMyVIPManagerVC.swift
//  kangze
//  代理商明细
//  Created by gouyz on 2018/9/6.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class KZMyVIPManagerVC: GYZBaseVC {

    let titleArr : [String] = ["客户管理","库存明细","销售数据"]
    var scrollPageView: ScrollPageView?
    /// 用户信息
    var dataModel: KZShouRuChildModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_back_white_arrow")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(clickedBackBtn))
        
        navBarBgAlpha = 0
        automaticallyAdjustsScrollViewInsets = false
        
        view.addSubview(headerView)
        setupUI()
        
        setScrollView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    ///设置控制器
    func setChildVcs() -> [GYZBaseVC] {
        
        let customerVC = KZCustomerInfoVC()
        customerVC.memberId = (dataModel?.member_id)!
        
        let kuCunVC = KZKuCunInfoVC()
        kuCunVC.memberId = (dataModel?.member_id)!
        
        let dataVC = KZShengYiDataVC()
        dataVC.memberId = (dataModel?.member_id)!
        
        return [customerVC,kuCunVC,dataVC]
    }
    
    /// 设置scrollView
    func setScrollView(){
        // 这个是必要的设置
        automaticallyAdjustsScrollViewInsets = false
        
        var style = SegmentStyle()
        // 滚动条
        style.showLine = true
        style.scrollTitle = false
        // 颜色渐变
        style.gradualChangeTitleColor = true
        // 滚动条颜色
        style.scrollLineColor = kBlueFontColor
        style.normalTitleColor = kBlackFontColor
        style.selectedTitleColor = kBlueFontColor
        /// 显示角标
        style.showBadge = false
        
        scrollPageView = ScrollPageView.init(frame: CGRect.init(x: 0, y: headerView.bottomY, width: kScreenWidth, height: self.view.frame.height - headerView.bottomY), segmentStyle: style, titles: titleArr, childVcs: setChildVcs(), parentViewController: self)
        view.addSubview(scrollPageView!)
    }
    /// header
    lazy var headerView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 180 + kStateHeight))
        view.backgroundColor = kWhiteColor
        
        return view
    }()
    
    func setupUI(){
        headerView.addSubview(bgView)
        bgView.addSubview(userHeaderView)
        bgView.addSubview(nameLab)
        bgView.addSubview(typeLab)
        bgView.addSubview(phoneLab)
        
        
        bgView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(headerView)
            make.top.equalTo(kStateHeight)
        }
        userHeaderView.snp.makeConstraints { (make) in
            make.centerX.equalTo(bgView)
            make.top.equalTo(20)
            make.size.equalTo(CGSize.init(width: 60, height: 60))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(userHeaderView.snp.bottom)
            make.height.equalTo(30)
        }
        
        typeLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
            make.height.equalTo(20)
        }
        phoneLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(typeLab)
            make.top.equalTo(typeLab.snp.bottom)
        }
    }
    
    /// 背景
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kBlueFontColor
        
        return view
    }()
    
    /// 用户头像 图片
    lazy var userHeaderView: UIImageView = {
        let imgView = UIImageView()
        imgView.cornerRadius = 30
        imgView.kf.setImage(with: URL.init(string: (dataModel?.member_avatar)!), placeholder: UIImage.init(named: "icon_header_default"), options: nil, progressBlock: nil, completionHandler: nil)
        
        return imgView
    }()
    lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kWhiteColor
        lab.textAlignment = .center
        lab.text = dataModel?.buyer_name
        
        return lab
    }()
    /// 会员类型
    lazy var typeLab: UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kWhiteColor
        lab.textAlignment = .center
        lab.text = dataModel?.type_name
        
        return lab
    }()
    /// 手机号
    lazy var phoneLab: UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kWhiteColor
        lab.textAlignment = .center
        lab.text = dataModel?.member_mobile
        
        return lab
    }()
}
