//
//  KZArticleModel.swift
//  kangze
//  文章model
//  Created by gouyz on 2018/9/8.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

@objcMembers
class KZArticleModel: LHSBaseModel {

    /// 文章id
    var article_id : String?
    /// 栏目id
    var ac_id : String?
    /// 外链url（如果这个不为空，点文章标题就跳转到这个链接）
    var article_url : String?
    /// 是否显示
    var article_show : String?
    /// 排序
    var article_sort : String?
    /// 文章标题
    var article_title : String?
    /// 文章内容
    var article_content : String? = ""
    /// 添加时间
    var article_time : String?
    /// //文章列表缩略图的url
    var thumb : String?
}
