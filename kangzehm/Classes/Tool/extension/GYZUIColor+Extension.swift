//
//  GYZUIColor+Extension.swift
//  GYZBaiSi
//  UIColor扩展类
//  Created by gouyz on 2016/11/25.
//  Copyright © 2016年 gouyz. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// RGB的颜色设置
    static func RGBColor(_ r:CGFloat, g:CGFloat, b:CGFloat) -> UIColor {
        return RGBAColor(r, g: g, b: b, a: 1.0)
    }
    /// RGBA的颜色设置
    static func RGBAColor(_ r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    /// 根据16进制值设置颜色
    ///
    /// - parameter valueRGB: 如0xeeeeee
    ///
    /// - returns: 颜色
    static func UIColorFromRGB(valueRGB:UInt) -> UIColor {
        
        let r = CGFloat((valueRGB & 0xFF0000) >> 16)
        let g = CGFloat((valueRGB & 0x00FF00) >> 8)
        let b = CGFloat((valueRGB & 0x0000FF) >> 0)
        
        return RGBColor(r, g: g, b: b)
    }
    
    /**
     16进制转UIColor
     
     - parameter hex: 16进制颜色字符串
     
     - returns: 转换后的颜色
     */
    static func ColorHex( _ hex: String) -> UIColor {
        return ColorHexWithAlpha(hex, alpha: 1.0)
    }
    
    /**
     16进制转UIColor，
     
     - parameter hex:   16进制颜色字符串
     - parameter alpha: 透明度
     
     - returns: 转换后的颜色
     */
    static func ColorHexWithAlpha( _ hex: String, alpha: CGFloat) -> UIColor {
        
        /** 如果传入的字符串为空 */
        if hex.isEmpty {
            return UIColor.clear
        }
        /** 传进来的值。 去掉了可能包含的空格、特殊字符， 并且全部转换为大写 */
        let set = CharacterSet.whitespacesAndNewlines
        var hHex = hex.trimmingCharacters(in: set).uppercased()
        
        /** 如果处理过后的字符串少于6位 */
        if hHex.count < 6 {
            return UIColor.clear
        }
        
        /** 开头是用0x开始的 */
        if hHex.hasPrefix("0x") {
            hHex = (hHex as NSString).substring(from: 2)
        } else if hHex.hasPrefix("#") {/** 开头是以＃开头的 */
            hHex = (hHex as NSString).substring(from: 1)
        } else if hHex.hasPrefix("##") {/** 开头是以＃＃开始的 */
            hHex = (hHex as NSString).substring(from: 2)
        }
        
        /** 截取出来的有效长度是6位， 所以不是6位的直接返回 */
        if hHex.count != 6 {
            return UIColor.clear
        }
        
        /** R G B */
        var range = NSMakeRange(0, 2)
        
        /** R */
        let rHex = (hHex as NSString).substring(with: range)
        
        /** G */
        range.location = 2
        let gHex = (hHex as NSString).substring(with: range)
        
        /** B */
        range.location = 4
        let bHex = (hHex as NSString).substring(with: range)
        
        /** 类型转换 */
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)
        
        return RGBAColor(CGFloat(r), g: CGFloat(g), b: CGFloat(b), a: alpha)
    }
}
