//
//  ViewController.swift
//  SwiftBridreHtml
//
//  Created by ydz on 16/8/17.
//  Copyright © 2016年 jonie. All rights reserved.
//

import UIKit
import WebKit
var screenWidth = UIScreen.mainScreen().bounds.size.width
var screenHeight = UIScreen.mainScreen().bounds.size.width

class ViewController: UIViewController{
    var userContentController: WKUserContentController!
    var webView: WKWebView!
    var progressView: UIProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        baseConfig()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//MARK:基本配置
    func baseConfig()  {
        let configuration = WKWebViewConfiguration()
        userContentController=WKUserContentController()
        userContentController.addScriptMessageHandler(self, name: "AppModel")
        configuration.userContentController=userContentController
        configuration.preferences.javaScriptEnabled=true
        webView=WKWebView(frame: CGRectMake(0, 0, screenWidth, screenHeight), configuration: configuration)
        webView.backgroundColor=UIColor.clearColor()
        webView.UIDelegate=self
        webView.navigationDelegate=self
        webView.allowsBackForwardNavigationGestures=true
        webView.allowsLinkPreview=true
        let path = NSBundle.mainBundle().pathForResource("test", ofType: "html")
        webView.loadRequest(NSURLRequest(URL: NSURL(fileURLWithPath: path!)))
        self.view.addSubview(webView)
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.New, context: nil)
        initProgressView()
    }
    func initProgressView() {
        progressView=UIProgressView(frame: CGRectMake(0, 64, screenWidth, 10))
        progressView.tintColor=UIColor.blueColor()
        progressView.trackTintColor=UIColor.whiteColor()
        self.view.addSubview(progressView)
    }
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath=="estimatedProgress" {
//            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            progressView.hidden=false
            let progress = Float((change!["new"]?.floatValue)!)
            progressView.setProgress(progress, animated: true)
            if(progress==1.0)
            {
                progressView.hidden = true;
            }
        }
        if !webView.loading {
            progressView.alpha=0.0
        }
    }

}
extension ViewController:WKNavigationDelegate{
    
}
extension ViewController:WKUIDelegate{
    
}
extension ViewController:WKScriptMessageHandler{
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        if  message.name=="" {
            return
        }
        print(message.body)
        if message.name == "AppModel"{
            let body=message.body["body"] as! String
            if body == "客户端调用JS成功" {
                webView.evaluateJavaScript("getIndexArea('hahaha')", completionHandler: nil)
            }
        }
        
    }
}

