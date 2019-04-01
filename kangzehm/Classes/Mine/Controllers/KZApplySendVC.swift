//
//  KZApplySendVC.swift
//  kangze
//  申请发货
//  Created by gouyz on 2018/9/5.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON

class KZApplySendVC: GYZBaseVC {
    
    /// 收货地址
    var selectAddressModel: KZMyAddressModel?
    var goodsId: String = ""
    
    var dataModel: KZApplySendModel?
    /// 商品数量
    var totalNum: Int = 1
    // 运费
    var freight: String = "0.00"
    /// 订单编号
    var orderNo: String = ""
    /// 余额
    var yuEMoney: String = "0"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "申请发货"
        self.view.backgroundColor = kWhiteColor
        
        
        setupUI()
        addIconView.addOnClickListener(target: self, action: #selector(didClickAddBtn))
        minusIconView.addOnClickListener(target: self, action: #selector(didClickMinusBtn))
        requestData()
        requestYuEInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 创建UI
    fileprivate func setupUI(){
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(personLab)
        contentView.addSubview(lineView)
        contentView.addSubview(phoneLab)
        bgView.addSubview(lineView1)
        contentView.addSubview(bgView)
        bgView.addSubview(addressLab)
        bgView.addSubview(rightIconView)
        contentView.addSubview(lineView2)
        contentView.addSubview(iconView)
        contentView.addSubview(nameLab)
        contentView.addSubview(kuCunLab)
        contentView.addSubview(unitLab)
        contentView.addSubview(minusIconView)
        contentView.addSubview(countLab)
        contentView.addSubview(addIconView)
        contentView.addSubview(lineView3)
        contentView.addSubview(moneyLab)
        
        view.addSubview(submitBtn)
        
        scrollView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(view)
            make.bottom.equalTo(submitBtn.snp.top)
        }
        submitBtn.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(kBottomTabbarHeight)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.left.width.equalTo(scrollView)
            make.top.equalTo(scrollView)
            make.bottom.equalTo(scrollView)
            // 这个很重要！！！！！！
            // 必须要比scroll的高度大一，这样才能在scroll没有填充满的时候，保持可以拖动
            make.height.greaterThanOrEqualTo(scrollView).offset(1)
        }
        
        personLab.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.height.equalTo(50)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(personLab.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        phoneLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(personLab)
            make.top.equalTo(lineView.snp.bottom)
        }
        lineView1.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(phoneLab.snp.bottom)
        }
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView1.snp.bottom)
            make.left.right.equalTo(contentView)
            make.height.equalTo(personLab)
        }
        addressLab.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(bgView)
            make.left.equalTo(kMargin)
            make.right.equalTo(rightIconView.snp.left).offset(-kMargin)
        }
        rightIconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(bgView)
            make.right.equalTo(-kMargin)
            make.size.equalTo(CGSize.init(width: 7, height: 12))
        }
        lineView2.snp.makeConstraints { (make) in
            make.left.height.right.equalTo(lineView)
            make.top.equalTo(bgView.snp.bottom)
        }
        iconView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView2.snp.bottom).offset(kMargin)
            make.left.equalTo(personLab)
            make.size.equalTo(CGSize.init(width: 90, height: 90))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(kMargin)
            make.top.equalTo(iconView)
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(kuCunLab.snp.top)
        }
        kuCunLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameLab)
            make.height.equalTo(20)
            make.bottom.equalTo(addIconView.snp.top)
        }
        unitLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.right.equalTo(minusIconView.snp.left).offset(-kMargin)
            make.bottom.equalTo(iconView)
            make.height.equalTo(minusIconView)
        }
        addIconView.snp.makeConstraints { (make) in
            make.bottom.equalTo(iconView)
            make.right.equalTo(-kMargin)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        countLab.snp.makeConstraints { (make) in
            make.centerY.height.equalTo(addIconView)
            make.right.equalTo(addIconView.snp.left)
            make.width.equalTo(30)
        }
        minusIconView.snp.makeConstraints { (make) in
            make.centerY.size.equalTo(addIconView)
            make.right.equalTo(countLab.snp.left)
        }
        lineView3.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(lineView)
            make.top.equalTo(iconView.snp.bottom).offset(kMargin)
        }
        moneyLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(personLab)
            make.top.equalTo(lineView3.snp.bottom)
            // 这个很重要，viewContainer中的最后一个控件一定要约束到bottom，并且要小于等于viewContainer的bottom
            // 否则的话，上面的控件会被强制拉伸变形
            // 最后的-10是边距，这个可以随意设置
            make.bottom.lessThanOrEqualTo(contentView).offset(-kMargin)
        }
    }
    
    /// scrollView
    var scrollView: UIScrollView = UIScrollView()
    /// 内容View
    var contentView: UIView = UIView()
    
    /// 收件人
    lazy var personLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "收件人："
        
        return lab
    }()
    lazy var lineView: UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    /// 电话
    lazy var phoneLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "电话："
        
        return lab
    }()
    lazy var lineView1: UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
    lazy var bgView: UIView = {
        let view = UIView()
        view.addOnClickListener(target: self, action: #selector(onClickedSelectAddress))
        
        return view
    }()
    /// 地址
    lazy var addressLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.numberOfLines = 2
        lab.text = "地址："
        
        return lab
    }()
    
    /// 右侧箭头图标
    lazy var rightIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_arrow"))
    
    /// 分割线
    var lineView2 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 商品图标
    lazy var iconView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = kBackgroundColor
        
        return imgView
    }()
    
    /// 商品名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kBlackFontColor
        lab.numberOfLines = 2
        
        return lab
    }()
    /// 库存
    lazy var kuCunLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kBlackFontColor
        lab.text = "现有库存：0"
        
        return lab
    }()
    /// 单位
    lazy var unitLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kGaryFontColor
        
        return lab
    }()
    /// 加
    lazy var addIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_add"))
    
    /// 数量
    lazy var countLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "1"
        lab.textAlignment = .center
        
        return lab
    }()
    
    /// 减
    lazy var minusIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_minus"))
    /// 分割线
    var lineView3 : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    
    /// 运费
    lazy var moneyLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kRedFontColor
        lab.textAlignment = .right
        lab.text = "运费：￥0.00"
        
        return lab
    }()
    
    /// 提交申请
    lazy var submitBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("提交申请", for: .normal)
        btn.addTarget(self, action: #selector(clickedSubmitBtn), for: .touchUpInside)
        
        return btn
    }()
    /// 提交申请
    @objc func clickedSubmitBtn(){
        
        if selectAddressModel == nil {
            MBProgressHUD.showAutoDismissHUD(message: "请选择收货地址")
            return
        }
        requestSendGoods()
//        showPayView()
    }
    /// 选择地址
    @objc func onClickedSelectAddress(){
    
        let vc = KZMyAddressVC()
        vc.isSelected = true
        vc.resultBlock = {[weak self] (model) in
            
            self?.selectAddressModel = model
            self?.requestFreightData()
            self?.setInfo()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setInfo(){
        addressLab.text = "地址：" + (selectAddressModel?.province_name)! + (selectAddressModel?.city_name)! + (selectAddressModel?.area_name)! + (selectAddressModel?.address)!
        personLab.text = "收件人：" + (selectAddressModel?.true_name)!
        phoneLab.text = "电话：" + (selectAddressModel?.mob_phone)!
    }
    
    func showPayView(){
        let payView = KZSelectPayMethodView()
        payView.yuEMoneyLab.text = "可用余额：￥\(yuEMoney)"
        payView.selectPayTypeBlock = { [weak self](index) in
            
            payView.hide()
            self?.dealPay(index: index)
        }
        payView.show()
    }
    /// 支付
    func dealPay(index: Int){
        
        switch index {
        case 1://余额支付
            requestPayData(type: "yck")
        case 2:// 支付宝支付
            requestPayData(type: "alipay_native")
        case 3://微信支付
            requestPayData(type: "wxpay")
        case 4://pos支付
            let vc = KZRechargePosPayVC()
            vc.paySN = orderNo
            vc.isRecharge = false
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    /// 获取支付参数
    func requestPayData(type: String){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("member_payment&op=pay_send", parameters: ["key": userDefaults.string(forKey: "key") ?? "","payment_code":type,"pay_sn":orderNo],method : .get,   success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                if type == "alipay_native"{// 支付宝
                    let payInfo: String = response["datas"]["signStr"].stringValue
                    weakSelf?.goAliPay(orderInfo: payInfo)
                }else if type == "yck"{// 余额支付
                    MBProgressHUD.showAutoDismissHUD(message: "支付成功")
                    weakSelf?.clickedBackBtn()
                }else if type == "wxpay"{// 微信支付
                    weakSelf?.goWeChatPay(data: response["datas"]["prepay_order"])
                }
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /// 微信支付
    func goWeChatPay(data: JSON){
        let req = PayReq()
        req.timeStamp = data["timestamp"].uInt32Value
        req.partnerId = data["partnerid"].stringValue
        req.package = data["package"].stringValue
        req.nonceStr = data["noncestr"].stringValue
        req.sign = data["sign"].stringValue
        req.prepayId = data["prepayid"].stringValue
        
        WXApiManager.shared.payAlertController(self, request: req, paySuccess: { [weak self]  in
            
            self?.clickedBackBtn()
        }) {
            
        }
    }
    /// 支付宝支付
    func goAliPay(orderInfo: String){
        
        AliPayManager.shared.requestAliPay(orderInfo, paySuccess: { [weak self]  in
            
            self?.clickedBackBtn()
            }, payFail: {
        })
    }
    
    /// 获取余额数据
    func requestYuEInfo(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        GYZNetWork.requestNetwork("member_index&op=my_asset&fields=predepoit", parameters: ["key": userDefaults.string(forKey: "key") ?? ""],  success: { (response) in
            
            GYZLog(response)
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.yuEMoney = response["datas"]["predepoit"].stringValue
                
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            GYZLog(error)
        })
    }
    
    ///获取数据
    func requestData(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("my_send&op=apply_send_info",parameters: ["goods_id":goodsId,"key": userDefaults.string(forKey: "key") ?? ""],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["datas"].dictionaryObject else { return }
                weakSelf?.dataModel = KZApplySendModel.init(dict: data)
                weakSelf?.setData()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    func setData(){
        if dataModel?.addressList != nil && dataModel?.addressList?.count > 0 {
            selectAddressModel = dataModel?.addressList![0]
            setInfo()
        }
        iconView.kf.setImage(with: URL.init(string: (dataModel?.goodsInfo?.image_url)!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        nameLab.text = dataModel?.goodsInfo?.goods_name
        kuCunLab.text = "现有库存：" + (dataModel?.stock)!
        unitLab.text = (dataModel?.goodsInfo?.unit?.isEmpty)! ? "" : "单位：\((dataModel?.goodsInfo?.unit)!)"
        
        freight = (dataModel?.freight)!
        moneyLab.text = "运费：￥" + freight
    }
    /// 加号
    @objc func didClickAddBtn(){
        if selectAddressModel == nil {
            MBProgressHUD.showAutoDismissHUD(message: "请选择收货地址")
            return
        }
        if totalNum == Int((dataModel?.stock)!) {
            MBProgressHUD.showAutoDismissHUD(message: "库存不足")
            return
        }
        totalNum += 1
        modifyNumber()
    }
    
    /// 减号
    @objc func didClickMinusBtn(){
        if selectAddressModel == nil {
            MBProgressHUD.showAutoDismissHUD(message: "请选择收货地址")
            return
        }
        
        if totalNum == 1 {
            MBProgressHUD.showAutoDismissHUD(message: "最少发货数量为1")
            return
        }
        totalNum -= 1
        modifyNumber()
    }
    
    
    func modifyNumber(){
        countLab.text = "\(totalNum)"
        requestFreightData()
    }
    
    ///获取运费数据
    func requestFreightData(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("my_send&op=get_freight",parameters: ["goods_id":goodsId,"key": userDefaults.string(forKey: "key") ?? "","goods_num":"\(totalNum)","address_id": (selectAddressModel?.address_id)!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.freight = response["datas"]["freight"].stringValue
                weakSelf?.moneyLab.text = "运费：￥" + (weakSelf?.freight)!
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    ///申请发货
    func requestSendGoods(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("my_send&op=apply_send",parameters: ["goods_id":goodsId,"key": userDefaults.string(forKey: "key") ?? "","goods_num":"\(totalNum)","address_id": (selectAddressModel?.address_id)!,"freight":freight],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.orderNo = response["datas"]["sendSn"].stringValue
                
                weakSelf?.showPayView()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
}
