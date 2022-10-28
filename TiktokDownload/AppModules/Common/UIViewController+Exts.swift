//
//  UIViewController+Exts.swift
//  TiktokDownload
//
//  Created by vulcanlabs-hai on 28/10/2022.
//

import Foundation
import UIKit

extension UIViewController {
    func share(urls: [URL]) {
        let activityViewController = UIActivityViewController(activityItems: urls, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func openURL(_ url: String) {
        if let openURL = URL(string: url), UIApplication.shared.canOpenURL(openURL) {
            
            UIApplication.shared.openURL(openURL)
            
        }
    }
}
