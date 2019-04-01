//
//  LHSCheckView.swift
//  LazyHuiService
//  自定义 CheckBox View
//  Created by gouyz on 2017/7/5.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class LHSCheckView: UIView {
    
    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        addSubview(tagImgView)
        addSubview(nameLab)
        
        tagImgView.snp.makeConstraints { (make) in
            make.left.centerY.equalTo(self)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(tagImgView.snp.right).offset(5)
            make.top.bottom.right.equalTo(self)
        }
        
    }
    
    /// 图片tag
    lazy var tagImgView : UIImageView = UIImageView()
    /// 名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        
        return lab
    }()
}
