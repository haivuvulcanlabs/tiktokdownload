//
//  HomePresenter.swift
//  TiktokDownload
//
//  Created by vulcanlabs-hai on 28/10/2022.
//

import Foundation
import Alamofire
import Photos
typealias TypeClosure<T> = (T) -> Void
typealias PhotoAuthStatus = (isAllowed: Bool, isLimited: Bool)

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
        //        convertibleUrl.components(separatedBy: "/").last ??
        var videoName = "\(UUID().uuidString).mp4"
        
        if !videoName.contains("mp4") {
            videoName = videoName + ".mp4"
        }
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
        }) { [weak self]saved, error in
            if saved {
                self?.view?.showSuccessView(message: "Your video was successfully saved")
            } else {
                self?.view?.showSuccessView(message: "Your video was failed \(error?.localizedDescription)")
                
            }
        }
    }
    
    func startDownLoadVideo(url: String) {
        view?.showLoadingView()
        addDownload(convertibleUrl: url) {[weak self] finished, url in
            self?.view?.hideLoadingView()
            
            if finished, let url = url {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.saveToCameraRoll(url: url)
                }
            }
        }
    }
    
    func checkPhotosAccess() -> PHAuthorizationStatus{
        
        let status: PHAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            status = PHPhotoLibrary.authorizationStatus()
        }
        //
        //            switch status {
        //            case .authorized:
        //
        //                completion((isAllowed: true, isLimited: false))
        //                return true
        //            case .limited:
        //
        //                if #available(iOS 14.0, *) {
        //
        //                    completion((isAllowed: true, isLimited: true))
        //
        //                } else {
        //
        //                    completion((isAllowed: true, isLimited: true))
        //                }
        //
        //                 completion((isAllowed: true, isLimited: true))
        //
        //                return true
        //            case .denied, .restricted:
        //
        ////                delegate?.didFailToGetPermission(Localizable.accessErrorPhotos())
        //                completion((isAllowed: false, isLimited: false))
        //                return false
        //            case .notDetermined:
        //
        //                requestPhotoLibraryAuthorization(completion: completion)
        //                return false
        //            @unknown default:
        //                break
        //            }
        
        return status
    }
    
    func requestPhotoLibraryAuthorization(completion: @escaping TypeClosure<PhotoAuthStatus>) {
        
        if #available(iOS 14.0, *) {
            
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
                
                self?.handlePhotoLibraryAuthorizationStatus(status: status, completion: completion)
                
            }
            
        } else {
            
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                
                self?.handlePhotoLibraryAuthorizationStatus(status: status, completion: completion)
                
            }
            
        }
        
    }
    
    private func handlePhotoLibraryAuthorizationStatus(status: PHAuthorizationStatus,
                                                       completion: @escaping TypeClosure<PhotoAuthStatus>) {
        
        switch status {
        case .authorized:
            completion((isAllowed: true, isLimited: false))
            
        case .limited:
            
            if #available(iOS 14.0, *) {
                
                completion((isAllowed: true, isLimited: true))
                
            } else {
                
                completion((isAllowed: true, isLimited: true))
            }
            
        case .denied, .restricted:
            //                delegate?.didFailToGetPermission(Localizable.accessErrorPhotos())
            completion((isAllowed: false, isLimited: false))
            
        case .notDetermined:
            break // won't happen but still
        @unknown default:
            break
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
        let status = checkPhotosAccess()
        switch status {
        case .denied, .restricted:
            //
            view?.showSettingPopup()
            return
        case .notDetermined:
            requestPhotoLibraryAuthorization {[weak self] status in
                if !status.isAllowed && !status.isLimited {
                    DispatchQueue.main.async {
                        self?.view?.showSettingPopup()
                    } 
                }
            }
            return
        default:
            break
            
        }
        guard !url.isEmpty else {
            view?.showEmptyInputPopup()
            return
        }
        
        guard url.isValidURL, let videoURL = URL(string: url) else {
            view?.showInvalidURLPopup()
            return }
        if url.contains("video") {
            if let videoID = videoURL.path.components(separatedBy: "/").last{
                let videoUrl = "https://www.tikwm.com//video/media/play/\(videoID).mp4"
                debugPrint("url \(videoUrl)")
                self.startDownLoadVideo(url: videoUrl)
            }
            
        } else {
            self.view?.showLoadingView()
            LinkExtracktor.shared.loadWeb(from: videoURL)
            LinkExtracktor.shared.extractHandler = {[weak self] href in
                guard let `self` = self else { return }
                
                if let href = href, let newURL = URL(string: href) {
                    if let videoID = newURL.path.components(separatedBy: "/").last{
                        let videoUrl = "https://www.tikwm.com//video/media/play/\(videoID).mp4"
                        debugPrint("url \(videoUrl)")
                        self.startDownLoadVideo(url: videoUrl)
                    }
                } else {
                    self.view?.hideLoadingView()
                }
                
            }
        }
    }
    
    func checkPhotoLibraryPermission() {
    }
}
