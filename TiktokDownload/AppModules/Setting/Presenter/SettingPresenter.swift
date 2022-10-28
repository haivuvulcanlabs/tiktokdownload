//
//  SettingPresenter.swift
//  TiktokDownload
//
//  Created by vulcanlabs-hai on 28/10/2022.
//

import Foundation

class SettingPresenter {
    var view: SettingViewable?
    
    var router: SettingRoutable?
    
    var interactor: SettingInteractable?
    
    var sections: [SettingSection] = []
    var count: Int {
        return sections.count
    }
    func initData() {
        let sectionOne = SettingSection(title: "Share", items: [.review, .share, .more])
    
        let sectionTwo = SettingSection(title: "Support", items: [.contact])

        let sectionThree = SettingSection(title: "Legal", items: [.term, .policy])

        sections = [sectionOne, sectionTwo, sectionThree]
    }
}

extension SettingPresenter: SettingPresentable {
    func onViewDidLoad() {
        initData()
    }
    
    func onViewAppear() {
        
    }
    
    func getItem(at indexPath: IndexPath) -> SettingItem? {
        guard let section = getSettingSection(at: indexPath.section) else { return nil }
        guard indexPath.row < section.items.count else { return nil }
        
        return section.items[indexPath.row]
    }
    
    func getSettingSection(at section: Int) -> SettingSection? {
        guard section < sections.count else { return nil }
        
        return sections[section]
    }
    
    func onTappedBack() {
        router?.dismiss()
    }
    
    func onSelectRow(at indexPath: IndexPath) {
        guard let item = getItem(at: indexPath) else { return }
        
        switch item {
        case .review:
            view?.openURL(Configs.App.reviewAppURL)
        case .share:
            guard let url = URL(string: Configs.App.appURL) else { return }
            view?.share(urls: [url])
        case .more:
            view?.openURL(Configs.App.otherAppURL)
        case .contact:
            view?.sendEmail()
        case .term:
            router?.presetWebView(title: item.text, url: Configs.URLs.termURL)
        case .policy:
            router?.presetWebView(title: item.text, url: Configs.URLs.policyURL)
        }
    }
}
