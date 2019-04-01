//
//  KZRechargeRecordModel.swift
//  kangze
//  充值记录
//  Created by gouyz on 2018/9/12.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

@objcMembers
class KZRechargeRecordModel: LHSBaseModel {
    /// 订单id
    var pdr_id : String?
    /// 会员id
    var pdr_member_id : String?
    /// 订单号
    var pdr_sn : String?
    /// 会员名称
    var pdr_member_name : String?
    /// 充值金额
    var pdr_amount : String? = "0"
    /// 充值状态
    var pdr_payment_state : String?
    /// 充值时间 2018-08-28 15:44:17
    var pdr_add_time_text : String?
    /// 充值状态描述
    var pdr_payment_state_text : String?
}
