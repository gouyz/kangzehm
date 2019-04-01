//
//  KZMessageCell.swift
//  kangze
//  消息cell
//  Created by gouyz on 2018/9/30.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class KZMessageCell: UITableViewCell {

    /// 填充数据
    var dataModel : KZMessageModel?{
        didSet{
            if let model = dataModel {
                
                nameLab.text = model.article_title
                desLab.text = model.article_time?.getDateTime(format: "yyyy-MM-dd HH:mm:ss")
                
                if model.read_status == "0" {//未读  加粗
                    nameLab.font = UIFont.boldSystemFont(ofSize: 15)
                    nameLab.textColor = kBlackFontColor
                    desLab.font = UIFont.boldSystemFont(ofSize: 13)
                }else{
                    nameLab.font = k15Font
                    desLab.font = k13Font
                    nameLab.textColor = kHeightGaryFontColor
                }
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
        
        contentView.addSubview(desLab)
        contentView.addSubview(nameLab)
        contentView.addSubview(rightIconView)
        
        nameLab.snp.makeConstraints { (make) in
            make.top.equalTo(kMargin)
            make.left.equalTo(kMargin)
            make.right.equalTo(rightIconView.snp.left).offset(-kMargin)
            make.height.equalTo(30)
        }
        desLab.snp.makeConstraints { (make) in
            make.top.equalTo(nameLab.snp.bottom)
            make.left.right.height.equalTo(nameLab)
            make.bottom.equalTo(-kMargin)
        }
        
        rightIconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(-kMargin)
            make.size.equalTo(CGSize.init(width: 7, height: 12))
        }
    }
    
    /// cell title
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "消息标题"
        
        return lab
    }()
    ///消息详情
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        lab.numberOfLines = 0
        lab.text = "消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容消息内容"
        
        return lab
    }()
    /// 右侧箭头图标
    lazy var rightIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_gray"))
}
