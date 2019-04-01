//
//  GYZCommonIconArrowCell.swift
//  BenefitPet
//  基本信息cell 只包含左侧icon、左右2个label及右侧箭头
//  Created by gouyz on 2018/7/31.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class GYZCommonIconArrowCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(iconView)
        contentView.addSubview(nameLab)
        contentView.addSubview(contentLab)
        contentView.addSubview(rightIconView)
        contentView.addSubview(lineView)
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(kMargin)
            make.top.bottom.equalTo(contentView)
            make.width.equalTo(120)
        }
        contentLab.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(nameLab)
            make.right.equalTo(rightIconView.snp.left).offset(-5)
            make.left.equalTo(nameLab.snp.right).offset(kMargin)
        }
        rightIconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(-kMargin)
            make.size.equalTo(CGSize.init(width: 7, height: 12))
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(klineWidth)
        }
    }
    
    /// 图标
    lazy var iconView: UIImageView = UIImageView()
    
    /// cell title
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        
        return lab
    }()
    
    /// 内容
    var contentLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .right
        
        return lab
    }()
    /// 右侧箭头图标
    lazy var rightIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_arrow"))
    
    /// 分割线
    lazy var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
}
