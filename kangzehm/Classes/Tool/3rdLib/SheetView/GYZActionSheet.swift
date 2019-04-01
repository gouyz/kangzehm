//
//  GYZActionSheet.swift
//  GYZActionSheet
//  ActionSheet视图
//  Created by gouyz on 2016/12/23.
//  Copyright © 2016年 gouyz. All rights reserved.
//

import UIKit

enum GYZSheetStyle : Int {
    ///默认样式
    case Default = 0
    ///像微信样式
    case WeiChat
    ///TableView样式(无取消按钮)
    case Table
}

///协议
@objc protocol GYZActionSheetDelegate :NSObjectProtocol {
    
    ///传递index和title,以及actionSheet即GYZActionSheet,可用tag等属性区别不同的GYZActionSheet
    @objc optional func sheetViewDidSelect(index : Int,title : String,actionSheet : GYZActionSheet)
    /// 多选代理
    @objc optional func sheetViewDidMultSelect(indexs : [Int],titles : [String],actionSheet : GYZActionSheet)
}

class GYZActionSheet: UIView {
    
    /// 闭包，等同代理
    var didSelectIndex : ((Int,String) -> ())?
    /// 多选闭包
    var didMultSelectIndex : (([Int],[String]) -> ())?
    ///设置代理
    weak var delegate : GYZActionSheetDelegate?
    /// 多选索引
    var selectedIndexs = [Int]()
    
    /// contentView高度
    var contentVH : CGFloat = 0
    /// contentView的y值
    var contentViewY : CGFloat = 0
    /// 取消按钮的y值 默认为Default样式
    var footBtnY : CGFloat = kScreenHeight - kCellH - kSheetMargin
    
    ///标题文字字体
    var titleTextFont : UIFont?{
        didSet{
            if let txtFont = titleTextFont {
                titleView.font = txtFont
            }
        }
    }
    ///标题颜色,默认是darkGrayColor
    var titleTextColor : UIColor = UIColor.darkGray{
        didSet{
            titleView.textColor = titleTextColor
        }
    }
    ///item文字字体
    var itemTextFont : UIFont?{
        didSet{
            if let txtFont = itemTextFont {
                sheetView.cellTextFont = txtFont
            }
        }
    }
    ///item字体颜色,默认是blueColor
    var itemTextColor : UIColor = UIColor.blue{
        didSet{
            sheetView.cellTextColor = itemTextColor
        }
    }
    ///取消字体颜色,默认是blueColor
    var cancleTextColor : UIColor = UIColor.blue{
        didSet{
            footerBtn.setTitleColor(cancleTextColor, for: .normal)
        }
    }
    ///取消文字字体
    var cancleTextFont : UIFont?{
        didSet{
            if let txtFont = cancleTextFont {
                footerBtn.titleLabel?.font = txtFont
            }
        }
    }
    ///取消按钮文字设置,默认是"取消"
    var cancleTitle : String = "取消"{
        didSet{
            footerBtn.setTitle(cancleTitle, for: .normal)
        }
    }
    
    /// title数据源
    fileprivate var dataSource : [String]?
    /// sheetView 类型
    fileprivate var sheetStyle : GYZSheetStyle?
    /// 是否支持多选
    fileprivate var isMultSelected: Bool = false
    
