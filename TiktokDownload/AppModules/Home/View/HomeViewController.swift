//
//  HomeViewController.swift
//  TiktokDownload
//
//  Created by vulcanlabs-hai on 28/10/2022.
//

import Foundation
import UIKit
import SnapKit
import SVProgressHUD

class HomeViewController: UIViewController, KeyboardObservable{
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: Asset.Assets.bgBlur.image)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    private lazy var headerView: BaseHeaderView = {
        let headerView = BaseHeaderView(leftImage: Asset.Assets.icSetting.image, rightImage: Asset.Assets.icTrending.image, titleText: "SavingTok")
        headerView.tappedLeftHandler = {[weak self] in
            self?.presenter?.onTappedSetting()
        }
        
        headerView.tappedRightHandler = {[weak self] in
            self?.presenter?.onTappedTrending()
        }
        
        return headerView
    }()
    
    private lazy var tiktokButton: UIButton = {
        let button = UIButton()
        button.setImage(Asset.Assets.icTiktokLogo.image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(tappedOpenTiktokdButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var tiktokLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap to go to TikTok"
        label.font = FontFamily.Montserrat.medium.font(size: 11)
        label.textColor = UIColor.white
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Paste Tiktok Link"
        label.font = FontFamily.Montserrat.bold.font(size: 26.5)
        label.textColor = UIColor.white
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "we will download without watermark."
        label.font = FontFamily.Montserrat.medium.font(size: 13)
        label.textColor = UIColor.white
        return label
    }()
    
    private lazy var downloadButton: UIButton = {
        let button = UIButton()
        button.setImage(Asset.Assets.bgDownload.image, for: .normal)
        button.addTarget(self, action: #selector(tappedDownloadButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var linkTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Paste TikTok link here"
        
        let atts: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: Asset.Colors.hexECECEC.color, NSAttributedString.Key.font: UIFont(name: "Arial-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13)]
        
        let attString = NSMutableAttributedString(string: "Paste TikTok link here", attributes: atts)
        textField.attributedPlaceholder = attString
        
        let leftView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 40)))
        let leftImageView = UIImageView(frame: CGRect(x: 2, y: 1, width: 38, height: 38))
        leftImageView.image = Asset.Assets.icPastelink.image
        leftImageView.contentMode = .scaleAspectFit
        leftView.addSubview(leftImageView)
        
        textField.leftView = leftView
        textField.leftViewMode = .always
        
        textField.textColor = .white
//        textField.text = "https://vt.tiktok.com/ZSRnuBWGj/"
        return textField
    }()
    
    var presenter: HomePresentable?
    var keyboardObserver: KeyboardObserver?
    var bottomConstraint: Constraint?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.onViewDidLoad()
        setupUIs()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(gestureHandler(_:)))
        view.addGestureRecognizer(tapGesture)
        
        startKeyboardObserving { (keyboardFrame) in
            self.bottomConstraint?.update(offset: -keyboardFrame.height)
        } onHide: {
            self.bottomConstraint?.update(offset: -20)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        presenter?.onViewAppear()
    }
    
    
}

private extension HomeViewController {
    func setupUIs() {
        let guide = view.safeAreaLayoutGuide
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        //
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(guide.snp.top)
            make.height.equalTo(40)
        }
        
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom).offset(70)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        
        view.addSubview(tiktokButton)
        view.addSubview(tiktokLabel)
        tiktokButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(UIScreen.main.bounds.width * 113.0 / 414.0)
        }
        tiktokLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(tiktokButton.snp.bottom).offset(5)
        }
        
        //
        view.addSubview(linkTextField)
        view.addSubview(downloadButton)
        
        let buttonWidth = UIScreen.main.bounds.width * 325.0/390.0
        let buttonHeight = buttonWidth * 45.0/325.0
        downloadButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(365.0/390.0)
            make.height.equalTo(downloadButton.snp.width).multipliedBy(84.0/365.0)
            bottomConstraint = make.bottom.equalTo(guide.snp.bottom).offset(-20).constraint
        }
        
        linkTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonHeight)
            make.bottom.equalTo(downloadButton.snp.top).offset(-10)
        }
        
        linkTextField.rounded(width: 1, color: Asset.Colors.hexA6D5C7.color, radius: buttonHeight/2)
        
    }
}

private extension HomeViewController {
    @objc func tappedOpenTiktokdButton(_ sender: UIButton) {
        presenter?.onTappedTiktok()
    }
    
    @objc func tappedDownloadButton(_ sender: UIButton) {
        guard let inputLink = linkTextField.text, !inputLink.isEmpty else { return }
     
        presenter?.onDownload(url: inputLink)
    }
    
    @objc func gestureHandler(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}


extension HomeViewController: HomeViewable {
    func showLoadingView() {
        SVProgressHUD.show(withStatus: "Downloading...")
        
    }
    func hideLoadingView() {
        SVProgressHUD.dismiss()
    }
    
    func showSuccessView(message: String?) {
        SVProgressHUD.showSuccess(withStatus: message)
    }
}
