//
//  TrendingPresenter.swift
//  TiktokDownload
//
//  Created by vulcanlabs-hai on 28/10/2022.
//

import Foundation
import FirebaseStorage

class TrendingPresenter {
    weak var view: TrendingViewable?
    
    var router: TrendingRoutable?
    
    var interactor: TrendingInteractable?
    var items: [TikTokTrendCodable] {
        get {
            if let data = userDefault.data(forKey: "trending_list") {
               return trendings(from: data)
            } else {
                return []
            }
        }
        
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                userDefault.setValue(data, forKey: "trending_list")
            }
        }
    }
    var count: Int {
        return items.count
    }
    
    var updatedTime: TimeInterval {
        get {
            return userDefault.double(forKey: "trending_update")
        }
        
        set {
            userDefault.set(newValue, forKey: "trending_update")
        }
        
    }

    private let storage = Storage.storage()
    private var userDefault = UserDefaults.standard
    
    func getLocalTrendingList() -> [TikTokTrendCodable] {
        if let path = Bundle.main.url(forResource: "Trendings", withExtension: "json") {
            guard let jsonData = try? Data(contentsOf: path) else { return [] }
            
            return(try? JSONDecoder().decode([TikTokTrendCodable].self, from: jsonData)) ?? []
        }
        
        return []
    }
    
    func downloadFileFromStorage() {
        
        let currentTime = Date().timeIntervalSince1970
        guard currentTime - updatedTime > 60 * 60 * 24 else {
            debugPrint("Storage is updated")
            return
        }
        let storageRef = storage.reference(withPath: "Trendings.json")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        storageRef.getData(maxSize: 1 * 1024 * 1024) {[weak self] data, error in
            guard let `self` = self else { return }
            if let error = error {
                // Uh-oh, an error occurred!
            } else {
                // Data for "images/island.jpg" is returned
                debugPrint("Storage is loaded")

                if let data = data {
                    let remoteItems = (try? JSONDecoder().decode([TikTokTrendCodable].self, from: data)) ?? []
                    
                    if !remoteItems.isEmpty {
                        debugPrint("Storage is updating data")
                        self.updatedTime = Date().timeIntervalSince1970
                        self.items = remoteItems
                        self.view?.reloadTableView()
                    }
                }
            }
        }
    }
    
    func trendings(from data: Data) -> [TikTokTrendCodable] {
        return (try? JSONDecoder().decode([TikTokTrendCodable].self, from: data)) ?? []
    }
}

extension TrendingPresenter: TrendingPresentable {
    func onViewDidLoad() {
        if items.isEmpty {
            items = getLocalTrendingList()
        }
        downloadFileFromStorage()
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
    
    func onSelectRow(at indexPath: IndexPath) {
        guard let item = getItem(at: indexPath) else { return }
        
        AudioPlayer.share.playAudio(path: item.audioURL)
    }
}
