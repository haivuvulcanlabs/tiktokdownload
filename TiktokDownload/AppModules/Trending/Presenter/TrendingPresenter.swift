//
//  TrendingPresenter.swift
//  TiktokDownload
//
//  Created by vulcanlabs-hai on 28/10/2022.
//

import Foundation

class TrendingPresenter {
    var view: TrendingViewable?
    
    var router: TrendingRoutable?
    
    var interactor: TrendingInteractable?
}

extension TrendingPresenter: TrendingPresentable {
  
    
    func onViewDidLoad() {
        
    }
    
    func onViewAppear() {
        
    }
    
    func onTappedBack() {
        router?.dismiss()
    }
}
