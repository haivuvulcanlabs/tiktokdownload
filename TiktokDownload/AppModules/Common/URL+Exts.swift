//
//  URL+Exts.swift
//  TiktokDownload
//
//  Created by vulcanlabs-hai on 28/10/2022.
//

import Foundation

extension URL {
    func valueOf(_ queryParameterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParameterName })?.value
    }
}

extension String {
    var isValidURL: Bool {
        guard let url = URL(string: self),
                   url.isFileURL || (url.host != nil && url.scheme != nil) else {
                   return false
               }
        
        return true
    }
    
}
