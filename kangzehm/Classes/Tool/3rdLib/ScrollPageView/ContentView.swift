//
//  ContentView.swift
//  ScrollViewController
//
//  Created by jasnig on 16/4/13.
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


open class CustomGestureCollectionView: UICollectionView {
    
    var panGestureShouldBeginClosure: ((_ panGesture: UIPanGestureRecognizer, _ collectionView: CustomGestureCollectionView) -> Bool)?
    func setupPanGestureShouldBeginClosure(_ closure: @escaping (_ panGesture: UIPanGestureRecognizer, _ collectionView: CustomGestureCollectionView) -> Bool) {
        panGestureShouldBeginClosure = closure
    }
    override open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureShouldBeginClosure = panGestureShouldBeginClosure, let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
            return panGestureShouldBeginClosure(panGesture, self)
        }
        else {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
    }
}

open class ContentView: UIView {
    static let cellId = "cellId"
    
    /// 所有的子控制器
    fileprivate var childVcs: [UIViewController] = []
    /// 用来判断是否是点击了title, 点击了就不要调用scrollview的代理来进行相关的计算
    fileprivate var forbidTouchToAdjustPosition = false
    /// 用来记录开始滚动的offSetX
    fileprivate var beginOffSetX:CGFloat = 0.0
    fileprivate var oldIndex = 0
    fileprivate var currentIndex = 1
    
    // 这里使用weak 避免循环引用
    fileprivate weak var parentViewController: UIViewController?
    open weak var delegate: ContentViewDelegate?
    
    fileprivate(set) lazy var collectionView: CustomGestureCollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        
        let collection = CustomGestureCollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
            flowLayout.itemSize = self.bounds.size
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
            
            collection.scrollsToTop = false
            collection.bounces = false
            collection.showsHorizontalScrollIndicator = false
            collection.frame = self.bounds
            collection.collectionViewLayout = flowLayout
            collection.isPagingEnabled = true
            // 如果不设置代理, 将不会调用scrollView的delegate方法
            collection.delegate = self
            collection.dataSource = self
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentView.cellId)
        return collection
    }()
    
//MARK:- life cycle
    public init(frame:CGRect, childVcs:[UIViewController], parentViewController: UIViewController) {
        self.parentViewController = parentViewController
        self.childVcs = childVcs
        super.init(frame: frame)
        commonInit()
        

    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("不要使用storyboard中的view为contentView")
    }
    
    
    fileprivate func commonInit() {
        
        // 不要添加navigationController包装后的子控制器
        for childVc in childVcs {
            if childVc.isKind(of: UINavigationController.self) {
                fatalError("不要添加UINavigationController包装后的子控制器")
            }
            parentViewController?.addChildViewController(childVc)
        }
        collectionView.backgroundColor = UIColor.clear
        collectionView.frame = bounds
        
        // 在这里调用了懒加载的collectionView, 那么之前设置的self.frame将会用于collectionView,如果在layoutsubviews()里面没有相关的处理frame的操作, 那么将导致内容显示不正常
        addSubview(collectionView)
        
        // 设置naviVVc手势代理, 处理pop手势 只在第一个页面的时候执行系统的滑动返回手势
        if let naviParentViewController = self.parentViewController?.parent as? UINavigationController {
            if naviParentViewController.viewControllers.count == 1 { return }
            collectionView.setupPanGestureShouldBeginClosure({[weak self] (panGesture, collectionView) -> Bool in
                
                let strongSelf = self
                guard let `self` = strongSelf else { return false}

                let transionX = panGesture.velocity(in: panGesture.view).x
                
                if collectionView.contentOffset.x == 0 && transionX > 0 {
                    naviParentViewController.interactivePopGestureRecognizer?.isEnabled = true

                }
                else {
                    naviParentViewController.interactivePopGestureRecognizer?.isEnabled = false

                }
                return  self.delegate?.contentViewShouldBeginPanGesture(panGesture, collectionView: collectionView) ?? true

                
            })
        }
    }
    
    // 发布通知
    fileprivate func addCurrentShowIndexNotification(_ index: Int) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: ScrollPageViewDidShowThePageNotification), object: nil, userInfo: ["currentIndex": index])
        
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
        let  vc = childVcs[currentIndex]
        vc.view.frame = bounds
    }
    
    deinit {
        parentViewController = nil
        print("\(self.debugDescription) --- 销毁")
    }

}

