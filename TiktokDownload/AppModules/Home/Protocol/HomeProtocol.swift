//
//  HomeProtocol.swift
//  TiktokDownload
//
//  Created by vulcanlabs-hai on 28/10/2022.
//

import Foundation

protocol HomeViewable: AnyObject {
    func showLoadingView()
    func hideLoadingView()
    func showSuccessView(message: String?)
    func showSettingPopup()
    func showEmptyInputPopup()
    func showInvalidURLPopup()
}

protocol HomePresentable: AnyObject {
    var view: HomeViewable? { get set }
    var router: HomeRoutable? { get set }
    var interactor: HomeInteractable? { get set }
    
    func onViewDidLoad()
    func onViewAppear()
    func onTappedSetting()
    func onTappedTrending()
    func onTappedTiktok()
    func onDownload(url: String)
}

protocol HomeInteractable: AnyObject {
    
}

protocol HomeRoutable: AnyObject {
    func openTiktok()
    func presentSettingView()
    func presentTrendingView()
}
