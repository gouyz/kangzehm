//
//  KZGoodsParamsView.swift
//  kangze
//  商品参数
//  Created by gouyz on 2018/9/7.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit

private let goodsParamsCell = "goodsParamsCell"
private let goodsParamsHeader = "goodsParamsHeader"

class KZGoodsParamsView: UIView {
    
    /// 填充数据
    var dataModel : KZGoodsAttrModel?{
        didSet{
            if let model = dataModel {
                
                infoArr.append((model.goods_produce_time?.getDateTime(format: "yyyy年MM月dd日"))!)
                infoArr.append(model.brand_name!)
                infoArr.append(model.gc_name!)
                infoArr.append(model.goods_xinghao!)
                infoArr.append(model.is_imported!)
                infoArr.append(model.packaging_type!)
                infoArr.append(model.applicable_user!)
                infoArr.append(model.include_num!)
                infoArr.append(model.unit!)
                
                tableView.reloadData()
            }
        }
    }
    
    let titleArr: [String] = ["生产日期","品牌","系类","型号","是否进口","包装种类","适用阶段","商品数量","单位"]
    var infoArr: [String] = [String]()
    
    // MARK: 生命周期方法
    override init(frame:CGRect){
        super.init(frame:frame)
    }
    convenience init(){
        let rect = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        self.init(frame: rect)
        
        self.backgroundColor = UIColor.clear
        
        backgroundView.frame = rect
        backgroundView.alpha = 0
        backgroundView.backgroundColor = kBlackColor
        addSubview(backgroundView)
        backgroundView.addOnClickListener(target: self, action: #selector(onTapCancle(sender:)))
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
        
        addSubview(bgView)
        bgView.addOnClickListener(target: self, action: #selector(onBlankClicked))
        
        bgView.addSubview(tableView)
        bgView.addSubview(cancleBtn)
        
        bgView.frame = CGRect.init(x: 0, y: frame.size.height, width: kScreenWidth, height: kCellH * 12)
        
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(bgView)
            make.bottom.equalTo(cancleBtn.snp.top)
        }
        cancleBtn.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(bgView)
            make.height.equalTo(kCellH)
        }
    }
    
    ///整体背景
    var backgroundView: UIView = UIView()
    /// 透明背景
    var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        view.cornerRadius  = kCornerRadius
        
        return view
    }()

    /// 初始化tableViewxx
    lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        
        table.register(GYZCommonInfoCell.self, forCellReuseIdentifier: goodsParamsCell)
        table.register(LHSGeneralHeaderView.self, forHeaderFooterViewReuseIdentifier: goodsParamsHeader)
        
        return table
    }()
    
    /// 关闭
    lazy var cancleBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnClickBGColor
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("关闭", for: .normal)
        btn.addTarget(self, action: #selector(clickedCancleBtn), for: .touchUpInside)
        
        return btn
    }()
    /// 显示
    func show(){
        UIApplication.shared.keyWindow?.addSubview(self)
        
        addAnimation()
    }
    
    ///添加显示动画
    func addAnimation(){
        
        weak var weakSelf = self
        UIView.animate(withDuration: 0.5, animations: {
            
            weakSelf?.bgView.frame = CGRect.init(x: (weakSelf?.bgView.frame.origin.x)!, y: (weakSelf?.frame.size.height)! - (weakSelf?.bgView.frame.size.height)!, width: (weakSelf?.bgView.frame.size.width)!, height: (weakSelf?.bgView.frame.size.height)!)
            
            //            weakSelf?.bgView.center = (weakSelf?.center)!
            weakSelf?.backgroundView.alpha = 0.2
            
        }) { (finished) in
            
        }
    }
    
    ///移除动画
    func removeAnimation(){
        weak var weakSelf = self
        UIView.animate(withDuration: 0.5, animations: {
            
            weakSelf?.bgView.frame = CGRect.init(x: (weakSelf?.bgView.frame.origin.x)!, y: (weakSelf?.frame.size.height)!, width: (weakSelf?.bgView.frame.size.width)!, height: (weakSelf?.bgView.frame.size.height)!)
            weakSelf?.backgroundView.alpha = 0
            
        }) { (finished) in
            weakSelf?.removeFromSuperview()
        }
    }
    /// 隐藏
    func hide(){
        removeAnimation()
    }
    
    /// 点击bgView不消失
    @objc func onBlankClicked(){
        
    }
    
    /// 点击空白取消
    @objc func onTapCancle(sender:UITapGestureRecognizer){
        
        hide()
    }
    
    /// 取消
    @objc func clickedCancleBtn(){
        hide()
    }

}
extension KZGoodsParamsView : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: goodsParamsCell) as! GYZCommonInfoCell
        
        
        cell.titleLab.text = titleArr[indexPath.row]
        if infoArr.count > 0 {
            cell.contentLab.text = infoArr[indexPath.row]
            cell.contentLab.textAlignment = .left
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: goodsParamsHeader) as! LHSGeneralHeaderView
        
        headerView.contentView.backgroundColor = kWhiteColor
        headerView.nameLab.textAlignment = .center
        headerView.nameLab.text = "产品参数"
        
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    
    ///MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kCellH
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kCellH
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}

