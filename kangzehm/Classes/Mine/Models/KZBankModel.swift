//
//  KZBankModel.swift
//  kangze
//  银行卡model
//  Created by gouyz on 2018/9/12.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

@objcMembers
class KZBankModel: LHSBaseModel {
    /// id
    var id : String?
    /// 会员id
    var member_id : String?
    /// 银行卡所属银行
    var card_type : String?
    /// 会员名称
    var card_name : String?
    /// 卡号
    var card_num : String?
    /// 银行卡尾号
    var end_num : String?
}
