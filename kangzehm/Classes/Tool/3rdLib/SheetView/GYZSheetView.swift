//
//  GYZSheetView.swift
//  GYZActionSheet
//  自定义sheetView
//  Created by gouyz on 2016/12/24.
//  Copyright © 2016年 gouyz. All rights reserved.
//

import UIKit


enum CellTextStyle : Int {
    ///cell文字默认样式居中
    case Center = 0
    ///cell文字样式居左
    case Left
    ///cell文字样式居右
    case Right
}


protocol GYZSheetViewDelegate : NSObjectProtocol {
    func sheetViewDidSelect(index : Int, title : String)
    func sheetViewDidMultSelect(indexs : [Int])
}


private let GYZSheetCellIdentifier = "GYZSheetCellIdentifier"

class GYZSheetView: UIView {
    
    /// 数据源
    var dataSource = [String]()
    /// cell title颜色
    var cellTextColor : UIColor?
    /// cell title字体
    var cellTextFont : UIFont?
    /// cell文字样式 默认居中
    var cellTextStyle : CellTextStyle = .Center
    /// 是否显示分割线 默认显示
    var showDivLine : Bool = true
    
    /// 代理变量
    weak var delegate :GYZSheetViewDelegate?
    
    //存储多选选中单元格的索引
    var selectedIndexs = [Int]()

    // MARK: 生命周期方法
    override init(frame:CGRect){
        super.init(frame:frame)
        
        addSubview(divLine)
        addSubview(tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        divLine.frame = CGRect.init(x: 0, y: 0, width: self.width, height: kLineHeight)
        tableView.frame = CGRect.init(x: 0, y: divLine.bottomY, width: self.width, height: self.height)
    }

    /// 初始化tableViewxx
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.dataSource = self
        table.delegate = self
        table.tableFooterView = UIView()
        table.separatorStyle = .none
        
        table.register(GYZSheetCell.self, forCellReuseIdentifier: GYZSheetCellIdentifier)
        
        return table
    }()
    
    lazy var divLine : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
}

extension GYZSheetView : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kCellH
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GYZSheetCellIdentifier) as! GYZSheetCell
        
        if cellTextColor != nil {
            cell.titleLab.textColor = cellTextColor
        }
        if cellTextFont != nil {
            cell.titleLab.font = cellTextFont
        }
        
        switch cellTextStyle {
        case .Left:
            cell.titleLab.textAlignment = .left
        case .Right:
            cell.titleLab.textAlignment = .right
        default:
            cell.titleLab.textAlignment = .center
        }
        
        cell.lineView.isHidden = !showDivLine
        cell.titleLab.text = dataSource[indexPath.row]
        
        if selectedIndexs.contains(indexPath.row) {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if self.tableView.allowsMultipleSelection {
            //判断该行原先是否选中
            if let index = selectedIndexs.index(of: indexPath.row){
                selectedIndexs.remove(at: index)//原来选中的取消选中
            }else{
                selectedIndexs.append(indexPath.row) //原来没选中的就选中
            }
            
            ////刷新该行
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            
            delegate?.sheetViewDidMultSelect(indexs: selectedIndexs)
            
        }else{
            delegate?.sheetViewDidSelect(index: indexPath.row, title: dataSource[indexPath.row])
        }
    
    }
}
