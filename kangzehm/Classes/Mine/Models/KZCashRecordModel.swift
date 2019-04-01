//
//  KZCashRecordModel.swift
//  kangze
//  提现记录
//  Created by gouyz on 2018/9/12.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

@objcMembers
class KZCashRecordModel: LHSBaseModel {
    /// 提现记录的id
    var pdc_id : String?
    /// 会员id
    var pdc_member_id : String?
    /// 提现单号
    var pdc_sn : String?
    /// 会员名称
    var pdc_member_name : String?
    /// 提现金额
    var pdc_amount : String? = "0"
    /// 提现的银行卡所属银行
    var pdc_bank_name : String?
    /// 银行卡卡号
    var pdc_bank_no : String?
    /// 银行卡开户姓名
    var pdc_bank_user : String?
    /// 银行卡开户人姓名
    var mobilenum : String?
    /// 申请提现时间 时间戳
    var pdc_add_time : String?
    /// 打款时间
    var pdc_payment_time : String?
    /// 提现状态0未打款 1已打款 2已拒绝
    var pdc_payment_state : String?
    /// 提现处理人
    var pdc_payment_admin : String?
    /// 提现状态
    var pdc_payment_state_text : String?
}
