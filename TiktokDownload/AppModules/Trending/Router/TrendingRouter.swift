//
//  TrendingRouter.swift
//  TiktokDownload
//
//  Created by vulcanlabs-hai on 28/10/2022.
//

import Foundation
import UIKit

class TrendingRouter {
    weak var view: UIViewController?
    
    static func setupModule() -> UIViewController {
        let view = TrendingViewController()
        let presenter = TrendingPresenter()
        let interactor = TrendingInteractor()
        let router = TrendingRouter()
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        view.presenter = presenter
        router.view = view
        
        return view
    }
}

extension TrendingRouter: TrendingRoutable {
    func dismiss() {
        view?.dismiss(animated: true)
    }
}
