//
//  GYZSheetCell.swift
//  GYZActionSheet
//  sheetView  cell
//  Created by gouyz on 2016/12/26.
//  Copyright © 2016年 gouyz. All rights reserved.
//

import UIKit

class GYZSheetCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(titleLab)
        contentView.addSubview(lineView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 标题lab
    lazy var titleLab : UILabel = {
        let lab = UILabel(frame: CGRect.init(x: 10, y: 0, width: kScreenWidth - 10*2, height: kCellH - kLineHeight))
        lab.font = k18Font
        lab.textColor = UIColor.RGBColor(0, g: 122, b: 255)
        
        return lab
    }()
    
    /// 分割线
    lazy var lineView : UIView = {
        let line = UIView(frame: CGRect(x: 0, y: self.titleLab.bottomY, width: kScreenWidth, height: kLineHeight))
        line.backgroundColor = kGrayLineColor
        
        return line
    }()
}
