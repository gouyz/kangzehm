//
//  GYZBottomSendView.swift
//  Orange
//  评论 发送bottom View
//  Created by gouyz on 2018/7/4.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class GYZBottomSendView: UIView {

    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
        
        addSubview(bottomView)
        bottomView.addSubview(conmentField)
        bottomView.addSubview(sendBtn)
        
        bottomView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        sendBtn.snp.makeConstraints { (make) in
            make.right.bottom.top.equalTo(bottomView)
            make.width.equalTo(60)
        }
        conmentField.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(8)
            make.bottom.equalTo(-8)
            make.right.equalTo(sendBtn.snp.left).offset(-kMargin)
        }
    }
    lazy var bottomView: UIView = {
        let bView = UIView()
        bView.backgroundColor = kBackgroundColor
        
        return bView
    }()
    lazy var conmentField: UITextField = {
        let txtField = UITextField()
        txtField.textColor = kBlackFontColor
        txtField.font = k15Font
        txtField.placeholder = "写评论"
        txtField.backgroundColor = kWhiteColor
        txtField.cornerRadius = kCornerRadius
        
        return txtField
    }()
    /// 发送
    lazy var sendBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kBlackFontColor, for: .normal)
        btn.setTitle("发送", for: .normal)
        //        btn.addTarget(self, action: #selector(clickedSendBtn), for: .touchUpInside)
        
        return btn
    }()
}
