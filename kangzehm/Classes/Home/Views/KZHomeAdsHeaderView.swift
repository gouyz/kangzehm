//
//  KZHomeAdsHeaderView.swift
//  kangze
//  首页 header
//  Created by gouyz on 2018/8/28.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class KZHomeAdsHeaderView: UIView {

    /// 闭包回调
    public var operatorBlock: ((_ tag: Int) ->())?
    
    // MARK: 生命周期方法
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        self.addSubview(adsImgView)
        self.addSubview(dynamicBtn)
        self.addSubview(orderBtn)
        self.addSubview(friendCircleBtn)
        self.addSubview(msgBgView)
        msgBgView.addSubview(messageBtn)
        
        adsImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(self)
            make.height.equalTo((kScreenWidth - kMargin * 2) * 0.4)
        }
        dynamicBtn.snp.makeConstraints { (make) in
            make.left.equalTo(adsImgView)
            make.top.equalTo(adsImgView.snp.bottom).offset(20)
            make.bottom.equalTo(-kMargin)
            make.width.equalTo(orderBtn)
        }
        orderBtn.snp.makeConstraints { (make) in
            make.left.equalTo(dynamicBtn.snp.right)
            make.top.bottom.equalTo(dynamicBtn)
            make.width.equalTo(friendCircleBtn)
        }
        friendCircleBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(dynamicBtn)
            make.left.equalTo(orderBtn.snp.right)
            make.width.equalTo(msgBgView)
        }
        msgBgView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(dynamicBtn)
            make.left.equalTo(friendCircleBtn.snp.right)
            make.right.equalTo(adsImgView)
            make.width.equalTo(dynamicBtn)
        }
        messageBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 50, height: 50))
            make.center.equalTo(msgBgView)
        }
        
        dynamicBtn.set(image: UIImage.init(named: "icon_home_dynamic"), title: "公司动态", titlePosition: .bottom, additionalSpacing: 5, state: .normal)
        orderBtn.set(image: UIImage.init(named: "icon_home_order"), title: "订单", titlePosition: .bottom, additionalSpacing: 5, state: .normal)
        friendCircleBtn.set(image: UIImage.init(named: "icon_home_friend_circle"), title: "朋友圈", titlePosition: .bottom, additionalSpacing: 5, state: .normal)
        messageBtn.set(image: UIImage.init(named: "icon_home_msg"), title: "消息", titlePosition: .bottom, additionalSpacing: 5, state: .normal)
    }
    
    /// 广告轮播图
    lazy var adsImgView: ZCycleView = {
        let adsView = ZCycleView()
        adsView.placeholderImage = UIImage.init(named: "icon_home_banner")
//        adsView.setImagesGroup([#imageLiteral(resourceName: "icon_home_banner"),#imageLiteral(resourceName: "icon_home_banner"),#imageLiteral(resourceName: "icon_home_banner")])
        adsView.pageControlAlignment = .center
        adsView.pageControlIndictirColor = kWhiteColor
        adsView.pageControlCurrentIndictirColor = kBlueFontColor
        adsView.scrollDirection = .horizontal
        
        return adsView
    }()
    /// 公司动态
    lazy var dynamicBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k13Font
        btn.setTitleColor(kBlackFontColor, for: .normal)
        btn.tag = 101
        btn.addTarget(self, action: #selector(clickedOperateBtn(btn:)), for: .touchUpInside)
        return btn
    }()
    /// 订单
    lazy var orderBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k13Font
        btn.setTitleColor(kBlackFontColor, for: .normal)
        btn.tag = 102
        btn.addTarget(self, action: #selector(clickedOperateBtn(btn:)), for: .touchUpInside)
        return btn
    }()
    /// 朋友圈素材
    lazy var friendCircleBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k13Font
        btn.setTitleColor(kBlackFontColor, for: .normal)
        btn.tag = 103
        btn.addTarget(self, action: #selector(clickedOperateBtn(btn:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var msgBgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        
        return view
    }()
    /// 消息
    lazy var messageBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k13Font
        btn.setTitleColor(kBlackFontColor, for: .normal)
        btn.tag = 104
        btn.addTarget(self, action: #selector(clickedOperateBtn(btn:)), for: .touchUpInside)
        return btn
    }()
    
    ///操作
    @objc func clickedOperateBtn(btn : UIButton){
        let tag = btn.tag - 100
        
        if operatorBlock != nil {
            operatorBlock!(tag)
        }
    }
}
