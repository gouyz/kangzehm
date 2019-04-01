//
//  KZGoodDetailBottomView.swift
//  kangze
//  商品详情 bottom
//  Created by gouyz on 2018/8/30.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class KZGoodDetailBottomView: UIView {

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
        self.addSubview(shopView)
        shopView.addSubview(shopBtn)
        self.addSubview(favouriteView)
        favouriteView.addSubview(favouriteBtn)
        self.addSubview(cartBtn)
        self.addSubview(buyBtn)
        
        shopView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(self)
            make.width.equalTo(favouriteView)
        }
        shopBtn.snp.makeConstraints { (make) in
            make.center.equalTo(shopView)
            make.size.equalTo(CGSize.init(width: kTitleHeight, height: kTitleHeight))
        }
        favouriteView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(shopView)
            make.left.equalTo(shopView.snp.right)
            make.width.equalTo(cartBtn)
        }
        cartBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(shopView)
            make.left.equalTo(favouriteView.snp.right)
            make.width.equalTo(buyBtn)
        }
        
        buyBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(shopView)
            make.left.equalTo(cartBtn.snp.right)
            make.right.equalTo(self)
            make.width.equalTo(shopView)
        }
        
        favouriteBtn.snp.makeConstraints { (make) in
            make.center.equalTo(favouriteView)
            make.size.equalTo(CGSize.init(width: kTitleHeight, height: kTitleHeight))
        }
        
        shopBtn.set(image: UIImage.init(named: "icon_detail_shop"), title: "商城", titlePosition: .bottom, additionalSpacing: 5, state: .normal)
        favouriteBtn.set(image: UIImage.init(named: "icon_favorite_rating"), title: "收藏", titlePosition: .bottom, additionalSpacing: 5, state: .normal)
    }
    
    lazy var shopView: UIView = UIView()
    /// 商城
    lazy var shopBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k10Font
        btn.setTitleColor(kHeightGaryFontColor, for: .normal)
        btn.tag = 101
        btn.addTarget(self, action: #selector(clickedOperateBtn(btn:)), for: .touchUpInside)
        return btn
    }()
    lazy var favouriteView: UIView = UIView()
    /// 收藏
    lazy var favouriteBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k10Font
        btn.setTitleColor(kHeightGaryFontColor, for: .normal)
        btn.tag = 102
        btn.addTarget(self, action: #selector(clickedOperateBtn(btn:)), for: .touchUpInside)
        return btn
    }()
    /// 加入购物车
    lazy var cartBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = UIColor.RGBColor(66, g: 169, b: 223)
        btn.titleLabel?.font = k13Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("加入购物车", for: .normal)
        btn.tag = 103
        btn.addTarget(self, action: #selector(clickedOperateBtn(btn:)), for: .touchUpInside)
        return btn
    }()
    /// 立即购买
    lazy var buyBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBlueFontColor
        btn.titleLabel?.font = k13Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("立即购买", for: .normal)
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
