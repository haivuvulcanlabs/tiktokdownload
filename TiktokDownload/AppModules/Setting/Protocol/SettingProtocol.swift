//
//  SettingProtocol.swift
//  TiktokDownload
//
//  Created by vulcanlabs-hai on 28/10/2022.
//

import Foundation
import UIKit

protocol SettingViewable where Self: UIViewController {
    func sendEmail()
}

protocol SettingPresentable: AnyObject {
    var view: SettingViewable? { get set }
    var router: SettingRoutable? { get set }
    var interactor: SettingInteractable? { get set }
    var count: Int { get }

    func onViewDidLoad()
    func onViewAppear()
    
    func getItem(at indexPath: IndexPath) -> SettingItem?
    func getSettingSection(at section: Int) -> SettingSection?
    func onTappedBack()
    func onSelectRow(at indexPath: IndexPath)
}

protocol SettingInteractable: AnyObject {
    
}

protocol SettingRoutable: AnyObject {
    func dismiss()
    func presetWebView(title: String, url: String)
}
