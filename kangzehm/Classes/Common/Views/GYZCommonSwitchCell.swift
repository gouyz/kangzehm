//
//  GYZCommonSwitchCell.swift
//  Orange
//  基本信息cell 只包含左label及右侧switchView
//  Created by gouyz on 2018/7/5.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class GYZCommonSwitchCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(nameLab)
        contentView.addSubview(switchView)
        contentView.addSubview(lineView)
        
        nameLab.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.bottom.equalTo(lineView.snp.top)
            make.left.equalTo(kMargin)
            make.right.equalTo(switchView.snp.left).offset(-kMargin)
        }
        switchView.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(contentView)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(klineWidth)
        }
    }
    /// cell title
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        
        return lab
    }()
    /// 开关
    lazy var switchView: UISwitch = {
        let sw = UISwitch()
        return sw
    }()
    
    /// 分割线
    var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
}
