//
//  KZFriendCircleCell.swift
//  kangze
//  朋友圈 cell
//  Created by gouyz on 2018/9/3.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class KZFriendCircleCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : KZFriendCircleModel?{
        didSet{
            if let model = dataModel {
                
                userImgView.kf.setImage(with: URL.init(string: model.headpic!), placeholder: UIImage.init(named: "icon_header_default"), options: nil, progressBlock: nil, completionHandler: nil)
                nameLab.text = model.member_name
                contentLab.text = model.content
                
                if model.imageList?.count > 0{
                    imgViews.isHidden = false
                    imgViews.selectImgUrls = model.imageList
                    let rowIndex = ceil(CGFloat.init((imgViews.selectImgUrls?.count)!) / CGFloat.init(imgViews.perRowItemCount))//向上取整
                    
                    imgViews.snp.updateConstraints({ (make) in
                        
                        make.height.equalTo(imgViews.imgHight * rowIndex + kMargin * (rowIndex - 1))
                    })
                }else{
                    imgViews.isHidden = true
                    imgViews.snp.updateConstraints({ (make) in
                        
                        make.height.equalTo(0)
                    })
                }

                
                timeLab.text = model.add_time
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
        
        contentView.addSubview(userImgView)
        contentView.addSubview(nameLab)
        contentView.addSubview(contentLab)
        
        contentView.addSubview(imgViews)
        contentView.addSubview(timeLab)
        contentView.addSubview(sharedLab)
        contentView.addSubview(lineView)
        
        userImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(userImgView.snp.right).offset(kMargin)
            make.centerY.height.equalTo(userImgView)
            make.right.equalTo(-kMargin)
        }
        contentLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(userImgView.snp.bottom).offset(kMargin)
        }
        imgViews.snp.makeConstraints { (make) in
            make.top.equalTo(contentLab.snp.bottom).offset(kMargin)
            make.left.right.equalTo(contentLab)
            make.height.equalTo(0)
        }
        timeLab.snp.makeConstraints { (make) in
            make.left.height.equalTo(userImgView)
            make.right.equalTo(sharedLab.snp.left).offset(-kMargin)
            make.top.equalTo(imgViews.snp.bottom).offset(kMargin)
        }
        
        sharedLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(timeLab)
            make.height.equalTo(20)
            make.width.equalTo(70)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.bottom.equalTo(-klineWidth)
            make.top.equalTo(timeLab.snp.bottom).offset(kMargin)
        }
    }
    
    /// 用户头像图片
    lazy var userImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "icon_header_default")
        imgView.cornerRadius = 15
        
        return imgView
    }()
    /// 用户名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k15Font
        
        return lab
    }()
    /// 内容
    lazy var contentLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kHeightGaryFontColor
        lab.font = k13Font
        lab.numberOfLines = 0
        
        return lab
    }()
    /// 九宫格图片显示
    lazy var imgViews: GYZPhotoView = GYZPhotoView()
    /// 时间
    lazy var timeLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kGaryFontColor
        lab.font = k13Font
        lab.text = "2018-09-03"
        
        return lab
    }()
    /// 一键转发
    lazy var sharedLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = k12Font
        lab.textAlignment = .center
        lab.cornerRadius = 10
        lab.backgroundColor = kBlueFontColor
        lab.text = "一键转发"
        
        return lab
    }()
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
}
