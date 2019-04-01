//
//  KZMessageModel.swift
//  kangze
//  消息model
//  Created by gouyz on 2018/9/27.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit


@objcMembers
class KZMessageModel: LHSBaseModel {
    /// id
    var article_id : String?
    /// 外链url（如果这个不为空，点文章标题就跳转到这个链接）
    var article_url : String?
    /// 文章标题
    var article_title : String? = ""
    /// 文章内容
    var article_content : String? = ""
    /// 添加时间
    var article_time : String? = ""
    /// 0未读/1已读  状态
    var read_status : String? = "0"
}
