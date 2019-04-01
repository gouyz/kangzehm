//
//  PWServiceCenterModel.swift
//  pureworks
//  服务中心model
//  Created by gouyz on 2018/6/12.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

@objcMembers
class PWServiceCenterModel: LHSBaseModel {

    /// 服务中心id
    var id : String?
    /// 服务中心编号
    var centerNumber : String?
    /// 经销商编号
    var dealerNumber : String?
    /// 服务中心名称
    var centerName : String?
    /// 省
    var centerProvince : String?
    /// 市
    var centerCity : String?
    /// 区
    var centerArea : String?
    /// 地址
    var centerAddress : String?
    /// 统一社会信用代码
    var centerUscc : String?
    /// 营业执照（图片url）
    var centerLicence : String?
    /// 店铺照片（多张分号隔开）
    var centerPhotos : String?
    /// 审核状态 1审核通过0待审核2退回修改中
    var approveStatus : String?
    /// 申请时间
    var applyTime : String?
    /// 审核人
    var approvePerson : String?
    /// 审核通过时间
    var approveTime : String?
    /// 未通过原因
    var noApproveReason : String?
    /// 是否删除
    var isDel : String?
    /// 归属销售额
    var belongSaleTotals : String?
    /// 服务中心状态 0关闭 1正常
    var centerStatus : String?
    /// 关闭原因
    var closeReason : String?
}
