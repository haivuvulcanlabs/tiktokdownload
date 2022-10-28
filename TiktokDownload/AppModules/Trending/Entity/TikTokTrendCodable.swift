//
//  TikTokTrendCodable.swift
//  TiktokDownload
//
//  Created by vulcanlabs-hai on 28/10/2022.
//

import Foundation

struct TikTokTrendCodable: Codable {
    let thumbnail: String
    let videoID: String
    let title: String
    let viewCount: Int
    let videoCount: Int
}
