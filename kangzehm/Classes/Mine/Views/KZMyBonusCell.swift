//
//  KZMyBonusCell.swift
//  kangze
//  业绩奖金 cell
//  Created by gouyz on 2018/9/6.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class KZMyBonusCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(bgView)
        bgView.addSubview(rightIconView)
        bgView.addSubview(lineView)
        bgView.addSubview(nameLab)
        bgView.addSubview(moneyLab)
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(kMargin)
            make.left.right.bottom.equalTo(contentView)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.bottom.equalTo(-kMargin)
            make.width.equalTo(5)
        }
        
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(lineView.snp.right).offset(5)
            make.top.bottom.equalTo(bgView)
            make.width.equalTo(80)
        }
        moneyLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab.snp.right).offset(kMargin)
            make.right.equalTo(rightIconView.snp.left).offset(-kMargin)
            make.top.bottom.equalTo(nameLab)
        }
        rightIconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(bgView)
            make.right.equalTo(-kMargin)
            make.size.equalTo(CGSize.init(width: 7, height: 12))
        }
    }
    ///
    var bgView : UIView = {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
    ///
    var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kBlueFontColor
        
        return line
    }()
    /// cell title
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlueFontColor
        lab.text = "一级市场"
        
        return lab
    }()
    /// 业绩
    lazy var moneyLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlueFontColor
        lab.textAlignment = .right
        lab.text = "本月销售业绩：￥0.00"
        
        return lab
    }()
    
    /// 右侧箭头图标
    lazy var rightIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_arrow"))
    
}
