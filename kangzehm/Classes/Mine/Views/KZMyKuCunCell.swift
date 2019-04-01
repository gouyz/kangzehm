//
//  KZMyKuCunCell.swift
//  kangze
//  我的库存 cell
//  Created by gouyz on 2018/9/5.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class KZMyKuCunCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : KZMyKuCunModel?{
        didSet{
            if let model = dataModel {
                
                iconView.kf.setImage(with: URL.init(string: model.image_url!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
                
                nameLab.text = model.goods_name
                numberLab.text = "X\(model.stock!)"
                unitLab.text = (model.unit?.isEmpty)! ? "" : "单位：\(model.unit!)"
            }
        }
    }

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
        contentView.addSubview(numberLab)
        contentView.addSubview(unitLab)
        contentView.addSubview(historySendBtn)
        contentView.addSubview(sendBtn)
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.size.equalTo(CGSize.init(width: 100, height: 100))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(kMargin)
            make.top.equalTo(iconView)
            make.right.equalTo(-kMargin)
            make.height.equalTo(kTitleHeight)
        }
        unitLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.top.equalTo(nameLab.snp.bottom)
            make.bottom.equalTo(sendBtn.snp.top)
            make.right.equalTo(numberLab.snp.left).offset(-kMargin)
        }
        numberLab.snp.makeConstraints { (make) in
            make.right.equalTo(nameLab)
            make.top.bottom.equalTo(unitLab)
            make.width.equalTo(80)
        }
        sendBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(iconView)
            make.width.equalTo(70)
            make.height.equalTo(20)
        }
        historySendBtn.snp.makeConstraints { (make) in
            make.right.equalTo(sendBtn.snp.left).offset(-20)
            make.bottom.height.width.equalTo(sendBtn)
        }
    }
    
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
        lab.numberOfLines = 2
        
        return lab
    }()
    /// 库存数量
    lazy var numberLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .right
        lab.text = "X5"
        
        return lab
    }()
    /// 单位
    lazy var unitLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kGaryFontColor
        
        return lab
    }()
    /// 历史发货
    lazy var historySendBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBlueFontColor
        btn.titleLabel?.font = k12Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("历史发货", for: .normal)
        btn.cornerRadius = kCornerRadius
        
        return btn
    }()
    /// 申请发货
    lazy var sendBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBlueFontColor
        btn.titleLabel?.font = k12Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("申请发货", for: .normal)
        btn.cornerRadius = kCornerRadius
        
        return btn
    }()
}
