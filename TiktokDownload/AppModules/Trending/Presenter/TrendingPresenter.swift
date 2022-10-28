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
    var items: [TikTokTrendCodable] = []
    var count: Int {
        return items.count
    }
    
    func initData() {
        if let path = Bundle.main.url(forResource: "Trendings", withExtension: "json") {
            guard let jsonData = try? Data(contentsOf: path) else { return }
            
            items = (try? JSONDecoder().decode([TikTokTrendCodable].self, from: jsonData)) ?? []
        }
    }
}

extension TrendingPresenter: TrendingPresentable {
    func onViewDidLoad() {
        initData()
    }
    
    func onViewAppear() {
        
    }
    
    func onTappedBack() {
        router?.dismiss()
    }
    
    func getItem(at index: IndexPath) -> TikTokTrendCodable? {
        guard index.row < items.count else { return nil }
        return items[index.row]
    }
}
