//
//  SettingTVC.swift
//  TiktokDownload
//
//  Created by vulcanlabs-hai on 28/10/2022.
//

import Foundation
import UIKit

class SettingTVC: UITableViewCell {
    private lazy var iconImageView: UIButton = {
        let button = UIButton()
        button.backgroundColor = Asset.Colors.settingIconBG.color
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        button.rounded(width: 0, color: .clear, radius: 16)
        return button
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView(image: Asset.Assets.icSettingArrow.image)
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = FontFamily.Montserrat.medium.font(size: 15)
        label.textColor = Asset.Colors.hex464860.color
        return label
    }()
    
    private lazy var seperateLineView: UIView = {
        let view = UIView()
        view.backgroundColor = Asset.Colors.hexA2D4C6.color.withAlphaComponent(0.47)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUIs()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUIs() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowImageView)
        contentView.addSubview(seperateLineView)
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(32)
            make.width.height.equalTo(32)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconImageView.snp.right).offset(8)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.width.height.equalTo(31)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20)
        }
        
        seperateLineView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(21)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    func updateContent(with item: SettingItem) {
        iconImageView.setImage(item.image, for: .normal)
        titleLabel.text = item.text
    }
}
