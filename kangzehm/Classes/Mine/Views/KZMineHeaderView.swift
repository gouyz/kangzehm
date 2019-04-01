//
//  KZMineHeaderView.swift
//  kangze
//  我的 header View
//  Created by gouyz on 2018/8/31.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class KZMineHeaderView: UIView {

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
        self.addSubview(bgViewImg)
        bgViewImg.addSubview(bgView)
        bgView.addSubview(userHeaderView)
        bgView.addSubview(nameLab)
        bgView.addSubview(typeLab)
        bgView.addSubview(phoneLab)
        
        bgViewImg.addSubview(leftView)
        leftView.addSubview(favouriteNumberLab)
        leftView.addSubview(favouriteLab)
        bgViewImg.addSubview(rightView)
        rightView.addSubview(kuCunNumberLab)
        rightView.addSubview(kuCunLab)
        
        bgViewImg.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.top.equalTo(kStateHeight)
        }
        bgView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(bgViewImg)
            make.bottom.equalTo(leftView.snp.top)
        }
        userHeaderView.snp.makeConstraints { (make) in
            make.centerX.equalTo(bgView)
            make.top.equalTo(kMargin)
            make.size.equalTo(CGSize.init(width: kTitleHeight, height: kTitleHeight))
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
        leftView.snp.makeConstraints { (make) in
            make.left.bottom.equalTo(bgViewImg)
            make.width.equalTo(rightView)
            make.height.equalTo(50)
        }
        favouriteNumberLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(5)
            make.height.equalTo(20)
            make.width.equalTo(kuCunNumberLab)
        }
        kuCunNumberLab.snp.makeConstraints { (make) in
            make.left.equalTo(favouriteNumberLab.snp.right).offset(kMargin)
            make.top.height.width.equalTo(favouriteNumberLab)
            make.right.equalTo(-kMargin)
        }
        rightView.snp.makeConstraints { (make) in
            make.left.equalTo(leftView.snp.right)
            make.right.bottom.equalTo(bgViewImg)
            make.height.equalTo(leftView)
        }
        favouriteLab.snp.makeConstraints { (make) in
            make.left.height.equalTo(favouriteNumberLab)
            make.top.equalTo(favouriteNumberLab.snp.bottom)
            make.width.equalTo(kuCunLab)
        }
        kuCunLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(kuCunNumberLab)
            make.top.equalTo(kuCunNumberLab.snp.bottom)
            make.width.equalTo(favouriteLab)
        }
    }
    
    /// 背景
    lazy var bgViewImg: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "icon_mine_bg"))
        imgView.isUserInteractionEnabled = true
        
        return imgView
    }()
    /// 背景
    lazy var bgView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        return view
    }()
    
    /// 用户头像 图片
    lazy var userHeaderView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "icon_header_default"))
        imgView.cornerRadius = 22
        imgView.isUserInteractionEnabled = true
        
        return imgView
    }()
    lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kWhiteColor
        lab.textAlignment = .center
        lab.text = "登录/注册"
        
        return lab
    }()
    /// 会员类型
    lazy var typeLab: UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kWhiteColor
        lab.textAlignment = .center
        lab.text = "会员"
        
        return lab
    }()
    /// 手机号
    lazy var phoneLab: UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kWhiteColor
        lab.textAlignment = .center
        lab.text = "手机号"
        
        return lab
    }()
    
    /// 背景
    lazy var leftView: UIView = {
        let view = UIView()
        return view
    }()
    
    /// 我的收藏 数量
    lazy var favouriteNumberLab: UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kWhiteColor
        lab.textAlignment = .center
        lab.text = "0"
        
        return lab
    }()
    /// 我的收藏
    lazy var favouriteLab: UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kWhiteColor
        lab.textAlignment = .center
        lab.text = "我的收藏"
        
        return lab
    }()
    /// 背景
    lazy var rightView: UIView = {
        let view = UIView()
        return view
    }()
    /// 我的库存 数量
    lazy var kuCunNumberLab: UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kWhiteColor
        lab.textAlignment = .center
        lab.text = "0"
        
        return lab
    }()
    /// 我的库存
    lazy var kuCunLab: UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kWhiteColor
        lab.textAlignment = .center
        lab.text = "我的库存"
        
        return lab
    }()
}
