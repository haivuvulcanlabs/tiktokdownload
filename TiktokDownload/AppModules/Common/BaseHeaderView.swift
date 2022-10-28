//
//  BaseHeaderView.swift
//  TiktokDownload
//
//  Created by vulcanlabs-hai on 28/10/2022.
//

import Foundation
import UIKit


class BaseHeaderView: UIView {
    private lazy var leftButton: UIButton = {
        let button = UIButton()
        button.setImage(leftImage, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(tappedLeftButton(_:)), for: .touchUpInside)
        button.isHidden = leftImage == nil
        return button
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton()
        button.setImage(rightImage, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(tappedRightButton(_:)), for: .touchUpInside)
        button.isHidden = rightImage == nil

        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = FontFamily.Montserrat.semiBold.font(size: 14)
        label.text = titleText
        label.textColor = .white
        return label
    }()
    
    var tappedLeftHandler:(()->())?
    var tappedRightHandler:(()->())?

    private let leftImage: UIImage?
    private let rightImage: UIImage?
    private let titleText: String?
    init(leftImage: UIImage? = nil, rightImage: UIImage? = nil, titleText: String? = nil) {
        self.leftImage = leftImage
        self.rightImage = rightImage
        self.titleText = titleText
        
        super.init(frame: .zero)
        setupUIs()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUIs() {
        addSubview(titleLabel)
        addSubview(leftButton)
        addSubview(rightButton)
        
        leftButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(40)
        }
        
        rightButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.width.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc func tappedLeftButton(_ sender: UIButton) {
        tappedLeftHandler?()
    }
    
    @objc func tappedRightButton(_ sender: UIButton) {
        tappedRightHandler?()
    }
}


