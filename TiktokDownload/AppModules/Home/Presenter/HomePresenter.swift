//
//  HomePresenter.swift
//  TiktokDownload
//
//  Created by vulcanlabs-hai on 28/10/2022.
//

import Foundation
import Alamofire
import Photos

class HomePresenter {
    var view: HomeViewable?
    
    var router: HomeRoutable?
    
    var interactor: HomeInteractable?
    
    
    var sessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.headers = HTTPHeaders.`default`
        configuration.timeoutIntervalForRequest = 120
        configuration.timeoutIntervalForResource = 120
        return Session(configuration: configuration, interceptor: nil)
    }()
    
    func addDownload(convertibleUrl: String, downCompletion:((Bool,URL?) -> Void)?) -> Void {
        
        let folder = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("videos")
        
        let videoName = convertibleUrl.components(separatedBy: "/").last ?? "\(UUID().uuidString).mp4"
        
        let destination: DownloadRequest.Destination = { _, _ in
            let fileURL = folder.appendingPathComponent(videoName)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        AF.download(convertibleUrl, to: destination).response { responseData in
            switch responseData.result {
            case .success(let url):
                guard let url = url else {
                    downCompletion?(false, nil)
                    return }
                
                debugPrint("download success \(url)")
                downCompletion?(true, url)
            case .failure(let error):
                print("download error \(error.localizedDescription)")
                downCompletion?(false, nil)
            }
        }
    }
    
    
    func saveToCameraRoll(url: URL) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
        }) { saved, error in
            if saved {
               "Your video was successfully saved"
            }
        }
    }
}

extension HomePresenter: HomePresentable {
    
    
    func onViewDidLoad() {
        
    }
    
    func onViewAppear() {
        
    }
    
    func onTappedSetting() {
        router?.presentSettingView()
    }
    func onTappedTrending() {
        router?.presentTrendingView()
    }
    
    func onTappedTiktok() {
        router?.openTiktok()
    }
    
    func onDownload(url: String) {
        view?.showLoadingView()
        addDownload(convertibleUrl: url) {[weak self] finished, url in
            self?.view?.hideLoadingView()
            
            if finished, let url = url {
                self?.saveToCameraRoll(url: url)
            }
        }
    }
    
}
