//
//  ScrollPageView.swift
//  ScrollViewController
//
//  Created by jasnig on 16/4/6.
//  Copyright © 2016年 ZeroJ. All rights reserved.
// github: https://github.com/jasnig
// 简书: http://www.jianshu.com/users/fb31a3d1ec30/latest_articles

//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

//

import UIKit

open class ScrollPageView: UIView {
    static let cellId = "cellId"
    fileprivate var segmentStyle = SegmentStyle()
    /// 附加按钮点击响应
    open var extraBtnOnClick: ((_ extraBtn: UIButton) -> Void)? {
        didSet {
            segView.extraBtnOnClick = extraBtnOnClick
        }
    }
    
    fileprivate(set) var segView: ScrollSegmentView!
    fileprivate(set) var contentView: ContentView!
    /// 标题
    fileprivate var titlesArray: [String] = []
    /// 角标
    fileprivate var badgeValusArray: [String] = []
    /// 所有的子控制器
    fileprivate var childVcs: [UIViewController] = []
    // 这里使用weak避免循环引用
    fileprivate weak var parentViewController: UIViewController?

    public init(frame:CGRect, segmentStyle: SegmentStyle, titles: [String], childVcs:[UIViewController], parentViewController: UIViewController) {
        self.parentViewController = parentViewController
        self.childVcs = childVcs
        self.titlesArray = titles
        self.segmentStyle = segmentStyle
        assert(childVcs.count == titles.count, "标题的个数必须和子控制器的个数相同")
        super.init(frame: frame)
        commonInit()
    }
    
    public init(frame:CGRect, segmentStyle: SegmentStyle, titles: [String], childVcs:[UIViewController], badgeValus : [String], parentViewController: UIViewController) {
        self.parentViewController = parentViewController
        self.childVcs = childVcs
        self.titlesArray = titles
        self.segmentStyle = segmentStyle
        self.badgeValusArray = badgeValus
        assert(childVcs.count == titles.count, "标题的个数必须和子控制器的个数相同")
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func commonInit() {
        backgroundColor = UIColor.white
        if badgeValusArray.count > 0 {
            segView = ScrollSegmentView(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: 44), segmentStyle: segmentStyle, titles: titlesArray,badges:badgeValusArray)
        }else{
            segView = ScrollSegmentView(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: 44), segmentStyle: segmentStyle, titles: titlesArray)
        }
        
        guard let parentVc = parentViewController else { return }
        
        contentView = ContentView(frame: CGRect(x: 0, y: segView.frame.maxY, width: bounds.size.width, height: bounds.size.height - 44), childVcs: childVcs, parentViewController: parentVc)
        contentView.delegate = self
        
        addSubview(segView)
        addSubview(contentView)
        // 避免循环引用
        segView.titleBtnOnClick = {[unowned self] (label: UILabel, index: Int) in
            // 切换内容显示(update content)
            self.contentView.setContentOffSet(CGPoint(x: self.contentView.bounds.size.width * CGFloat(index), y: 0), animated: self.segmentStyle.changeContentAnimated)
        }


    }
    
    deinit {
        parentViewController = nil
        print("\(self.debugDescription) --- 销毁")
    }

 
}

//MARK: - public helper
extension ScrollPageView {
    
    /// 给外界设置选中的下标的方法(public method to set currentIndex)
    public func selectedIndex(_ selectedIndex: Int, animated: Bool) {
        // 移动滑块的位置
        segView.selectedIndex(selectedIndex, animated: animated)
        
    }

    ///   给外界重新设置视图内容的标题的方法,添加新的childViewControllers
    /// (public method to reset childVcs)
    ///  - parameter titles:      newTitles
    ///  - parameter newChildVcs: newChildVcs
    public func reloadChildVcsWithNewTitles(_ titles: [String], andNewChildVcs newChildVcs: [UIViewController]) {
        self.childVcs = newChildVcs
        self.titlesArray = titles
        
        segView.reloadTitlesWithNewTitles(titlesArray)
        contentView.reloadAllViewsWithNewChildVcs(childVcs)
    }
    ///给外界重新设置角标的方法
    public func reloadBadges(badges: [String]){
        self.badgeValusArray = badges
        
        segView.reloadBadge(badges: badgeValusArray)
    }
}

extension ScrollPageView: ContentViewDelegate {

    public var segmentView: ScrollSegmentView {
        return segView
    }

}
