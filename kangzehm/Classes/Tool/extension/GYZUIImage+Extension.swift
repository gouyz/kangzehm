//
//  GYZUIImage+Extension.swift
//  LazyHuiSellers
//  图片扩展
//  Created by gouyz on 2016/12/15.
//  Copyright © 2016年 gouyz. All rights reserved.
//

import UIKit
import CoreImage


extension UIImage
{
    /**
     1.识别图片二维码
     
     - returns: 二维码内容
     */
    func recognizeQRCode() -> String?
    {
        
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy : CIDetectorAccuracyHigh])
        let features = detector?.features(in: CoreImage.CIImage(cgImage: self.cgImage!))
        guard (features?.count)! > 0 else { return nil }
        let feature = features?.first as? CIQRCodeFeature
        return feature?.messageString
        
    }
    
    //2.获取圆角图片
    func getRoundRectImage(size:CGFloat,radius:CGFloat) -> UIImage
    {
        
        return getRoundRectImage(size: size, radius: radius, borderWidth: nil, borderColor: nil)
        
    }
    
    //3.获取圆角图片(带边框)
    func getRoundRectImage(size:CGFloat,radius:CGFloat,borderWidth:CGFloat?,borderColor:UIColor?) -> UIImage
    {
        let scale = self.size.width / size ;
        
        //初始值
        var defaultBorderWidth : CGFloat = 0
        var defaultBorderColor = UIColor.clear
        
        if let borderWidth = borderWidth { defaultBorderWidth = borderWidth * scale }
        if let borderColor = borderColor { defaultBorderColor = borderColor }
        
        let radius = radius * scale
        let react = CGRect(x: defaultBorderWidth, y: defaultBorderWidth, width: self.size.width - 2 * defaultBorderWidth, height: self.size.height - 2 * defaultBorderWidth)
        
        //绘制图片设置
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        
        let path = UIBezierPath(roundedRect:react , cornerRadius: radius)
        
        //绘制边框
        path.lineWidth = defaultBorderWidth
        defaultBorderColor.setStroke()
        path.stroke()
        
        path.addClip()
        
        //画图片
        draw(in: react)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!;
        
    }
    
    
    /// 图片压缩
    ///
    /// - Parameter newSize: 大小
    /// - Returns: 图片
    func scaleImgToSize(newSize:CGSize) -> UIImage{
        // Create a graphics image context
        UIGraphicsBeginImageContext(newSize)
        // Tell the old image to draw in this new context, with the desired
        // new size
        self.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        // Get the new image from the context
        let newImg: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        // End the context
        UIGraphicsEndImageContext()
        return newImg
    }
}
