//
//  KZKuCunInfoCell.swift
//  kangze
//  库存明细cell
//  Created by gouyz on 2018/9/7.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class KZKuCunInfoCell: UITableViewCell {

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
        contentView.addSubview(numberLab)
        
        titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.bottom.equalTo(contentView)
            make.right.equalTo(numberLab.snp.left)
        }
        numberLab.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(titleLab)
            make.right.equalTo(contentView)
            make.width.equalTo(80)
        }
        
    }
    
    /// 产品
    var titleLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.text = "美好时光钙镁锌"
        
        return lab
    }()
    /// 数量
    var numberLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.text = "数量"
        lab.textAlignment = .center
        
        return lab
    }()
    
}
