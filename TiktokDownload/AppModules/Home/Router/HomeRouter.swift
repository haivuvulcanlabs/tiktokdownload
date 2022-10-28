//
//  HomeRouter.swift
//  TiktokDownload
//
//  Created by vulcanlabs-hai on 28/10/2022.
//

import Foundation
import UIKit

class HomeRouter {
    weak var view: UIViewController?
    
    static func setupModule() -> UIViewController {
        let view = HomeViewController()
        let presenter = HomePresenter()
        let interactor = HomeInteractor()
        let router = HomeRouter()
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        view.presenter = presenter
        router.view = view
        
        return view
    }
}

extension HomeRouter: HomeRoutable {
    func presentSettingView() {
        let settingVC = SettingRouter.setupModule()
        let nav = UINavigationController(rootViewController: settingVC)
        nav.modalPresentationStyle = .fullScreen
        
        view?.present(nav, animated: true)
    }
    
    func presentTrendingView() {
        let trenđingVC = TrendingRouter.setupModule()
        let nav = UINavigationController(rootViewController: trenđingVC)
        nav.modalPresentationStyle = .fullScreen
        
        view?.present(nav, animated: true)
    }
    
    func openTiktok() {
        guard let url = URL(string: "https://www.tiktok.com/") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
