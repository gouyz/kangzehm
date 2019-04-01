//
//  LHSAddPhotoView.swift
//  LazyHuiService
//  添加图片
//  Created by gouyz on 2017/7/7.
//  Copyright © 2017年 gouyz. All rights reserved.
//

import UIKit

class LHSAddPhotoView: UIView {
    
    /// 代理
    weak var delegate: LHSAddPhotoViewDelegate?
    
    var imageViewsArray:[UIImageView] = []
    
    //默认4列，列间隔为10，距离屏幕边距左右各10
    var imgWidth: CGFloat = kPhotosImgHeight
    var maxImgCount : Int = kMaxSelectCount
    var perRowItemCount = 4
    
    ///本地图片
    var selectImgs: [UIImage]?{
        didSet{
            if let imgArr = selectImgs {
                
                for index in imgArr.count ..< imageViewsArray.count {
                    let imgView: UIImageView = imageViewsArray[index]
                    imgView.isHidden = true
                }
                
                if imgArr.count == 0 {
                    addImgBtn.isHidden = false
                    addImgBtn.frame = CGRect.init(x: 0, y: 0, width: imgWidth, height: imgWidth)
                    return
                }
                
                let margin: CGFloat = 10
                for (index,item) in imgArr.enumerated() {
                    let columnIndex = index % perRowItemCount
                    let rowIndex = index/perRowItemCount
                    
                    let imgView: UIImageView = imageViewsArray[index]
                    imgView.isHidden = false
                    imgView.image = item
                    imgView.frame = CGRect.init(x: CGFloat.init(columnIndex) * (imgWidth + margin), y: CGFloat.init(rowIndex) * (imgWidth + margin), width: imgWidth, height: imgWidth)
                    
                    //删除按钮的实现
                    let delImg: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_group_delete"))
                    delImg.tag = 100 + index
                    imgView.addSubview(delImg)
                    
                    delImg.snp.makeConstraints({ (make) in
                        make.top.equalTo(-5)
                        make.right.equalTo(5)
                        make.size.equalTo(CGSize.init(width: 20, height: 20))
                    })
                    delImg.addOnClickListener(target: self, action: #selector(deleteImgOnClick(sender:)))
                }
                
                if imgArr.count == maxImgCount {
                    addImgBtn.isHidden = true
                }else{
                    addImgBtn.isHidden = false
                    let columnIndex = imgArr.count % perRowItemCount
                    let rowIndex = imgArr.count/perRowItemCount
                    
                    addImgBtn.frame = CGRect.init(x: CGFloat.init(columnIndex) * (imgWidth + margin), y: CGFloat.init(rowIndex) * (imgWidth + margin), width: imgWidth, height: imgWidth)
                }
            }
        }
    }
    
    ///加载网络图片
    var selectImgUrls: [String]?{
        didSet{
            if let imgArr = selectImgUrls {
                
                addImgBtn.isHidden = true
                /// 如果图片张数超出最大限制数，只取最大限制数的图片
                var imgCount : Int = imgArr.count
                if imgCount > maxImgCount {
                    imgCount = maxImgCount
                }
                for index in imgCount ..< imageViewsArray.count {
                    let imgView: UIImageView = imageViewsArray[index]
                    imgView.isHidden = true
                }
                
                let perRowItemCount = 3
                let margin: CGFloat = 10
                for (index,item) in imgArr.enumerated() {
                    
                    /// 如果图片张数超出最大限制数，只取最大限制数的图片
                    if index >= imgCount {
                        break
                    }
                    let columnIndex = index % perRowItemCount
                    let rowIndex = index/perRowItemCount
                    
                    let imgView: UIImageView = imageViewsArray[index]
                    
                    imgView.isHidden = false
                    imgView.kf.setImage(with: URL.init(string: item), placeholder: UIImage.init(named: "icon_default"), options: nil, progressBlock: nil, completionHandler: nil)
                    
                    imgView.frame = CGRect.init(x: CGFloat.init(columnIndex) * (imgWidth + margin), y: CGFloat.init(rowIndex) * (imgWidth + margin), width: imgWidth, height: imgWidth)
                }
                
            }
        }
    }
    
    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, maxCount: Int){
        
        self.init(frame: frame)
        
        self.maxImgCount = maxCount
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        for _ in 0 ..< maxImgCount{
            let imgView: UIImageView = UIImageView()
            imgView.isUserInteractionEnabled = true
            addSubview(imgView)
            imageViewsArray.append(imgView)
        }
        
        addImgBtn.addOnClickListener(target: self, action: #selector(addImgOnClick))
        addImgBtn.frame = CGRect.init(x: 0, y: 0, width: imgWidth, height: imgWidth)
        addSubview(addImgBtn)
    }
    
    /// 添加照片
    lazy var addImgBtn: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_add_small"))
    
    /// 添加照片
    @objc func addImgOnClick() {
        delegate?.didClickAddImage(photoView: self)
    }
    /// 删除照片
    @objc func deleteImgOnClick(sender: UITapGestureRecognizer){
        
        delegate?.didClickDeleteImage(index: (sender.view?.tag)! - 100,photoView: self)
    }
}

protocol LHSAddPhotoViewDelegate: NSObjectProtocol {
    /// 增加图片
    func didClickAddImage(photoView: LHSAddPhotoView)
    
    /// 删除图片
    ///
    /// - Parameter index: 图片索引
    func didClickDeleteImage(index: Int,photoView: LHSAddPhotoView)
}
