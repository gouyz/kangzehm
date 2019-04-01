//
//  KZArticleDetailVC.swift
//  kangze
//  文章详情
//  Created by gouyz on 2018/9/8.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import WebKit
import MBProgressHUD

class KZArticleDetailVC: GYZBaseVC {

    /// 加载内容
    var url: String = "http://app.kangzesw.com/wap/tmpl/article_show.html?article_id="
    var dataModel: KZArticleModel?
    /// 文章id
    var articleId: String = ""
    /// 文章title
    var articleTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = articleTitle
            
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
//        requestDetailDatas()
        loadContent()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var webView: WKWebView = {
        let webView = WKWebView()
        ///设置透明背景
        webView.backgroundColor = UIColor.clear
        webView.isOpaque = false
        
        webView.scrollView.bouncesZoom = false
        webView.scrollView.bounces = false
        webView.scrollView.alwaysBounceHorizontal = false
        webView.navigationDelegate = self
        
        return webView
    }()
    
    ///获取详情数据
    func requestDetailDatas(){
        
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("article&op=article_show",parameters: ["article_id":articleId],method : .get,  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            if response["code"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["datas"].dictionaryObject else { return }
                weakSelf?.dataModel = KZArticleModel.init(dict: data)
                weakSelf?.loadContent()
            }else{
                MBProgressHUD.showAutoDismissHUD(message: response["datas"]["error"].stringValue)
            }
            
        }, failture: { (error) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    /// 加载
    func loadContent(){
//        self.navigationItem.title = dataModel?.article_title
//        url = (dataModel?.article_content)!
        url += articleId
        if url.hasPrefix("http://") || url.hasPrefix("https://") {
            
            webView.load(URLRequest.init(url: URL.init(string: url)!))
        }else{
            webView.loadHTMLString(url, baseURL: nil)
        }
    }
}
extension KZArticleDetailVC : WKNavigationDelegate{
    ///MARK WKNavigationDelegate
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        createHUD(message: "加载中...")
    }
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        /// 获取网页title
        //        self.title = self.webView.title
        self.hud?.hide(animated: true)
    }
    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        self.hud?.hide(animated: true)
    }
}

