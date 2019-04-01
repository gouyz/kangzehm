//
//  KZYuERecordModel.swift
//  kangze
//  余额明细
//  Created by gouyz on 2018/9/12.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

@objcMembers
class KZYuERecordModel: LHSBaseModel {
    /// id
    var lg_id : String?
    /// 时间戳
    var lg_add_time : String?
    /// 订单号
    var sn : String?
    /// 余额加或减的数目 -2.00
    var lg_av_amount : String?
    /// 明细类型
    var type : String?
    /// 当前用户余额
    var lg_cur_amount : String? = ""
}