//MARK: - public helper
extension ContentView {
    
    // 给外界可以设置ContentOffSet的方法(public method to set contentOffSet)
    public func setContentOffSet(_ offSet: CGPoint , animated: Bool) {
        // 不要执行collectionView的scrollView的滚动代理方法
        self.forbidTouchToAdjustPosition = true
        //这里开始滚动
        delegate?.contentViewDidBeginMove(collectionView)
        self.collectionView.setContentOffset(offSet, animated: animated)

    }
    
    // 给外界刷新视图的方法(public method to reset childVcs)
    public func reloadAllViewsWithNewChildVcs(_ newChildVcs: [UIViewController] ) {
        
        // removing the old childVcs
        childVcs.forEach { (childVc) in
            childVc.willMove(toParentViewController: nil)
            childVc.view.removeFromSuperview()
            childVc.removeFromParentViewController()
        }
        childVcs.removeAll()
        // setting the new childVcs
        childVcs = newChildVcs
        
        // don't add the childVc that wrapped by the navigationController
        // 不要添加navigationController包装后的子控制器
        for childVc in childVcs {
            if childVc.isKind(of: UINavigationController.self) {
                fatalError("不要添加UINavigationController包装后的子控制器")
            }
            // add childVc
            parentViewController?.addChildViewController(childVc)

        }
        
        // refreshing
        collectionView.reloadData()
        
    }
}

//MARK:- UICollectionViewDelegate, UICollectionViewDataSource
extension ContentView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    final public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    final public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentView.cellId, for: indexPath)
        // 避免出现重用显示内容出错 ---- 也可以直接给每个cell用不同的reuseIdentifier实现
        // avoid to the case that shows the wrong thing due to the collectionViewCell's reuse
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        let  vc = childVcs[indexPath.row]
        vc.view.frame = bounds
        cell.contentView.addSubview(vc.view)
        // finish buildding the parent-child relationship
        vc.didMove(toParentViewController: parentViewController)
        // 发布将要显示的index
//        addCurrentShowIndexNotification(indexPath.row)
        return cell
    }
 
}


