//
//  AppWebView.swift
//  TiktokDownload
//
//  Created by vulcanlabs-hai on 28/10/2022.
//

import Foundation
import UIKit
import WebKit
import SVProgressHUD

class AppWebView: UIViewController {
    private lazy var webVew: WKWebView = {
        let webview = WKWebView()
        
        return webview
    }()
    
    private lazy var headerView: BaseHeaderView = {
        let headerView = BaseHeaderView(leftImage: Asset.Assets.icBack.image, titleText: webTitle)
        headerView.tappedLeftHandler = {[weak self] in
            self?.dismiss(animated: true)
        }
        return headerView
    }()
    
    let webTitle: String
    let url: String
    
    init(title: String, url: String) {
        self.webTitle = title
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIs()
        loadWeb()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setupUIs() {
        view.backgroundColor = .black
        let guide = view.safeAreaLayoutGuide
        view.addSubview(headerView)
        view.addSubview(webVew)
        headerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(guide.snp.top)
            make.height.equalTo(44)
        }
        
        webVew.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.equalTo(guide.snp.bottom)
        }
    }
    
    func loadWeb() {
        guard let requestURL = URL(string: url) else { return }
        let request = URLRequest(url: requestURL)
        webVew.load(request)
        webVew.navigationDelegate = self
    }
}

extension AppWebView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        debugPrint("webView didStart")
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
}

