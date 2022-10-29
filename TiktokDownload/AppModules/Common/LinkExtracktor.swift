//
//  LinkExtracktor.swift
//  TiktokDownload
//
//  Created by vulcanlabs-hai on 29/10/2022.
//

import Foundation
import WebKit
import SwiftSoup
import AVFoundation

class LinkExtracktor: NSObject {
    static let shared = LinkExtracktor()
    
    let wkWebView = WKWebView()
    
    var extractHandler: ((String?)->())?
    
    func loadWeb(from url: URL) {
        let request = URLRequest(url: url)
        wkWebView.load(request)
        wkWebView.navigationDelegate = self
    }
    
}

extension LinkExtracktor: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        debugPrint("webView didStart")
        //        SVProgressHUD.show(withStatus: "Downloading...")
        
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        debugPrint("webView didCommit")
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        debugPrint("webView didFinish ")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        debugPrint("webView didFail")
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        if(navigationAction.navigationType == .other) {
            if let redirectedUrl = navigationAction.request.url {
                //do what you need with url
                //self.delegate?.openURL(url: redirectedUrl)
                
                debugPrint("webView redirectedUrl \(redirectedUrl.absoluteString)")
                
                if redirectedUrl.absoluteString.contains("video") {
                    extractHandler?(redirectedUrl.absoluteString)
                    webView.stopLoading()
                }
                if redirectedUrl.absoluteString.contains("akamaized") {
                    //                        playVideo(path: redirectedUrl.absoluteString)
                }
            }
            decisionHandler(.allow)
            return
        }
        decisionHandler(.allow)
    }
}