    init(title: String,style: GYZSheetStyle,itemTitles: [String],isMult: Bool = false){
        super.init(frame: UIScreen.main.bounds)
        
        sheetStyle = style
        dataSource = itemTitles
        isMultSelected = isMult
        KeyWindow.addSubview(self)
        
        addSubview(bgButton)
        addSubview(contentView)
        addSubview(footerBtn)
        contentView.addSubview(sheetView)
        
        switch sheetStyle! {
        case .Default:
            setupDefaultStyle(title: title)
            pushDefaultStyeSheetView()
        case .WeiChat:
            setupWeiChatStyle(title: title)
            pushWeiChatStyeSheetView()
        case .Table:
            setupTableStyle(title: title)
            pushTableStyeSheetView()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 背景view
    fileprivate lazy var bgButton : UIButton = {
        let btn = UIButton.init(frame: self.frame)
        btn.backgroundColor = UIColor.black
        btn.alpha = 0.35
        btn.addTarget(self, action: #selector(dismissSheetView), for: .touchUpInside)
        
        return btn
    }()
    /// title和sheetView的容器View
    fileprivate lazy var contentView : UIView = UIView()
    /// 取消按钮
    fileprivate lazy var footerBtn : UIButton = {
        let btn = UIButton.init(frame: CGRect.zero)
        btn.backgroundColor = UIColor.white
        btn.setTitle(self.cancleTitle, for: .normal)
        btn.titleLabel?.font = k18Font
        btn.setTitleColor(self.cancleTextColor, for: .normal)
        btn.addTarget(self, action: #selector(dismissSheetView), for: .touchUpInside)
        
        return btn
    }()
    
    /// header取消按钮
    fileprivate lazy var headerCancleBtn : UIButton = {
        let btn = UIButton.init(frame: CGRect.zero)
        btn.backgroundColor = UIColor.white
        btn.setTitle("取消", for: .normal)
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(self.cancleTextColor, for: .normal)
        btn.addTarget(self, action: #selector(dismissSheetView), for: .touchUpInside)
        
        return btn
    }()
    /// 标题view
    fileprivate lazy var titleView : UILabel = {
        let lab = UILabel()
        lab.font = k18Font
        lab.textColor = UIColor.darkGray
        lab.backgroundColor = UIColor.white
        lab.textAlignment = .center
        
        return lab
    }()
    /// header 确定按钮
    fileprivate lazy var headerOkBtn : UIButton = {
        let btn = UIButton.init(frame: CGRect.zero)
        btn.backgroundColor = UIColor.white
        btn.setTitle("确定", for: .normal)
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(self.cancleTextColor, for: .normal)
        btn.addTarget(self, action: #selector(onClickedOkBtn), for: .touchUpInside)
        
        return btn
    }()
    /// sheetView
    fileprivate lazy var sheetView : GYZSheetView = {
        let sheet = GYZSheetView.init(frame: CGRect.zero)
        sheet.delegate = self
        sheet.dataSource = self.dataSource!
        
        return sheet
    }()
    /// 中间空隙
    fileprivate lazy var marginView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.RGBColor(230, g: 230, b: 230)
        view.alpha = 0
        
        return view
    }()
    
    /// 默认样式
    fileprivate func setupDefaultStyle(title: String){
        
        var titleCount = 0
        if !title.isEmpty {
            titleView.frame = CGRect.init(x: 0, y: 0, width: kSheetViewWidth, height: kCellH)
            titleView.text = title
            contentView.addSubview(titleView)
            titleCount = 1
        }
        
        ///contentView高度
        contentVH = kCellH * CGFloat((dataSource!.count + titleCount))
        if contentVH > kSheetViewMaxH {
            contentVH = kSheetViewMaxH
            sheetView.tableView.isScrollEnabled = true
        } else {
            sheetView.tableView.isScrollEnabled = false
        }
        
        footerBtn.frame = CGRect.init(x: kSheetMargin, y: kScreenHeight + contentVH + kSheetMargin, width: kSheetViewWidth, height: kCellH)
        contentViewY = kScreenHeight - footerBtn.height - contentVH - kSheetMargin * 2
        contentView.frame = CGRect.init(x: footerBtn.x, y: kScreenHeight, width: kSheetViewWidth, height: contentVH)
        
        var sheetY : CGFloat = 0
        var sheetHeight = contentView.height
        if titleCount == 1 {
            sheetY = titleView.bottomY
            sheetHeight -= titleView.height
        }
        sheetView.frame = CGRect.init(x: 0, y: sheetY, width: contentView.width, height: sheetHeight)
        
        contentView.cornerRadius = kCornerRadius
        footerBtn.cornerRadius = kCornerRadius
    }
    ///初始化微信样式
    fileprivate func setupWeiChatStyle(title: String){
        
        var titleCount = 0
        if !title.isEmpty {
            titleView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kCellH)
            titleView.text = title
            contentView.addSubview(titleView)
            titleCount = 1
        }
        ///contentView高度
        contentVH = kCellH * CGFloat((dataSource!.count + titleCount))
        if contentVH > kSheetViewMaxH {
            contentVH = kSheetViewMaxH
            sheetView.tableView.isScrollEnabled = true
        } else {
            sheetView.tableView.isScrollEnabled = false
        }
        
        footBtnY += kSheetMargin
        footerBtn.frame = CGRect.init(x: 0, y: footBtnY + contentVH, width: kScreenWidth, height: kCellH)
        footerBtn.setTitleColor(UIColor.black, for: .normal)
        contentViewY = kScreenHeight - footerBtn.height - contentVH - kSheetMargin
        contentView.frame = CGRect.init(x: footerBtn.x, y: kScreenHeight, width: kScreenWidth, height: contentVH)
        
        var sheetY : CGFloat = 0
        var sheetHeight = contentView.height
        if titleCount == 1 {
            sheetY = titleView.bottomY
            sheetHeight -= titleView.height
        }
        sheetView.frame = CGRect.init(x: contentView.x, y: sheetY, width: contentView.width, height: sheetHeight)
        marginView.frame = CGRect.init(x: 0, y: kScreenHeight + sheetHeight, width: kScreenWidth, height: kSheetMargin)
        self.addSubview(marginView)
    }
    ///初始化TableView样式
    fileprivate func setupTableStyle(title: String){
        
        footerBtn.removeFromSuperview()
        
        var titleCount = 0
        if !title.isEmpty {
            titleView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kCellH)
            titleView.text = title
            contentView.addSubview(titleView)
            titleCount = 1
        }
        
        ///支持多选
        if isMultSelected {
            headerCancleBtn.frame = CGRect.init(x: 0, y: 0, width: kCellH, height: kCellH)
            contentView.addSubview(headerCancleBtn)
            
            headerOkBtn.frame = CGRect.init(x: kScreenWidth - kCellH, y: 0, width: kCellH, height: kCellH)
            contentView.addSubview(headerOkBtn)
        }
        
        ///contentView高度
        contentVH = kCellH * CGFloat((dataSource!.count + titleCount))
        if contentVH > kSheetViewMaxH {
            contentVH = kSheetViewMaxH
        }
        
        sheetView.cellTextStyle = .Left
        sheetView.cellTextColor = UIColor.black
        sheetView.showDivLine = true
        sheetView.tableView.isScrollEnabled = true
        //设置单元格多选
        sheetView.tableView.allowsMultipleSelection = isMultSelected
        
        contentViewY = kScreenHeight - contentVH
        contentView.frame = CGRect.init(x: 0, y: kScreenHeight, width: kScreenWidth, height: contentVH)
        
        var sheetY : CGFloat = 0
        var sheetHeight = contentView.height
        if titleCount == 1 {
            sheetY = titleView.bottomY
            sheetHeight -= titleView.height
        }
        sheetView.frame = CGRect.init(x: contentView.x, y: sheetY, width: contentView.width, height: sheetHeight)
    }
    
    /// 设置多次选择
    func setMultSelectIndexs(indexs: [Int]){
        selectedIndexs = indexs
        sheetView.selectedIndexs = indexs
        sheetView.tableView.reloadData()
    }
    
    /// 显示默认样式
    fileprivate func pushDefaultStyeSheetView(){
        weak var weakSelf = self
        UIView.animate(withDuration: kPushTime, animations:{
            weakSelf?.contentView.frame = CGRect.init(x: kSheetMargin, y: (weakSelf?.contentViewY)!, width: kSheetViewWidth, height: (weakSelf?.contentVH)!)
            weakSelf?.footerBtn.frame = CGRect.init(x: kSheetMargin, y: (weakSelf?.footBtnY)!, width: kSheetViewWidth, height: kCellH)
            weakSelf?.bgButton.alpha = 0.35
        })
    }
    ///显示像微信的样式
    fileprivate func pushWeiChatStyeSheetView(){
        weak var weakSelf = self
        UIView.animate(withDuration: kPushTime, animations:{
            weakSelf?.contentView.frame = CGRect.init(x: 0, y: (weakSelf?.contentViewY)!, width: kScreenWidth, height: (weakSelf?.contentVH)!)
            weakSelf?.footerBtn.frame = CGRect.init(x: 0, y: (weakSelf?.footBtnY)!, width: kScreenWidth, height: kCellH)
            weakSelf?.bgButton.alpha = 0.35
            weakSelf?.marginView.frame = CGRect.init(x: 0, y: (weakSelf?.footBtnY)! - kSheetMargin, width: kScreenWidth, height: kSheetMargin)
            weakSelf?.marginView.alpha = 1.0
        })
    }
    ///显示TableView的样式
    fileprivate func pushTableStyeSheetView(){
        weak var weakSelf = self
        UIView.animate(withDuration: kPushTime, animations:{
            weakSelf?.contentView.frame = CGRect.init(x: 0, y: (weakSelf?.contentViewY)!, width: kScreenWidth, height: (weakSelf?.contentVH)!)
            weakSelf?.bgButton.alpha = 0.35
        })
    }
    //消失默认样式
    fileprivate func dismissDefaulfSheetView(){
       weak var weakSelf = self
        UIView.animate(withDuration: kDismissTime, animations: {
            
            weakSelf?.contentView.frame = CGRect.init(x: kSheetMargin, y: kScreenHeight, width: kSheetViewWidth, height: (weakSelf?.contentVH)!)
            weakSelf?.footerBtn.frame = CGRect.init(x: kSheetMargin, y: kScreenHeight + (weakSelf?.contentVH)!, width: kSheetViewWidth, height: kCellH)
            weakSelf?.bgButton.alpha = 0.0
            
        }, completion: { (finished) in
            if finished {
                weakSelf?.contentView.removeFromSuperview()
                weakSelf?.footerBtn.removeFromSuperview()
                weakSelf?.bgButton.removeFromSuperview()
                weakSelf?.removeFromSuperview()
            }
        })
    }
    
    //消失微信样式
    fileprivate func dismissWeiChatSheetView(){
        weak var weakSelf = self
        UIView.animate(withDuration: kDismissTime, animations: {
            
            weakSelf?.contentView.frame = CGRect.init(x: 0, y: kScreenHeight, width: kScreenWidth, height: (weakSelf?.contentVH)!)
            weakSelf?.footerBtn.frame = CGRect.init(x: 0, y: (weakSelf?.footBtnY)! + (weakSelf?.contentVH)!, width: kScreenWidth, height: kCellH)
            weakSelf?.marginView.frame = CGRect.init(x: 0, y: kScreenHeight + (weakSelf?.contentView.height)! + (weakSelf?.titleView.height)!, width: kScreenWidth, height: kSheetMargin)
            weakSelf?.bgButton.alpha = 0.0
            weakSelf?.marginView.alpha = 0.0
            
        }, completion: { (finished) in
            if finished {
                weakSelf?.contentView.removeFromSuperview()
                weakSelf?.footerBtn.removeFromSuperview()
                weakSelf?.bgButton.removeFromSuperview()
                weakSelf?.marginView.removeFromSuperview()
                weakSelf?.removeFromSuperview()
            }
        })
    }
    
    //消失TableView样式
    fileprivate func dismissTableStyeSheetView(){
        weak var weakSelf = self
        UIView.animate(withDuration: kDismissTime, animations: {
            
            weakSelf?.contentView.frame = CGRect.init(x: 0, y: kScreenHeight, width: kScreenWidth, height: (weakSelf?.contentVH)!)
            weakSelf?.bgButton.alpha = 0.0
            
        }, completion: { (finished) in
            if finished {
                weakSelf?.contentView.removeFromSuperview()
                weakSelf?.bgButton.removeFromSuperview()
                weakSelf?.removeFromSuperview()
            }
        })
    }
    
    /// 消失样式
    @objc func dismissSheetView(){
        switch self.sheetStyle! {
        case .Default:
            dismissDefaulfSheetView()
        case .WeiChat:
            dismissWeiChatSheetView()
        case .Table:
            dismissTableStyeSheetView()
        }
    }
    /// 多选确定按钮
    @objc func onClickedOkBtn(){
        
        var selectedTitles = [String]()
        
        for index in selectedIndexs {
            selectedTitles.append((dataSource?[index])!)
        }
        
        
        if didMultSelectIndex != nil {
            didMultSelectIndex!(selectedIndexs,selectedTitles)
        }
        
        delegate?.sheetViewDidMultSelect!(indexs: selectedIndexs, titles: selectedTitles, actionSheet: self)
        
        dismissSheetView()
    }
}

// MARK: - GYZSheetViewDelegate
extension GYZActionSheet : GYZSheetViewDelegate{
    func sheetViewDidSelect(index: Int, title: String) {
        
        if didSelectIndex != nil {
            didSelectIndex!(index,title)
        }
        
        delegate?.sheetViewDidSelect!(index: index, title: title, actionSheet: self)
        
        dismissSheetView()
    }
    func sheetViewDidMultSelect(indexs: [Int]) {
        selectedIndexs = indexs
    }
}
