//
//  SettingViewController.swift
//  TiktokDownload
//
//  Created by vulcanlabs-hai on 28/10/2022.
//

import Foundation
import UIKit
import SnapKit
import MessageUI

class SettingViewController: UIViewController {
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: Asset.Assets.bgBlur.image)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var headerView: BaseHeaderView = {
        let headerView = BaseHeaderView(leftImage: Asset.Assets.icBack.image ,titleText: "")
        headerView.tappedLeftHandler = {[weak self] in
            self?.presenter?.onTappedBack()
        }
        return headerView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = FontFamily.Montserrat.bold.font(size: 22)
        label.text = "Settings"
        label.textColor = Asset.Colors.hex464860.color
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingTVC.self, forCellReuseIdentifier: "SettingTVC")
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    var presenter: SettingPresentable?
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        presenter?.onViewAppear()
    }
}

private extension SettingViewController {
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
        view.addSubview(tableView)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom).offset(10)

        }
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(guide.snp.bottom)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
    }
}

extension SettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.onSelectRow(at: indexPath)
    }
}

extension SettingViewController: UITableViewDataSource {
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = presenter?.getSettingSection(at: section) else { return 0 }
        
        return section.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let emptyCell = UITableViewCell()
        
        guard let item = presenter?.getItem(at: indexPath),
              let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTVC", for: indexPath) as? SettingTVC
        else { return emptyCell }
        
        
        cell.updateContent(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionData = presenter?.getSettingSection(at: section) else { return nil }
        
        let headerView = UIView()
        headerView.backgroundColor = .clear
        let titleLabel = UILabel()
        titleLabel.text = sectionData.title
        titleLabel.font = FontFamily.Montserrat.bold.font(size: 15)
        titleLabel.textColor = Asset.Colors.hex464860.color
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.bottom.equalToSuperview().offset(-5)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
}

extension SettingViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

extension SettingViewController: SettingViewable {
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["you@yoursite.com"])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
}
