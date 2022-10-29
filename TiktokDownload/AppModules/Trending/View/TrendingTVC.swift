//
//  TrendingTVC.swift
//  TiktokDownload
//
//  Created by vulcanlabs-hai on 28/10/2022.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher
import Lottie

class TrendingTVC: UITableViewCell {
    
    private lazy var oderLabel:UILabel = {
        let label = UILabel()
        label.font = FontFamily.Montserrat.semiBold.font(size: 22.5)
        label.text = "1"
        label.textColor = Asset.Colors.hex81C1BF.color
        return label
    }()
    
    private lazy var holderView: UIView = {
        let subView = UIView()
        let bgImageView = UIImageView(image: Asset.Assets.bgVideoTrending.image)
        bgImageView.contentMode = .scaleAspectFill
        subView.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bgImageView.rounded(width: 0, color: .clear, radius: 30)
        return subView
    }()
    
    private lazy var animView: LottieAnimationView = {
        let animView = LottieAnimationView()
        animView.animation = LottieAnimation.named("music-equalizer")
        animView.contentMode = .scaleAspectFit
        animView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return animView
    }()
    
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView(image: Asset.Assets.icTrendingDemo.image)
        imageView.rounded(width: 1, color: .white, radius: 26)
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Monkeys Spinning Monkeys"
        label.textColor = Asset.Colors.hexECECEC.color
        label.font = FontFamily.Arial.regular.font(size: 13)
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "—  ·  922.5M views  ·  1.4K popular videos"
        label.textColor = Asset.Colors.hexECECEC.color
        label.font = FontFamily.Arial.regular.font(size: 9)
        return label
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
        
        contentView.addSubview(oderLabel)
        contentView.addSubview(holderView)

        oderLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(holderView.snp.left).offset(-10)
        }
        
        holderView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(42)
            make.right.equalToSuperview().inset(20)
        }
        
        holderView.addSubview(thumbnailImageView)
        holderView.addSubview(animView)
        holderView.addSubview(titleLabel)
        holderView.addSubview(subTitleLabel)

        thumbnailImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(52)
            make.left.equalToSuperview().offset(5)
        }
        
        animView.snp.makeConstraints { make in
            make.centerX.equalTo(thumbnailImageView.snp.centerX)
            make.centerY.equalTo(thumbnailImageView.snp.centerY)
            make.width.height.equalTo(25)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(thumbnailImageView.snp.right).offset(11)
            make.centerY.equalToSuperview().offset(-8)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(thumbnailImageView.snp.right).offset(11)
            make.centerY.equalToSuperview().offset(8)
        }
    }
    
    func updateContent(with item: TikTokTrendCodable, selected: Bool, playing: Bool) {
        oderLabel.text = "\(item.rank)"
        thumbnailImageView.kf.setImage(with: URL(string: item.thumbnail))
        titleLabel.text = item.title
        subTitleLabel.text = "—  ·  \(item.viewCount) views  ·  \(item.viewCount) popular videos"
        animView.isHidden = !selected
        if playing {
            animView.play(fromProgress: 0, toProgress: 1, loopMode: .loop)
        } else {
            animView.stop()
        }
    }
}
