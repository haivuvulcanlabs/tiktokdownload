//
//  TrendingViewController.swift
//  TiktokDownload
//
//  Created by vulcanlabs-hai on 28/10/2022.
//

import Foundation
import UIKit
import SnapKit
import AVFoundation
import MediaPlayer
import AVKit

class TrendingViewController: UIViewController {
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: Asset.Assets.bgBlur.image)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var headerView: BaseHeaderView = {
        let headerView = BaseHeaderView(leftImage: Asset.Assets.icBack.image, titleText: "SavingTok")
        headerView.tappedLeftHandler = {[weak self] in
            self?.presenter?.onTappedBack()
        }
        return headerView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Top Tiktok Songs This Week"
        label.font = FontFamily.Montserrat.bold.font(size: 22.5)
        label.textColor = UIColor.white
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "last updated: 30/09/2022, 4:31:02"
        label.font = FontFamily.Montserrat.medium.font(size: 13)
        label.textColor = UIColor.white
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TrendingTVC.self, forCellReuseIdentifier: "TrendingTVC")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    var presenter: TrendingPresentable?
    
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
        AudioPlayer.share.playbackUpdateHandler = {[weak self] in
            self?.reloadTableView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        presenter?.onViewAppear()
    }
    
}

private extension TrendingViewController {
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
        view.addSubview(tableView)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom).offset(70)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(guide.snp.bottom)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
        }
    }
    
}

private extension TrendingViewController {
    @objc func tappedOpenTiktokdButton(_ sender: UIButton) {
        
    }
    
    @objc func tappedDownloadButton(_ sender: UIButton) {
        
    }
}


extension TrendingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 71
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.onSelectRow(at: indexPath)
    }
}


extension TrendingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let item = presenter?.getItem(at: indexPath),
              let cell = tableView.dequeueReusableCell(withIdentifier: "TrendingTVC", for: indexPath) as? TrendingTVC else {
            return UITableViewCell()
        }
        
        let selected = item.audioURL == AudioPlayer.share.curentURL?.absoluteString
        let isPlaying = AudioPlayer.share.player?.rate != 0
        cell.updateContent(with: item, selected: selected, playing: isPlaying)
        return cell
    }
}

extension TrendingViewController: TrendingViewable {
    func reloadTableView() {
        DispatchQueue.main.async {[weak self] in
            self?.tableView.reloadData()
        }
    }
}
