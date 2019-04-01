//
//  LHSGeneralHeaderView.swift
//  LazyHuiUser
//  通用 HeaderView
//  Created by gouyz on 2018/1/24.
//  Copyright © 2018年 jh. All rights reserved.
//

import UIKit

class LHSGeneralHeaderView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?){
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kBackgroundColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        contentView.addSubview(bgView)
        bgView.addSubview(nameLab)
        bgView.addSubview(lineView)
        
        bgView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.top.equalTo(kMargin)
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(bgView)
            make.bottom.equalTo(lineView.snp.top)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(bgView)
            make.height.equalTo(klineWidth)
        }
    }
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        
        return view
    }()
    /// 分组名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "服务进度"
        
        return lab
    }()
    /// 底部线
    lazy var lineView: UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
}
