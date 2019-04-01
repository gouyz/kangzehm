//
//  KZWebViewVC.swift
//  kangze
//  网页加载
//  Created by gouyz on 2018/10/15.
//  Copyright © 2018年 gyz. All rights reserved.
//

import UIKit
import WebKit
import MBProgressHUD

class KZWebViewVC: GYZBaseVC {

    /// 加载内容
    var url: String = ""
    /// 标题
    var headerTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = headerTitle
        self.view.backgroundColor = kWhiteColor
        
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
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
    /// 加载
    func loadContent(){
        if url.hasPrefix("http://") || url.hasPrefix("https://") {
            
            webView.load(URLRequest.init(url: URL.init(string: url)!))
        }else{
            webView.loadHTMLString(url.dealFuTextImgSize(), baseURL: nil)
        }
    }
}
extension KZWebViewVC : WKNavigationDelegate{
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
