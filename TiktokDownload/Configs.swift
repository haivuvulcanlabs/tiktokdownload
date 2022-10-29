//
//  Configs.swift
//  TiktokDownload
//
//  Created by vulcanlabs-hai on 28/10/2022.
//

import Foundation

enum Configs {
    enum App {
        static let appId = "1235601864"
        static let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "TikTok Ltd."
        static let reviewAppURL = "itms-apps://itunes.apple.com/app/id\(Configs.App.appId)?action=write-review"
        static let appURL = "itms-apps://itunes.apple.com/US/app/id\(Configs.App.appId)"
        static let otherAppURL = "https://apps.apple.com/vn/developer/tiktok-ltd/id1322881000?l=vi"
    }

    enum URLs {
        static let policyURL = "https://www.apple.com/legal/privacy/"
        static let termURL = "https://www.apple.com/legal/internet-services/terms/site.html"
    }
}
//mason.expa@gmail.com
