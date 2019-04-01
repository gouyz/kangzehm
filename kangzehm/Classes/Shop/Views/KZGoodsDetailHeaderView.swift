//
//  KZGoodsDetailHeaderView.swift
//  kangze
//  商品详情 headerView
//  Created by gouyz on 2018/8/29.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class KZGoodsDetailHeaderView: UIView {

    // MARK: 生命周期方法
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kBackgroundColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        self.addSubview(bgView)
        bgView.addSubview(iconView)
        bgView.addSubview(nameLab)
        bgView.addSubview(sharedBtn)
        bgView.addSubview(priceLab)
//        bgView.addSubview(typeLab)
//        bgView.addSubview(saleLab)
//        bgView.addSubview(addressLab)
        
        self.addSubview(productView)
        productView.addSubview(productLab)
        productView.addSubview(rightIconView1)
        
        self.addSubview(areasView)
        areasView.addSubview(areasDesLab)
        areasView.addSubview(areasLab)
        areasView.addSubview(rightIconView2)
        
        self.addSubview(lineView1)
        self.addSubview(detailLab)
        self.addSubview(lineView2)
        
        bgView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(kScreenWidth * 0.75 + 70)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(bgView)
            make.height.equalTo(kScreenWidth * 0.75)
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(iconView.snp.bottom).offset(kMargin)
            make.right.equalTo(sharedBtn.snp.left).offset(-kMargin)
            make.height.equalTo(30)
        }
        sharedBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.equalTo(nameLab)
            make.width.equalTo(60)
            make.height.equalTo(kTitleHeight)
        }
        priceLab.snp.makeConstraints { (make) in
            make.top.equalTo(nameLab.snp.bottom)
            make.left.equalTo(nameLab)
            make.right.equalTo(-kMargin)
//            make.width.equalTo(80)
            make.height.equalTo(20)
        }
        
//        typeLab.snp.makeConstraints { (make) in
//            make.top.height.equalTo(priceLab)
//            make.left.equalTo(priceLab.snp.right)
//            make.width.equalTo(80)
//        }
//        saleLab.snp.makeConstraints { (make) in
//            make.left.equalTo(nameLab)
//            make.top.equalTo(priceLab.snp.bottom).offset(kMargin)
//            make.height.equalTo(20)
//            make.width.equalTo(kScreenWidth * 0.4)
//        }
//        addressLab.snp.makeConstraints { (make) in
//            make.top.height.equalTo(saleLab)
//            make.left.equalTo(saleLab.snp.right).offset(kMargin)
//            make.right.equalTo(-kMargin)
//        }
        
        productView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(bgView.snp.bottom).offset(kMargin)
            make.height.equalTo(kTitleHeight)
        }
        productLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.bottom.equalTo(productView)
            make.right.equalTo(rightIconView1.snp.left).offset(-kMargin)
        }
        rightIconView1.snp.makeConstraints { (make) in
            make.centerY.equalTo(productView)
            make.right.equalTo(-kMargin)
            make.size.equalTo(CGSize.init(width: 7, height: 12))
        }
        
        areasView.snp.makeConstraints { (make) in
            make.left.right.equalTo(productView)
            make.top.equalTo(productView.snp.bottom).offset(klineWidth)
            make.height.equalTo(kTitleHeight)
        }
        areasDesLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.bottom.equalTo(areasView)
            make.width.equalTo(80)
        }
        areasLab.snp.makeConstraints { (make) in
            make.left.equalTo(areasDesLab.snp.right).offset(kMargin)
            make.top.bottom.equalTo(areasDesLab)
            make.right.equalTo(rightIconView2.snp.left).offset(-kMargin)
        }
        rightIconView2.snp.makeConstraints { (make) in
            make.centerY.equalTo(areasView)
            make.right.equalTo(-kMargin)
            make.size.equalTo(rightIconView1.snp.size)
        }
        
        lineView1.snp.makeConstraints { (make) in
            make.right.equalTo(detailLab.snp.left)
            make.centerY.equalTo(detailLab)
            make.size.equalTo(CGSize.init(width: 100, height: klineDoubleWidth))
        }
        detailLab.snp.makeConstraints { (make) in
            make.top.equalTo(areasView.snp.bottom)
            make.centerX.equalTo(self)
            make.width.equalTo(kTitleHeight)
            make.height.equalTo(kTitleHeight)
        }
        lineView2.snp.makeConstraints { (make) in
            make.left.equalTo(detailLab.snp.right)
            make.centerY.size.equalTo(lineView1)
        }
        
        sharedBtn.set(image: UIImage.init(named: "icon_shared_gray"), title: "分享", titlePosition: .bottom, additionalSpacing: 5, state: .normal)
    }
    
    /// 广告轮播图