// MARK: - UIScrollViewDelegate
extension ContentView: UIScrollViewDelegate {
    // update UI
    final public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex = Int(floor(scrollView.contentOffset.x / bounds.size.width))
//        print("减速完成")
        if self.currentIndex == currentIndex {// finish scrolling to next page

            addCurrentShowIndexNotification(currentIndex)

        }
        delegate?.contentViewDidEndDisPlay(collectionView)
        // 保证如果滚动没有到下一页就返回了上一页
        // 通过这种方式再次正确设置 index(still at oldPage )
        delegate?.contentViewDidEndMoveToIndex(self.currentIndex, toIndex: currentIndex)


    }
    
    // 代码调整contentOffSet但是没有动画的时候不会调用这个
    final public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        delegate?.contentViewDidEndDisPlay(collectionView)

    }
    
    final public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentIndex = Int(floor(scrollView.contentOffset.x / bounds.size.width))
        if let naviParentViewController = self.parentViewController?.parent as? UINavigationController {
            naviParentViewController.interactivePopGestureRecognizer?.isEnabled = true

        }
        delegate?.contentViewDidEndDrag(scrollView)
        print(scrollView.contentOffset.x)
        //快速滚动的时候第一页和最后一页(scroll too fast will not call 'scrollViewDidEndDecelerating')
        if scrollView.contentOffset.x == 0 || scrollView.contentOffset.x == scrollView.contentSize.width - scrollView.bounds.width{
            if self.currentIndex != currentIndex {
                delegate?.contentViewDidEndMoveToIndex(self.currentIndex, toIndex: currentIndex)
            }
        }
    }
    
    // 手指开始拖的时候, 记录此时的offSetX, 并且表示不是点击title切换的内容(remenber the begin offsetX)
    final public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        /// 用来判断方向
        beginOffSetX = scrollView.contentOffset.x
        delegate?.contentViewDidBeginMove(collectionView)

        forbidTouchToAdjustPosition = false
    }
    

    
    // 需要实时更新滚动的进度和移动的方向及下标 以便于外部使用 (compute the index and progress)
    final public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetX = scrollView.contentOffset.x
        // 如果是点击了title, 就不要计算了, 直接在点击相应的方法里就已经处理了滚动
        if forbidTouchToAdjustPosition {
            return
        }
        
        let temp = offSetX / bounds.size.width
        // 滚动的进度 -- 取小数位
        var progress = temp - floor(temp)
        // 根据滚动的方向
        if offSetX - beginOffSetX >= 0 {// 手指左滑, 滑块右移
            oldIndex = Int(floor(offSetX / bounds.size.width))
            currentIndex = oldIndex + 1
            if currentIndex >= childVcs.count {
                currentIndex = oldIndex - 1
            }
            
            if offSetX - beginOffSetX == scrollView.bounds.size.width {// 滚动完成
                progress = 1.0;
                currentIndex = oldIndex;
            }
            
        } else {// 手指右滑, 滑块左移
            currentIndex = Int(floor(offSetX / bounds.size.width))
            oldIndex = currentIndex + 1
            progress = 1.0 - progress
            
        }
        
        //        print("\(progress)------\(oldIndex)----\(currentIndex)")
        
        delegate?.contentViewMoveToIndex(oldIndex, toIndex: currentIndex, progress: progress)
        
        
        
    }
    
}

public protocol ContentViewDelegate: class {
    /// 有默认实现, 不推荐重写(override is not recommoned)
    func contentViewMoveToIndex(_ fromIndex: Int, toIndex: Int, progress: CGFloat)
    /// 有默认实现, 不推荐重写(override is not recommoned)
    func contentViewDidEndMoveToIndex(_ fromIndex: Int , toIndex: Int)
    func contentViewShouldBeginPanGesture(_ panGesture: UIPanGestureRecognizer , collectionView: CustomGestureCollectionView) -> Bool;

    func contentViewDidBeginMove(_ scrollView: UIScrollView)
    
    func contentViewIsScrolling(_ scrollView: UIScrollView)
    func contentViewDidEndDisPlay(_ scrollView: UIScrollView)
    
    func contentViewDidEndDrag(_ scrollView: UIScrollView)
    /// 必须提供的属性
    var segmentView: ScrollSegmentView { get }
}

// 由于每个遵守这个协议的都需要执行些相同的操作, 所以直接使用协议扩展统一完成,协议遵守者只需要提供segmentView即可
extension ContentViewDelegate {
    public func contentViewDidEndDrag(_ scrollView: UIScrollView) {
        
    }
    public func contentViewDidEndDisPlay(_ scrollView: UIScrollView) {
        
    }
    public func contentViewIsScrolling(_ scrollView: UIScrollView) {
        
    }
    // 默认什么都不做
    public func contentViewDidBeginMove(_ scrollView: UIScrollView) {
        
    }
    public func contentViewShouldBeginPanGesture(_ panGesture: UIPanGestureRecognizer , collectionView: CustomGestureCollectionView) -> Bool {
        return true
    }
    
    
    // 内容每次滚动完成时调用, 确定title和其他的控件的位置
    public func contentViewDidEndMoveToIndex(_ fromIndex: Int , toIndex: Int) {
        segmentView.adjustTitleOffSetToCurrentIndex(toIndex)
        segmentView.adjustUIWithProgress(1.0, oldIndex: fromIndex, currentIndex: toIndex)
    }
    
    // 内容正在滚动的时候,同步滚动滑块的控件
    public func contentViewMoveToIndex(_ fromIndex: Int, toIndex: Int, progress: CGFloat) {
        segmentView.adjustUIWithProgress(progress, oldIndex: fromIndex, currentIndex: toIndex)
    }
}

