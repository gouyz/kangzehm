//
//  KZSelectPayMethodView.swift
//  kangze
//  支付方式选择
//  Created by gouyz on 2018/9/4.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

class KZSelectPayMethodView: UIView {
    
    /// 选择结果回调
    var selectPayTypeBlock:((_ payMethod: Int) -> Void)?
    /// 支付方式
    var payType: Int = 0

    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    convenience init(){
        let rect = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        self.init(frame: rect)
        
        self.backgroundColor = UIColor.clear
        
        backgroundView.frame = rect
        backgroundView.alpha = 0
        backgroundView.backgroundColor = kBlackColor
        addSubview(backgroundView)
        backgroundView.addOnClickListener(target: self, action: #selector(onTapCancle(sender:)))
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        addSubview(bgView)
        bgView.addOnClickListener(target: self, action: #selector(onBlankClicked))
        
        bgView.addSubview(yuEView)
        yuEView.addSubview(yuEIconView)
        yuEView.addSubview(yuENameLab)
        yuEView.addSubview(yuEMoneyLab)
        yuEView.addSubview(yuECheckBtn)
        bgView.addSubview(lineView)
        
        bgView.addSubview(alipayView)
        alipayView.addSubview(alipayIconView)
        alipayView.addSubview(alipayNameLab)
        alipayView.addSubview(alipayCheckBtn)
        bgView.addSubview(lineView1)
        
        bgView.addSubview(weChatView)
        weChatView.addSubview(weChatIconView)
        weChatView.addSubview(weChatLab)
        weChatView.addSubview(weChatCheckBtn)
        bgView.addSubview(lineView2)
        
        bgView.addSubview(posView)
        posView.addSubview(posIconView)
        posView.addSubview(posLab)
        posView.addSubview(posCheckBtn)
        bgView.addSubview(lineView3)
        
        bgView.addSubview(payBtn)
        
        bgView.frame = CGRect.init(x: kMargin, y: frame.size.height, width: kScreenWidth - 20, height: 50 * 5 + klineWidth * 4)
        
        yuEView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(bgView)
            make.height.equalTo(50)
        }
        yuEIconView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(yuEView)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        yuENameLab.snp.makeConstraints { (make) in
            make.left.equalTo(yuEIconView.snp.right).offset(kMargin)
            make.width.equalTo(80)
            make.top.bottom.equalTo(yuEView)
        }
        yuEMoneyLab.snp.makeConstraints { (make) in
            make.right.equalTo(yuECheckBtn.snp.left).offset(-kMargin)
            make.left.equalTo(yuENameLab.snp.right).offset(kMargin)
            make.top.bottom.equalTo(yuEView)
        }
        yuECheckBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(yuEView)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(bgView)
            make.top.equalTo(yuEView.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        
        alipayView.snp.makeConstraints { (make) in
            make.left.right.equalTo(yuEView)
            make.height.equalTo(50)
            make.top.equalTo(lineView.snp.bottom)
        }
        alipayIconView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(alipayView)
            make.size.equalTo(yuEIconView)
        }
        alipayNameLab.snp.makeConstraints { (make) in
            make.left.equalTo(alipayIconView.snp.right).offset(5)
            make.right.equalTo(alipayCheckBtn.snp.left).offset(-kMargin)
            make.top.bottom.equalTo(alipayView)
        }
        alipayCheckBtn.snp.makeConstraints { (make) in
            make.right.equalTo(alipayView).offset(-kMargin)
            make.centerY.equalTo(alipayView)
            make.size.equalTo(yuECheckBtn)
        }
        
        lineView1.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(alipayView.snp.bottom)
        }
        
        weChatView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(alipayView)
            make.top.equalTo(lineView1.snp.bottom)
        }
        weChatIconView.snp.makeConstraints { (make) in
            make.left.equalTo(weChatView).offset(kMargin)
            make.centerY.equalTo(weChatView)
            make.size.equalTo(alipayIconView)
        }
        weChatLab.snp.makeConstraints { (make) in
            make.left.equalTo(weChatIconView.snp.right).offset(5)
            make.right.equalTo(weChatCheckBtn.snp.left).offset(-kMargin)
            make.top.bottom.equalTo(weChatView)
        }
        weChatCheckBtn.snp.makeConstraints { (make) in
            make.right.equalTo(weChatView).offset(-kMargin)
            make.centerY.equalTo(weChatView)
            make.size.equalTo(alipayCheckBtn)
        }
        lineView2.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(weChatView.snp.bottom)
        }
        posView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(alipayView)
            make.top.equalTo(lineView2.snp.bottom)
        }
        posIconView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(posView)
            make.size.equalTo(alipayIconView)
        }
        posLab.snp.makeConstraints { (make) in
            make.left.equalTo(posIconView.snp.right).offset(5)
            make.right.equalTo(posCheckBtn.snp.left).offset(-kMargin)
            make.top.bottom.equalTo(posView)
        }
        posCheckBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(posView)
            make.size.equalTo(alipayCheckBtn)
        }
        lineView3.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(posView.snp.bottom)
        }
        
        payBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(-7)
            make.centerX.equalTo(bgView)
            make.size.equalTo(CGSize.init(width: kScreenWidth * 0.5, height: 30))
        }
    }
    
    ///整体背景
    var backgroundView: UIView = UIView()
    /// 透明背景
    var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        view.cornerRadius  = kCornerRadius
        
        return view
    }()
    lazy var yuEView: UIView = {
        let view = UIView()
        view.addOnClickListener(target: self, action: #selector(onClickPayView(sender:)))
        view.tag = 101
        
        return view
    }()
    /// 图标
    lazy var yuEIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_pay_yue"))
    /// 余额支付
    lazy var yuENameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "余额支付"
        
        return lab
    }()
    /// 可用余额
    lazy var yuEMoneyLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kBlueFontColor
        lab.textAlignment = .right
        lab.text = "可用余额：￥30"
        
        return lab
    }()
    /// 选择图标
    lazy var yuECheckBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "icon_check"), for: .normal)
        btn.setImage(UIImage.init(named: "icon_check_selected"), for: .selected)
        btn.tag = 101
        
        btn.addTarget(self, action: #selector(onClickedPayBtn(sender:)), for: .touchUpInside)
        return btn
    }()
    /// 线
    lazy var lineView: UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    
    lazy var alipayView: UIView = {
        let view = UIView()
        view.addOnClickListener(target: self, action: #selector(onClickPayView(sender:)))
        view.tag = 102
        
        return view
    }()
    /// 图标
    lazy var alipayIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_pay_alipay"))
    /// 支付宝支付
    lazy var alipayNameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "支付宝支付"
        
        return lab
    }()
    /// 选择图标
    lazy var alipayCheckBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "icon_check"), for: .normal)
        btn.setImage(UIImage.init(named: "icon_check_selected"), for: .selected)
        btn.tag = 102
        
        btn.addTarget(self, action: #selector(onClickedPayBtn(sender:)), for: .touchUpInside)
        return btn
    }()
    /// 线
    lazy var lineView1: UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    
    lazy var weChatView: UIView = {
        let view = UIView()
        view.addOnClickListener(target: self, action: #selector(onClickPayView(sender:)))
        view.tag = 103
        
        return view
    }()
    /// 图标
    lazy var weChatIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_pay_wechat"))
    /// 微信支付
    lazy var weChatLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "微信支付"
        
        return lab
    }()
    /// 选择图标
    lazy var weChatCheckBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "icon_check"), for: .normal)
        btn.setImage(UIImage.init(named: "icon_check_selected"), for: .selected)
        btn.tag = 103
        
        btn.addTarget(self, action: #selector(onClickedPayBtn(sender:)), for: .touchUpInside)
        return btn
    }()
    /// 线
    lazy var lineView2: UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    lazy var posView: UIView = {
        let view = UIView()
        view.addOnClickListener(target: self, action: #selector(onClickPayView(sender:)))
        view.tag = 104
        
        return view
    }()
    /// pos图标
    lazy var posIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_pay_pos"))
    /// pos支付
    lazy var posLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "pos机支付"
        
        return lab
    }()
    /// 选择图标
    lazy var posCheckBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "icon_check"), for: .normal)
        btn.setImage(UIImage.init(named: "icon_check_selected"), for: .selected)
        btn.tag = 104
        
        btn.addTarget(self, action: #selector(onClickedPayBtn(sender:)), for: .touchUpInside)
        return btn
    }()
    /// 线
    lazy var lineView3: UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    
    /// 确认支付
    lazy var payBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("确认支付", for: .normal)
        btn.addTarget(self, action: #selector(clickedPayBtn), for: .touchUpInside)
        
        return btn
    }()
    
    @objc func onClickPayView(sender: UITapGestureRecognizer){
        let tag = sender.view?.tag
        
        setCheckView(index: tag!)
    }
    
    @objc func onClickedPayBtn(sender: UIButton){
        let tag = sender.tag
        
        setCheckView(index: tag)
    }
    
    func setCheckView(index : Int){
        
        payType = index - 100
        switch index {
        case 101:// 余额支付
            yuECheckBtn.isSelected = true
            alipayCheckBtn.isSelected = false
            weChatCheckBtn.isSelected = false
            posCheckBtn.isSelected = false
        case 102:// 支付宝支付
            yuECheckBtn.isSelected = false
            alipayCheckBtn.isSelected = true
            weChatCheckBtn.isSelected = false
            posCheckBtn.isSelected = false
        case 103://微信支付
            yuECheckBtn.isSelected = false
            alipayCheckBtn.isSelected = false
            weChatCheckBtn.isSelected = true
            posCheckBtn.isSelected = false
        case 104://pos支付
            yuECheckBtn.isSelected = false
            alipayCheckBtn.isSelected = false
            weChatCheckBtn.isSelected = false
            posCheckBtn.isSelected = true
        default:
            break
        }
    }
    /// 支付
    @objc func clickedPayBtn(){
        
        if selectPayTypeBlock != nil {
            selectPayTypeBlock!(payType)
        }
    }
    
    /// 显示
    func show(){
        UIApplication.shared.keyWindow?.addSubview(self)
        
        addAnimation()
    }
    
    ///添加显示动画
    func addAnimation(){
        
        weak var weakSelf = self
        UIView.animate(withDuration: 0.5, animations: {
            
            weakSelf?.bgView.frame = CGRect.init(x: (weakSelf?.bgView.frame.origin.x)!, y: (weakSelf?.frame.size.height)! - (weakSelf?.bgView.frame.size.height)!, width: (weakSelf?.bgView.frame.size.width)!, height: (weakSelf?.bgView.frame.size.height)!)
            
//            weakSelf?.bgView.center = (weakSelf?.center)!
            weakSelf?.backgroundView.alpha = 0.2
            
        }) { (finished) in
            
        }
    }
    
    ///移除动画
    func removeAnimation(){
        weak var weakSelf = self
        UIView.animate(withDuration: 0.5, animations: {
            
            weakSelf?.bgView.frame = CGRect.init(x: (weakSelf?.bgView.frame.origin.x)!, y: (weakSelf?.frame.size.height)!, width: (weakSelf?.bgView.frame.size.width)!, height: (weakSelf?.bgView.frame.size.height)!)
            weakSelf?.backgroundView.alpha = 0
            
        }) { (finished) in
            weakSelf?.removeFromSuperview()
        }
    }
    
    /// 隐藏
    func hide(){
        removeAnimation()
    }
    
    /// 点击bgView不消失
    @objc func onBlankClicked(){
        
    }
    
    /// 点击空白取消
    @objc func onTapCancle(sender:UITapGestureRecognizer){
        
        hide()
    }
    
    /// 取消
    @objc func clickedCancleBtn(){
        hide()
    }
}
