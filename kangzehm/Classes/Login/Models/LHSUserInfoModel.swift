//
//  LHSUserInfoModel.swift
//  LazyHuiService
//  用户信息model
//  Created by gouyz on 2017/6/21.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

@objcMembers
class LHSUserInfoModel: LHSBaseModel,NSCoding {
    /// 用户id
    var id : String?
    ///
    var isDel : String?
    /// 用户编号 'SN'+yyMMdd+6位随机数
    var dealerNumber : String?
    /// 姓名
    var dealerName : String? = ""
    /// 是否服务中心0否1是（审核通过时修改该字段）
    var isServerCenter : String?
    /// 电话
    var dealerMobile : String?
    /// 状态 1正常0注销
    var dealerStatus : String?
    /// 推荐码 生成规则：6位16进制数，
    var dealerPromoCode : String?
    /// 身份证
    var dealerIdcards : String?
    /// 省
    var dealerProvince : String?
    /// 市
    var dealerCity : String?
    /// 区
    var dealerArea : String?
    /// 邮政编码
    var dealerPostcode : String?
    /// 地址
    var dealerAddress : String?
    /// 级别 0游客1小纯纯2纯纯3纯大大
    var dealerLevel : String?
    /// 销售额
    var dealerSaleTotals : String?
    /// 充值总额
    var dealerRechargeTotals : String?
    /// 盈利
    var dealerProfitTotals : String?
    /// 积分余额
    var dealerCoinBalance : String?
    /// 开户行
    var dealerBank: String?
    /// 银行卡号
    var dealerBankaccount : String?
    /// 所属服务中心
    var dealerScid : String?
    /// 推荐经销商
    var dealerPromoDealer : String?
    /// 佣金总额
    var dealerCommissionTotals : String? = "0"
    /// 佣金余额
    var dealerCommissionBalance : String? = "0"
    /// 加入时间 2018-06-12 17:24:57
    var dealerJoinTime : String?
    /// 充值次数
    var dealerRechargeTimes : String?
    
    override init(dict: [String : Any]) {
        super.init(dict: dict)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        id = aDecoder.decodeObject(forKey: "id") as? String ?? ""
        isDel = aDecoder.decodeObject(forKey: "isDel") as? String ?? ""
        dealerNumber = aDecoder.decodeObject(forKey: "dealerNumber") as? String ?? ""
        dealerName = aDecoder.decodeObject(forKey: "dealerName") as? String ?? ""
        isServerCenter = aDecoder.decodeObject(forKey: "isServerCenter") as? String ?? ""
        dealerMobile = aDecoder.decodeObject(forKey: "dealerMobile") as? String ?? ""
        dealerStatus = aDecoder.decodeObject(forKey: "dealerStatus") as? String ?? ""
        dealerPromoCode = aDecoder.decodeObject(forKey: "dealerPromoCode") as? String ?? ""
        dealerIdcards = aDecoder.decodeObject(forKey: "dealerIdcards") as? String ?? ""
        dealerProvince = aDecoder.decodeObject(forKey: "dealerProvince") as? String ?? ""
        dealerCity = aDecoder.decodeObject(forKey: "dealerCity") as? String ?? ""
        dealerArea = aDecoder.decodeObject(forKey: "dealerArea") as? String ?? ""
        dealerPostcode = aDecoder.decodeObject(forKey: "dealerPostcode") as? String ?? ""
        dealerAddress = aDecoder.decodeObject(forKey: "dealerAddress") as? String ?? ""
        dealerLevel = aDecoder.decodeObject(forKey: "dealerLevel") as? String ?? ""
        dealerSaleTotals = aDecoder.decodeObject(forKey: "dealerSaleTotals") as? String ?? ""
        dealerRechargeTotals = aDecoder.decodeObject(forKey: "dealerRechargeTotals") as? String ?? ""
        dealerProfitTotals = aDecoder.decodeObject(forKey: "dealerProfitTotals") as? String ?? ""
        dealerCoinBalance = aDecoder.decodeObject(forKey: "dealerCoinBalance") as? String ?? ""
        
        dealerBank = aDecoder.decodeObject(forKey: "dealerBank") as? String ?? ""
        dealerBankaccount = aDecoder.decodeObject(forKey: "dealerBankaccount") as? String ?? ""
        dealerScid = aDecoder.decodeObject(forKey: "dealerScid") as? String ?? ""
        dealerPromoDealer = aDecoder.decodeObject(forKey: "dealerPromoDealer") as? String ?? ""
        dealerCommissionTotals = aDecoder.decodeObject(forKey: "dealerCommissionTotals") as? String ?? ""
        dealerCommissionBalance = aDecoder.decodeObject(forKey: "dealerCommissionBalance") as? String ?? ""
        dealerJoinTime = aDecoder.decodeObject(forKey: "dealerJoinTime") as? String ?? ""
        dealerRechargeTimes = aDecoder.decodeObject(forKey: "dealerRechargeTimes") as? String ?? ""
        
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey:"id")
        aCoder.encode(isDel, forKey:"isDel")
        aCoder.encode(dealerNumber, forKey:"dealerNumber")
        aCoder.encode(dealerName, forKey:"dealerName")
        aCoder.encode(isServerCenter, forKey:"isServerCenter")
        aCoder.encode(dealerMobile, forKey:"dealerMobile")
        aCoder.encode(dealerStatus, forKey:"dealerStatus")
        aCoder.encode(dealerPromoCode, forKey:"dealerPromoCode")
        aCoder.encode(dealerIdcards, forKey:"dealerIdcards")
        aCoder.encode(dealerProvince, forKey:"dealerProvince")
        aCoder.encode(dealerCity, forKey:"dealerCity")
        aCoder.encode(dealerArea, forKey:"dealerArea")
        aCoder.encode(dealerPostcode, forKey:"dealerPostcode")
        aCoder.encode(dealerAddress, forKey:"dealerAddress")
        aCoder.encode(dealerLevel, forKey:"dealerLevel")
        aCoder.encode(dealerSaleTotals, forKey:"dealerSaleTotals")
        aCoder.encode(dealerRechargeTotals, forKey:"dealerRechargeTotals")
        aCoder.encode(dealerProfitTotals, forKey:"dealerProfitTotals")
        aCoder.encode(dealerCoinBalance, forKey:"dealerCoinBalance")
        
        aCoder.encode(dealerBank, forKey:"dealerBank")
        aCoder.encode(dealerBankaccount, forKey:"dealerBankaccount")
        aCoder.encode(dealerScid, forKey:"dealerScid")
        aCoder.encode(dealerPromoDealer, forKey:"dealerPromoDealer")
        aCoder.encode(dealerCommissionTotals, forKey:"dealerCommissionTotals")
        aCoder.encode(dealerCommissionBalance, forKey:"dealerCommissionBalance")
        aCoder.encode(dealerJoinTime, forKey:"dealerJoinTime")
        aCoder.encode(dealerRechargeTimes, forKey:"dealerRechargeTimes")
        
    }
}
