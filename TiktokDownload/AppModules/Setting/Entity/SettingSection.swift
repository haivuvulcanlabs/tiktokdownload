//
//  SettingSection.swift
//  TiktokDownload
//
//  Created by vulcanlabs-hai on 28/10/2022.
//

import Foundation
import UIKit

struct SettingSection {
    let title: String
    let items: [SettingItem]
}

//struct SettingItem {
//    let image: UIImage
//    let text: String
//}


enum SettingItem: Int {
    case review, share, more, contact, term, policy
    
    var image: UIImage {
        switch self {
        case .review:
            return Asset.Assets.icSettingReview.image
        case .share:
            return Asset.Assets.icSettingShare.image

        case .more:
            return Asset.Assets.icSettingMore.image

        case .contact:
            return Asset.Assets.icSettingContact.image

        case .term:
            return Asset.Assets.icSettingTerm.image

        case .policy:
            return Asset.Assets.icSettingPolicy.image

        }
    }
    
    var text: String {
        switch self {
        case .review:
            return "Write a Review"
        case .share:
            return "Share App"
        case .more:
            return "More Apps"
        case .contact:
            return "Contact Us"
        case .term:
            return "Terms of Service"
        case .policy:
            return "Privacy Policy"
        }
    }
}
