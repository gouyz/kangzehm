//
//  KZSubmitOrderVC.swift
//  kangze
//  提交订单
//  Created by gouyz on 2018/9/4.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON

private let submitOrderCell = "submitOrderCell"
private let submitOrderNoteCell = "submitOrderNoteCell"
private let submitOrderFooterView = "submitOrderFooterView"

class KZSubmitOrderVC: GYZBaseVC {
    
    var dataModel: KZSubmitOrderModel?
    /// 会员预存款余额
    var memberMoney: String = "0"
    /// 是否是购物车过来的
    var isCart: String = "0"
    /// 购物信息（商品/购物车id|购买数量）
    var cartIds: String = ""
    /// 商品总数
    var totalNum: Int = 0
    /// 备注
    var noteText: String = ""
    
    //不知道干嘛，但是要带上
    var offpayHash: String = ""
    var offpayHashBatch: String = ""
    var vatHash: String = ""
    /// 区域关联id
    var areaListId: String = ""
    /// 支付编号
    var paySN: String = ""
    
    /// 立即购买时，合伙人套餐要传地址
    var selectProvinceModel: KZAreasModel?
    var selectCityModel: KZAreasModel?
    var selectAreaModel: KZAreasModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "提交订单"
        self.view.backgroundColor = kWhiteColor
        
        view.addSubview(submitBtn)
        view.addSubview(tableView)
        
        submitBtn.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(kBottomTabbarHeight)
        }
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(submitBtn.snp.top)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view)
            }else{
                make.top.equalTo(kTitleAndStateHeight)
            }
        }
        
        requestOrderInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.dataSource = self
        table.delegate = self
        table.separatorColor = kGrayLineColor
        
        table.register(KZOrderCell.self, forCellReuseIdentifier: submitOrderCell)
        table.register(GYZLabAndFieldCell.self, forCellReuseIdentifier: submitOrderNoteCell)
        table.register(KZSubmitOrderFooterView.self, forHeaderFooterViewReuseIdentifier: submitOrderFooterView)
        
        return table
    }()
    
    /// 提交订单
    lazy var submitBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("提交订单", for: .normal)
        btn.addTarget(self, action: #selector(clickedSubmitBtn), for: .touchUpInside)
        
        return btn
    }()
    /// 提交订单
    @objc func clickedSubmitBtn(){
        requestSubmitOrder()
//        showPayView()
    }
    
    func showPayView(){
        let payView = KZSelectPayMethodView()
        payView.yuEMoneyLab.text = "可用余额：￥\(memberMoney)"
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
            let vc = KZPosPayVC()
            vc.paySN = paySN
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    /// 获取确认订单数据
    func requestOrderInfo(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        var dic: [String: String] = ["key": userDefaults.string(forKey: "key") ?? "","cart_id":cartIds,"ifcart":isCart]
        
        if selectProvinceModel != nil {
            dic["provinceid"] = selectProvinceModel?.area_id!
            dic["cityid"] = selectCityModel?.area_id!
            dic["areaid"] = selectAreaModel?.area_id!
        }else{
            dic["provinceid"] = ""
            dic["cityid"] = ""
            dic["areaid"] = ""
        }
        
        GYZNetWork.requestNetwork("member_buy&op=buy_step1", parameters: dic,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            if response["code"].intValue == kQuestSuccessTag{//请求成功
            
                weakSelf?.memberMoney = response["datas"]["available_predeposit"].stringValue
                weakSelf?.vatHash = response["datas"]["vat_hash"].stringValue
                weakSelf?.areaListId = response["datas"]["area_list"].stringValue
                weakSelf?.offpayHash = response["datas"]["address_api"]["offpay_hash"].stringValue
                weakSelf?.offpayHashBatch = response["datas"]["address_api"]["offpay_hash_batch"].stringValue
                
                guard let data = response["datas"]["store_cart_list"]["1"].dictionaryObject else { return }
                weakSelf?.dataModel = KZSubmitOrderModel.init(dict: data)
                
                weakSelf?.tableView.reloadData()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    ///提交订单
    func requestSubmitOrder(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("member_buy&op=buy_step2",parameters: ["vat_hash":vatHash,"offpay_hash":offpayHash,"offpay_hash_batch":offpayHashBatch,"key": userDefaults.string(forKey: "key") ?? "","cart_id":cartIds,"ifcart":isCart,"pay_name":" online","pay_message":"1|" + noteText,"area_list":areaListId ],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                weakSelf?.paySN = response["datas"]["pay_sn"].stringValue

                weakSelf?.showPayView()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /// 获取支付参数
    func requestPayData(type: String){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("member_payment&op=pay_new", parameters: ["key": userDefaults.string(forKey: "key") ?? "","payment_code":type,"pay_sn":paySN],method : .get,   success: { (response) in
            
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
    /// 输入框内容改变
    @objc func textFieldTextChange(textField: UITextField){
        noteText = textField.text!
    }
}
extension KZSubmitOrderVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        if dataModel != nil {
            return (dataModel?.goodList?.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: submitOrderCell) as! KZOrderCell
            
            cell.contentView.backgroundColor = kWhiteColor
            let model = dataModel?.goodList![indexPath.row]
            cell.dataModel = model
            
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: submitOrderNoteCell) as! GYZLabAndFieldCell
            
            cell.titleLab.text = "备注"
            cell.textFiled.addTarget(self, action: #selector(textFieldTextChange(textField:)), for: .editingChanged)
            
            cell.selectionStyle = .none
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 0 {
            let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: submitOrderFooterView) as! KZSubmitOrderFooterView
            
            if dataModel != nil{
                footerView.totalLab.text = "合计：￥" + String(format:"%.2f",Double((dataModel?.store_goods_total)!)!)
            }
            
            return footerView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        goGoodsDetail()
    }
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 100
        }
        return 50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kMargin
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return kTitleHeight
        }
        return 0.00001
    }
}

//extension KZSubmitOrderVC : UITextFieldDelegate{
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        noteText = textField.text!
//        return true
//    }
//}