//    lazy var adsImgView: ZCycleView = {
//        let adsView = ZCycleView()
//        //        adsView.placeholderImage = UIImage.init(named: "icon_home_ads_default")
//        adsView.setImagesGroup([#imageLiteral(resourceName: "icon_home_banner"),#imageLiteral(resourceName: "icon_home_banner"),#imageLiteral(resourceName: "icon_home_banner")])
//        adsView.pageControlAlignment = .center
//        adsView.pageControlIndictirColor = kWhiteColor
//        adsView.pageControlCurrentIndictirColor = kBlueFontColor
//        adsView.scrollDirection = .horizontal
//
//        return adsView
//    }()
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        
        return view
    }()
    /// 商品图标
    lazy var iconView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = kBackgroundColor
        
        return imgView
    }()
    /// 商品名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.text = "美国童年时光钙镁锌婴儿幼儿钙片液体钙"
        
        return lab
    }()
    
    /// 分享
    lazy var sharedBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k10Font
        btn.setTitleColor(kGaryFontColor, for: .normal)
        btn.isHidden = true
        return btn
    }()
    /// 单价
    lazy var priceLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kRedFontColor
        lab.text = "￥298"
        
        return lab
    }()
    /// 会员类型
//    lazy var typeLab : UILabel = {
//        let lab = UILabel()
//        lab.font = k10Font
//        lab.textColor = kBlueFontColor
//        lab.borderColor = kBlueFontColor
//        lab.borderWidth = klineDoubleWidth
//        lab.textAlignment = .center
//        lab.text = "零售型会员"
//
//        return lab
//    }()
    /// 月销
//    lazy var saleLab : UILabel = {
//        let lab = UILabel()
//        lab.font = k12Font
//        lab.textColor = kGaryFontColor
//        lab.text = "月销：1245件"
//
//        return lab
//    }()
    /// 地点
//    lazy var addressLab : UILabel = {
//        let lab = UILabel()
//        lab.font = k12Font
//        lab.textAlignment = .right
//        lab.textColor = kGaryFontColor
//        lab.text = ""
//
//        return lab
//    }()
    /// 产品参数
    lazy var productView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        
        return view
    }()
    
    ///
    lazy var productLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "产品参数"
        
        return lab
    }()
    
    /// 右侧箭头图标
    lazy var rightIconView1: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_arrow"))
    
    /// 我的区域
    lazy var areasView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        
        return view
    }()
    
    ///
    lazy var areasDesLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "我的区域"
        
        return lab
    }()
    
    ///
    lazy var areasLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .right
        lab.text = "选择区域"
        
        return lab
    }()
    
    /// 右侧箭头图标
    lazy var rightIconView2: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_arrow"))
    
    
    /// 分割线
    var lineView1 : UIView = {
        let line = UIView()
        line.backgroundColor = kBlueFontColor
        return line
    }()
    
    /// 详情
    lazy var detailLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlueFontColor
        lab.textAlignment = .center
        lab.text = "详情"
        
        return lab
    }()
    
    /// 分割线
    var lineView2 : UIView = {
        let line = UIView()
        line.backgroundColor = kBlueFontColor
        return line
    }()
}
