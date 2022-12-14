// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Assets {
    internal static let accentColor = ColorAsset(name: "AccentColor")
    internal static let icSettingArrow = ImageAsset(name: "ic-setting-arrow")
    internal static let icSettingContact = ImageAsset(name: "ic-setting-contact")
    internal static let icSettingMore = ImageAsset(name: "ic-setting-more")
    internal static let icSettingPolicy = ImageAsset(name: "ic-setting-policy")
    internal static let icSettingReview = ImageAsset(name: "ic-setting-review")
    internal static let icSettingShare = ImageAsset(name: "ic-setting-share")
    internal static let icSettingTerm = ImageAsset(name: "ic-setting-term")
    internal static let bgBlur = ImageAsset(name: "bg-blur")
    internal static let bgDownload = ImageAsset(name: "bg-download")
    internal static let bgMain = ImageAsset(name: "bg-main")
    internal static let bgVideoTrending = ImageAsset(name: "bg-video-trending")
    internal static let icBack = ImageAsset(name: "ic-back")
    internal static let icPastelink = ImageAsset(name: "ic-pastelink")
    internal static let icSetting = ImageAsset(name: "ic-setting")
    internal static let icStartDownload = ImageAsset(name: "ic-start-download")
    internal static let icTrendingDemo = ImageAsset(name: "ic-trending-demo")
    internal static let icTrending = ImageAsset(name: "ic-trending")
  }
  internal enum Colors {
    internal static let hex2B2A43 = ColorAsset(name: "hex2B2A43")
    internal static let hex333347 = ColorAsset(name: "hex333347")
    internal static let hex3D57AB = ColorAsset(name: "hex3D57AB")
    internal static let hex464860 = ColorAsset(name: "hex464860")
    internal static let hex68707B = ColorAsset(name: "hex68707B")
    internal static let hex81C1BF = ColorAsset(name: "hex81C1BF")
    internal static let hexA2D4C6 = ColorAsset(name: "hexA2D4C6")
    internal static let hexA6D5C7 = ColorAsset(name: "hexA6D5C7")
    internal static let hexECECEC = ColorAsset(name: "hexECECEC")
    internal static let settingIconBG = ColorAsset(name: "settingIconBG")
    internal static let settingSectionText = ColorAsset(name: "settingSectionText")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
