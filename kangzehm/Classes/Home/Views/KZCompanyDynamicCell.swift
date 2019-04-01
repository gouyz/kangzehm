//
//  KZCompanyDynamicCell.swift
//  kangze
//  公司动态、文章cell
//  Created by gouyz on 2018/8/31.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class KZCompanyDynamicCell: UITableViewCell {
    
    /// 闭包回调
    public var sharedBlock: (() ->())?
    
    /// 填充数据
    var dataModel : KZArticleModel?{
        didSet{
            if let model = dataModel {
                
                iconView.kf.setImage(with: URL.init(string: model.thumb!), placeholder: UIImage.init(named: "icon_dynamic_default"), options: nil, progressBlock: nil, completionHandler: nil)
                nameLab.text = model.article_title
                dateLab.text = model.article_time?.getDateTime(format: "yyyy-MM-dd")
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
        contentView.addSubview(dateLab)
        contentView.addSubview(sharedLab)
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize.init(width: 90, height: 60))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(kMargin)
            make.top.equalTo(iconView)
            make.right.equalTo(-kMargin)
            make.height.equalTo(40)
        }
        dateLab.snp.makeConstraints { (make) in
            make.top.equalTo(nameLab.snp.bottom)
            make.left.equalTo(nameLab)
            make.bottom.equalTo(iconView)
            make.right.equalTo(sharedLab.snp.left).offset(-kMargin)
        }
        sharedLab.snp.makeConstraints { (make) in
            make.right.equalTo(nameLab)
            make.bottom.top.equalTo(dateLab)
            make.width.equalTo(60)
        }
    }
    /// 图标
    lazy var iconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_dynamic_default"))
    
    /// cell title
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlackFontColor
        lab.numberOfLines = 2
        lab.text = "恰恰与流行观念相反，恰恰与流行观念相反，恰恰与流行观念相反，恰恰与流行观念相反"
        
        return lab
    }()
    
    /// 日期
    lazy var dateLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kGaryFontColor
        lab.text = "2018-08-31"
        
        return lab
    }()
    /// 分享
    lazy var sharedLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kGaryFontColor
        lab.textAlignment = .right
        lab.text = "分享"
        lab.isHidden = true
        lab.addOnClickListener(target: self, action: #selector(onClickedShared))
        
        return lab
    }()
    ///分享
    @objc func onClickedShared(){
        
        if sharedBlock != nil {
            sharedBlock!()
        }
    }
}
