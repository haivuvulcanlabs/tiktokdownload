//
//  UIView+Exts.swift
//  TiktokDownload
//
//  Created by vulcanlabs-hai on 28/10/2022.
//

import Foundation
import UIKit

extension UIView {
    func rounded(width: CGFloat = 0.0, color: UIColor = .clear, radius: CGFloat = 6) {
        layer.cornerRadius = radius
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        layer.masksToBounds = true
    }
}
