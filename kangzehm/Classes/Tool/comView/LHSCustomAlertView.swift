//
//  LHSCustomAlertView.swift
//  LazyHuiService
//  自定义带输入框的alert
//  Created by gouyz on 2017/7/3.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class LHSCustomAlertView: UIView,UITextViewDelegate {
    
    weak var delegate: CustomAlertViewDelegate?
    ///txtView 提示文字
    var placeHolder = ""
    ///输入内容
    var content: String = ""
    
    ///点击事件闭包
    var action:((_ alertView: LHSCustomAlertView,_ index: Int) -> Void)?

    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    convenience init(){
        let rect = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        self.init(frame: rect)
        
        self.backgroundColor = UIColor.clear
        
        backgroundView.frame = rect
        backgroundView.backgroundColor = kBlackColor
        addSubview(backgroundView)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func setupUI(){
        
        bgView.backgroundColor = kWhiteColor
        addSubview(bgView)
        
        bgView.addSubview(titleLab)
        bgView.addSubview(noDealTxtView)
        bgView.addSubview(cancleBtn)
        bgView.addSubview(okBtn)
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.centerY.equalTo(self)
            make.height.equalTo(240)
        }
        
        titleLab.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(bgView)
            make.height.equalTo(kTitleHeight)
        }
        
        noDealTxtView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLab.snp.bottom).offset(kMargin)
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.height.equalTo(120)
        }
        
        cancleBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(-10)
            make.left.equalTo(noDealTxtView)
            make.right.equalTo(okBtn.snp.left).offset(-30)
            make.height.equalTo(34)
            make.width.equalTo(okBtn)
        }
        
        okBtn.snp.makeConstraints { (make) in
            make.bottom.height.width.equalTo(cancleBtn)
            make.right.equalTo(noDealTxtView)
        }
        
    }
    ///整体背景
    lazy var backgroundView: UIView = UIView()
    
    lazy var bgView: UIView = UIView()
    /// 标题
    lazy var titleLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kWhiteColor
        lab.backgroundColor = kNavBarColor
        lab.textAlignment = .center
        
        return lab
    }()
    
    ///输入框
    lazy var noDealTxtView: UITextView = {
        let txtView = UITextView()
        txtView.backgroundColor = kBackgroundColor
        txtView.font = k15Font
        txtView.textColor = kGaryFontColor
        txtView.delegate = self
        
        return txtView
    }()
    /// 取消
    lazy var cancleBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnNoClickBGColor
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("取消", for: .normal)
        btn.tag = 101
        btn.addTarget(self, action: #selector(clickedBtn(btn:)), for: .touchUpInside)
        return btn
    }()
    /// 确定
    lazy var okBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("确定", for: .normal)
        btn.tag = 102
        btn.addTarget(self, action: #selector(clickedBtn(btn:)), for: .touchUpInside)
        return btn
    }()
    
    /// 点击事件
    ///
    /// - Parameter btn:
    @objc func clickedBtn(btn: UIButton){
        
        let tag = btn.tag - 100
        
        delegate?.alertViewDidClickedBtnAtIndex(alertView: self, index: tag)
        if action != nil {
            action!(self, tag)
        }
        
        hide()
        
    }
    
    func show(){
        UIApplication.shared.keyWindow?.addSubview(self)
        
        showBackground()
        showAlertAnimation()
    }
    func hide(){
        bgView.isHidden = true
        hideAlertAnimation()
        self.removeFromSuperview()
    }
    
    fileprivate func showBackground(){
        backgroundView.alpha = 0.0
        UIView.beginAnimations("fadeIn", context: nil)
        UIView.setAnimationDuration(0.35)
        backgroundView.alpha = 0.6
        UIView.commitAnimations()
    }
    
    fileprivate func showAlertAnimation(){
        let popAnimation = CAKeyframeAnimation(keyPath: "transform")
        popAnimation.duration = 0.3
        popAnimation.values   = [
            NSValue.init(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 1.0)),
            NSValue.init(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0)),
            NSValue.init(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)),
            NSValue.init(caTransform3D: CATransform3DIdentity)
        ]
        
        popAnimation.isRemovedOnCompletion = true
        popAnimation.fillMode = kCAFillModeForwards
        bgView.layer.add(popAnimation, forKey: nil)
    }
    
    fileprivate func hideAlertAnimation(){
        UIView.beginAnimations("fadeIn", context: nil)
        UIView.setAnimationDuration(0.35)
        backgroundView.alpha = 0.0
        UIView.commitAnimations()
    }
    
    ///MARK UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        let text = textView.text
        if text == placeHolder {
            textView.text = ""
            textView.textColor = kBlackFontColor
        }
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            textView.text = placeHolder
            textView.textColor = kGaryFontColor
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        
        let text : String = textView.text
        /// 过滤输入emoji
        if !text.isEmpty {
            let modifyStr: String = GYZTool.disableEmoji(text: text)
            if text != modifyStr {
                let range = textView.selectedRange
                textView.text = modifyStr
                textView.selectedRange = range
                
                content = modifyStr
                return
            }
        }
        content = text
    }
}

protocol CustomAlertViewDelegate: NSObjectProtocol {
    /// 点击事件
    ///
    /// - Parameters:
    ///   - alertView: alertView
    ///   - index: 按钮索引
    func alertViewDidClickedBtnAtIndex(alertView: LHSCustomAlertView,index: Int)
}
