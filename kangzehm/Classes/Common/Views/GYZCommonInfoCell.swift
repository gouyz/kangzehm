//
//  GYZCommonInfoCell.swift
//  pureworks
//  基本信息cell 只包含左右2个label及分割线
//  Created by gouyz on 2018/6/7.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class GYZCommonInfoCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.backgroundColor = kWhiteColor
        
        contentView.addSubview(titleLab)
        contentView.addSubview(contentLab)
        contentView.addSubview(lineView)
        
        titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(contentView)
            make.height.equalTo(kTitleHeight)
            make.width.equalTo(100)
        }
        contentLab.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.centerY.equalTo(contentView)
            make.left.equalTo(titleLab.snp.right).offset(kMargin)
            make.right.equalTo(-kMargin)
            make.height.greaterThanOrEqualTo(34)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(klineWidth)
        }
    }
    
    /// 标题
    var titleLab : UILabel = {
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
        lab.numberOfLines = 0
        lab.textAlignment = .right
        
        return lab
    }()
    /// 分割线
    var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
}
