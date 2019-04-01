//
//  GYZLoginInputView.swift
//  baking
//  登录界面的输入View
//  Created by gouyz on 2016/12/1.
//  Copyright © 2016年 gouyz. All rights reserved.
//

import UIKit
import SnapKit

class GYZLoginInputView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    convenience init(iconName : String,placeHolder: String,isPhone: Bool){
        self.init(frame: CGRect.zero)
        
        self.backgroundColor = kWhiteColor
        iconView.image = UIImage(named: iconName)
        textFiled.placeholder = placeHolder
        
        if isPhone {
            textFiled.keyboardType = .numberPad
        }else{
            textFiled.keyboardType = .default
            textFiled.isSecureTextEntry = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI(){
        // 添加子控件
        addSubview(iconView)
        addSubview(textFiled)
        
        // 布局子控件
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(kMargin)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        textFiled.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(kMargin)
            make.top.equalTo(self)
            make.right.equalTo(self).offset(-kMargin)
            make.bottom.equalTo(self)
        }
    }
    
    /// 图标
    fileprivate lazy var iconView: UIImageView = UIImageView()
    /// 输入框
    lazy var textFiled : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
        textFiled.clearButtonMode = .whileEditing
        return textFiled
    }()
}
