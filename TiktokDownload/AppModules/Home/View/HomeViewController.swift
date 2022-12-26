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
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setImage(Asset.Assets.icStartDownload.image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(tappedOpenTiktokdButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var startLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap here to start"
        label.font = FontFamily.Montserrat.medium.font(size: 11)
        label.textColor = Asset.Colors.hex333347.color.withAlphaComponent(0.7)
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Paste Video’s Link"
        label.font = FontFamily.Montserrat.bold.font(size: 26.5)
        label.textColor = Asset.Colors.hex333347.color
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "we will download without watermark."
        label.font = FontFamily.Montserrat.medium.font(size: 13)
        label.textColor = Asset.Colors.hex333347.color
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
        textField.placeholder = "Paste link here"
        
        let atts: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: Asset.Colors.hex333347.color.withAlphaComponent(0.7), NSAttributedString.Key.font: UIFont(name: "Arial-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13)]
        
        let attString = NSMutableAttributedString(string: "Paste link here", attributes: atts)
        textField.attributedPlaceholder = attString
        
        let leftView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 40)))
        let leftImageView = UIImageView(frame: CGRect(x: 4, y: 1, width: 38, height: 38))
        leftImageView.image = Asset.Assets.icPastelink.image
        leftImageView.contentMode = .scaleAspectFit
        leftView.addSubview(leftImageView)
        
        textField.leftView = leftView
        textField.leftViewMode = .always
        
        textField.textColor = Asset.Colors.hex333347.color
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
        
        view.addSubview(startButton)
        view.addSubview(startLabel)
        startButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(UIScreen.main.bounds.width * 113.0 / 414.0)
        }
        startLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(startButton.snp.bottom).offset(5)
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
        
        linkTextField.rounded(width: 1, color: UIColor.white.withAlphaComponent(0.25), radius: buttonHeight/2)
        
    }
}

private extension HomeViewController {
    @objc func tappedOpenTiktokdButton(_ sender: UIButton) {
        presenter?.onTappedTiktok()
    }
    
    @objc func tappedDownloadButton(_ sender: UIButton) {
        
        let inputLink = linkTextField.text ?? ""
//        guard let inputLink = linkTextField.text, !inputLink.isEmpty else {
//            showPopup(message: "Please paste a link first or click on the TikTok logo in middle of screen")
//            return }
     
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
    
    func showSettingPopup() {
        let alert = UIAlertController(title: nil, message: "Turn on Add to Photos in order to save the dowloaded video", preferredStyle: .alert)
        
        let settingAction = UIAlertAction(title: "Settings", style: .default) {[weak self] _ in
            self?.openSettings()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(settingAction)
        
        present(alert, animated: true)
    }
    
    func showEmptyInputPopup() {
        showPopup(message: "Please paste a link first or click on the Download logo in middle of screen")
    }
    
    func showInvalidURLPopup() {
        showPopup(message: "Please input a valid link")
    }
}


