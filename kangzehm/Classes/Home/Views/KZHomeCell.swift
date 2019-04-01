//
//  KZHomeCell.swift
//  kangze
//  首页 cell
//  Created by gouyz on 2018/8/28.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class KZHomeCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kBackgroundColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(bgView)
        bgView.addSubview(iconView)
        bgView.addSubview(nameLab)
        bgView.addSubview(adsImgView)
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(kMargin)
            make.left.right.bottom.equalTo(contentView)
        }
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(nameLab)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(kMargin)
            make.top.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.height.equalTo(30)
        }
        adsImgView.snp.makeConstraints { (make) in
            make.top.equalTo(nameLab.snp.bottom).offset(kMargin)
            make.right.equalTo(-kMargin)
            make.left.equalTo(kMargin)
            make.bottom.equalTo(-kMargin)
        }
    }
    
    ///
    var bgView : UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        return view
    }()
    /// 图标
    lazy var iconView: UIImageView = UIImageView()
    
    /// cell title
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlueFontColor
        
        return lab
    }()
    
    /// banner图标
    lazy var adsImgView: UIImageView =  {
        let imgView = UIImageView()
        imgView.backgroundColor = kBackgroundColor
        
        return imgView
    }()
}
