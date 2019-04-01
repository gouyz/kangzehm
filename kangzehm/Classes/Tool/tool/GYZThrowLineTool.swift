//
//  GYZThrowLineTool.swift
//  LazyHuiService
//  view 抛物线
//  Created by gouyz on 2017/7/11.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class GYZThrowLineTool: NSObject,CAAnimationDelegate {

    static let throwlineTools = GYZThrowLineTool()
    private override init() {}
    
    var showingView: UIView?
    weak var delegate: GYZThrowLineToolDelegate?
    
    /// 将某个view或者layer从起点抛到终点
    ///
    /// - Parameters:
    ///   - view: 被抛的物体
    ///   - from: 起点坐标
    ///   - to: 终点坐标
    func throwObject(view: UIView,from: CGPoint,to: CGPoint){
        showingView = view
        let path = UIBezierPath()
        path.move(to: CGPoint.init(x: from.x, y: from.y))
        //三点曲线
        path.addCurve(to: CGPoint.init(x: to.x + 25, y: to.y + 25), controlPoint1: CGPoint.init(x: from.x, y: from.y), controlPoint2: CGPoint.init(x: from.x - 180, y: from.y - 200))
        
        groupAnimation(path: path)
    }
    
    ///组合动画
    fileprivate func groupAnimation(path: UIBezierPath){
        
        let animation = CAKeyframeAnimation.init(keyPath: "position")
        animation.path = path.cgPath
        animation.rotationMode = kCAAnimationRotateAuto
        
        let alphaAnimation = CABasicAnimation.init(keyPath: "alpha")
        alphaAnimation.duration = 0.8
        alphaAnimation.fromValue = NSNumber.init(value: 1.0)
        alphaAnimation.toValue = NSNumber.init(value: 0.1)
        alphaAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)
        
        let groups = CAAnimationGroup()
        groups.animations = [animation,alphaAnimation]
        groups.duration = 0.5
        groups.isRemovedOnCompletion = false
        groups.fillMode = kCAFillModeForwards
        groups.delegate = self
        groups.setValue("groupsAnimation", forKey: "animationName")
        
        showingView?.layer.add(groups, forKey: "position scale")
    }
    
    ///Mark CAAnimationDelegate
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        delegate?.animationDidFinish()
        showingView = nil
    }
}

protocol GYZThrowLineToolDelegate: NSObjectProtocol {
    
    /// 抛物线结束的回调
    func animationDidFinish()
}
