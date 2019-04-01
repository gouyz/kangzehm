//
//  KZMyAddressCell.swift
//  kangze
//  我的地址
//  Created by gouyz on 2018/9/5.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class KZMyAddressCell: UITableViewCell {
    
    /// 填充数据
    var dataModel : KZMyAddressModel?{
        didSet{
            if let model = dataModel {
                
                nameLab.text = model.true_name
                phoneLab.text = model.mob_phone
                addressLab.text = model.province_name! + model.city_name! + model.area_name! + model.address!
            }
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kBackgroundColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        contentView.addSubview(bgView)
        bgView.addSubview(nameLab)
        bgView.addSubview(phoneLab)
        bgView.addSubview(addressLab)
        bgView.addSubview(lineView)
        bgView.addSubview(editBtn)
        bgView.addSubview(delBtn)
        
        
        bgView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-kMargin)
            make.top.left.right.equalTo(contentView)
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(phoneLab.snp.left).offset(-5)
            make.top.equalTo(kMargin)
            make.height.equalTo(30)
        }
        phoneLab.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.top.height.equalTo(nameLab)
            make.width.equalTo(120)
        }
        
        addressLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.right.equalTo(-kMargin)
            make.top.equalTo(nameLab.snp.bottom).offset(5)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(addressLab)
            make.top.equalTo(addressLab.snp.bottom).offset(kMargin)
            make.height.equalTo(klineWidth)
        }
        editBtn.snp.makeConstraints { (make) in
            make.right.equalTo(delBtn.snp.left).offset(-kMargin)
            make.top.equalTo(lineView.snp.bottom)
            make.width.equalTo(kTitleHeight)
            make.height.equalTo(kTitleHeight)
            make.bottom.equalTo(-5)
        }
        delBtn.snp.makeConstraints { (make) in
            make.right.equalTo(lineView)
            make.top.height.width.equalTo(editBtn)
        }
        
        editBtn.set(image: UIImage.init(named: "icon_address_edit"), title: "编辑", titlePosition: .bottom, additionalSpacing: 5, state: .normal)
        delBtn.set(image: UIImage.init(named: "icon_address_delete"), title: "删除", titlePosition: .bottom, additionalSpacing: 5, state: .normal)
    }
    
    /// 背景View
    fileprivate lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        
        return view
    }()
    /// 姓名
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "张先生"
        
        return lab
    }()
    /// 手机号
    lazy var phoneLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.textAlignment = .right
        lab.text = "13888888888"
        
        return lab
    }()
    ///地址
    lazy var addressLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.numberOfLines = 0
        lab.text = "常州市天宁区延陵西路19号 嘉宏世纪大厦"
        
        return lab
    }()
    /// 分割线
    fileprivate var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 编辑
    lazy var editBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k12Font
        btn.setTitleColor(kHeightGaryFontColor, for: .normal)
        
        return btn
    }()
    /// 删除
    lazy var delBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k12Font
        btn.setTitleColor(kHeightGaryFontColor, for: .normal)
        
        return btn
    }()
}
