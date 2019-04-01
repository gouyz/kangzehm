//
//  GYZDate+Extension.swift
//  flowers
//  date 扩展
//  Created by gouyz on 2016/11/8.
//  Copyright © 2016年 gouyz. All rights reserved.
//

import UIKit

extension Date
{
    // 分类中可以直接添加计算型属性, 因为他不需要分配存储空间
    var dateDesc : String{
        let formatter = DateFormatter()
        var formatterStr : String?
        let calendar = Calendar.current
        if calendar.isDateInToday(self){
            let seconds = (Int)(Date().timeIntervalSince(self))
            if seconds < 60{
                return "刚刚"
            }else if seconds < 60 * 60{
                return "\(seconds/60)分钟前"
            }else{
                return "\(seconds/60/60)小时前"
            }
        }else if calendar.isDateInYesterday(self){
            // 昨天: 昨天 17:xx
            formatterStr = "昨天 HH:mm"
        }else{
            
            // 很多年前: 2014-12-14 17:xx
            // 如果枚举可以选择多个, 就用数组[]包起来, 如果为空, 就直接一个空数组
            let components = calendar.dateComponents([Calendar.Component.year], from: self, to: Date())
            // 今年: 03-15 17:xx
            if components.year! < 1
            {
                formatterStr = "MM-dd HH:mm"
            }else{
                formatterStr = "yyyy-MM-dd HH:mm"
            }
        }
        formatter.dateFormat = formatterStr
        
        return formatter.string(from: self)
    }
    
    /// 将日期按yyyy-MM-dd HH:mm:ss某种格式字符串输出
    ///
    /// - parameter format: yyyy-MM-dd HH:mm:ss某种格式
    ///
    /// - returns: 按格式返回时间字符串
    func dateToStringWithFormat(format : String) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
}
