//
//  TrendingProtocol.swift
//  TiktokDownload
//
//  Created by vulcanlabs-hai on 28/10/2022.
//

import Foundation

protocol TrendingViewable: AnyObject {
    
}

protocol TrendingPresentable: AnyObject {
    var view: TrendingViewable? { get set }
    var router: TrendingRoutable? { get set }
    var interactor: TrendingInteractable? { get set }
    
    func onViewDidLoad()
    func onViewAppear()
    func onTappedBack()
}

protocol TrendingInteractable: AnyObject {
    
}

protocol TrendingRoutable: AnyObject {
    func dismiss()
}
