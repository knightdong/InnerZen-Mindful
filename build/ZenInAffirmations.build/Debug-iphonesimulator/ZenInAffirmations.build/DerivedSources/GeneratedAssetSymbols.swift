import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
extension ColorResource {

}

// MARK: - Image Symbols -

@available(iOS 11.0, macOS 10.7, tvOS 11.0, *)
extension ImageResource {

    /// The "banner_cover0" asset catalog image resource.
    static let bannerCover0 = ImageResource(name: "banner_cover0", bundle: resourceBundle)

    /// The "banner_cover1" asset catalog image resource.
    static let bannerCover1 = ImageResource(name: "banner_cover1", bundle: resourceBundle)

    /// The "banner_cover10" asset catalog image resource.
    static let bannerCover10 = ImageResource(name: "banner_cover10", bundle: resourceBundle)

    /// The "banner_cover11" asset catalog image resource.
    static let bannerCover11 = ImageResource(name: "banner_cover11", bundle: resourceBundle)

    /// The "banner_cover12" asset catalog image resource.
    static let bannerCover12 = ImageResource(name: "banner_cover12", bundle: resourceBundle)

    /// The "banner_cover13" asset catalog image resource.
    static let bannerCover13 = ImageResource(name: "banner_cover13", bundle: resourceBundle)

    /// The "banner_cover14" asset catalog image resource.
    static let bannerCover14 = ImageResource(name: "banner_cover14", bundle: resourceBundle)

    /// The "banner_cover15" asset catalog image resource.
    static let bannerCover15 = ImageResource(name: "banner_cover15", bundle: resourceBundle)

    /// The "banner_cover16" asset catalog image resource.
    static let bannerCover16 = ImageResource(name: "banner_cover16", bundle: resourceBundle)

    /// The "banner_cover17" asset catalog image resource.
    static let bannerCover17 = ImageResource(name: "banner_cover17", bundle: resourceBundle)

    /// The "banner_cover18" asset catalog image resource.
    static let bannerCover18 = ImageResource(name: "banner_cover18", bundle: resourceBundle)

    /// The "banner_cover19" asset catalog image resource.
    static let bannerCover19 = ImageResource(name: "banner_cover19", bundle: resourceBundle)

    /// The "banner_cover2" asset catalog image resource.
    static let bannerCover2 = ImageResource(name: "banner_cover2", bundle: resourceBundle)

    /// The "banner_cover3" asset catalog image resource.
    static let bannerCover3 = ImageResource(name: "banner_cover3", bundle: resourceBundle)

    /// The "banner_cover4" asset catalog image resource.
    static let bannerCover4 = ImageResource(name: "banner_cover4", bundle: resourceBundle)

    /// The "banner_cover5" asset catalog image resource.
    static let bannerCover5 = ImageResource(name: "banner_cover5", bundle: resourceBundle)

    /// The "banner_cover6" asset catalog image resource.
    static let bannerCover6 = ImageResource(name: "banner_cover6", bundle: resourceBundle)

    /// The "banner_cover7" asset catalog image resource.
    static let bannerCover7 = ImageResource(name: "banner_cover7", bundle: resourceBundle)

    /// The "banner_cover8" asset catalog image resource.
    static let bannerCover8 = ImageResource(name: "banner_cover8", bundle: resourceBundle)

    /// The "banner_cover9" asset catalog image resource.
    static let bannerCover9 = ImageResource(name: "banner_cover9", bundle: resourceBundle)

    /// The "breathe" asset catalog image resource.
    static let breathe = ImageResource(name: "breathe", bundle: resourceBundle)

    /// The "cover0" asset catalog image resource.
    static let cover0 = ImageResource(name: "cover0", bundle: resourceBundle)

    /// The "cover1" asset catalog image resource.
    static let cover1 = ImageResource(name: "cover1", bundle: resourceBundle)

    /// The "cover10" asset catalog image resource.
    static let cover10 = ImageResource(name: "cover10", bundle: resourceBundle)

    /// The "cover11" asset catalog image resource.
    static let cover11 = ImageResource(name: "cover11", bundle: resourceBundle)

    /// The "cover12" asset catalog image resource.
    static let cover12 = ImageResource(name: "cover12", bundle: resourceBundle)

    /// The "cover13" asset catalog image resource.
    static let cover13 = ImageResource(name: "cover13", bundle: resourceBundle)

    /// The "cover14" asset catalog image resource.
    static let cover14 = ImageResource(name: "cover14", bundle: resourceBundle)

    /// The "cover15" asset catalog image resource.
    static let cover15 = ImageResource(name: "cover15", bundle: resourceBundle)

    /// The "cover16" asset catalog image resource.
    static let cover16 = ImageResource(name: "cover16", bundle: resourceBundle)

    /// The "cover17" asset catalog image resource.
    static let cover17 = ImageResource(name: "cover17", bundle: resourceBundle)

    /// The "cover18" asset catalog image resource.
    static let cover18 = ImageResource(name: "cover18", bundle: resourceBundle)

    /// The "cover19" asset catalog image resource.
    static let cover19 = ImageResource(name: "cover19", bundle: resourceBundle)

    /// The "cover2" asset catalog image resource.
    static let cover2 = ImageResource(name: "cover2", bundle: resourceBundle)

    /// The "cover3" asset catalog image resource.
    static let cover3 = ImageResource(name: "cover3", bundle: resourceBundle)

    /// The "cover4" asset catalog image resource.
    static let cover4 = ImageResource(name: "cover4", bundle: resourceBundle)

    /// The "cover5" asset catalog image resource.
    static let cover5 = ImageResource(name: "cover5", bundle: resourceBundle)

    /// The "cover6" asset catalog image resource.
    static let cover6 = ImageResource(name: "cover6", bundle: resourceBundle)

    /// The "cover7" asset catalog image resource.
    static let cover7 = ImageResource(name: "cover7", bundle: resourceBundle)

    /// The "cover8" asset catalog image resource.
    static let cover8 = ImageResource(name: "cover8", bundle: resourceBundle)

    /// The "cover9" asset catalog image resource.
    static let cover9 = ImageResource(name: "cover9", bundle: resourceBundle)

    /// The "enmotion" asset catalog image resource.
    static let enmotion = ImageResource(name: "enmotion", bundle: resourceBundle)

    /// The "meditation" asset catalog image resource.
    static let meditation = ImageResource(name: "meditation", bundle: resourceBundle)

    /// The "zen_wall0" asset catalog image resource.
    static let zenWall0 = ImageResource(name: "zen_wall0", bundle: resourceBundle)

    /// The "zen_wall1" asset catalog image resource.
    static let zenWall1 = ImageResource(name: "zen_wall1", bundle: resourceBundle)

    /// The "zen_wall10" asset catalog image resource.
    static let zenWall10 = ImageResource(name: "zen_wall10", bundle: resourceBundle)

    /// The "zen_wall11" asset catalog image resource.
    static let zenWall11 = ImageResource(name: "zen_wall11", bundle: resourceBundle)

    /// The "zen_wall12" asset catalog image resource.
    static let zenWall12 = ImageResource(name: "zen_wall12", bundle: resourceBundle)

    /// The "zen_wall13" asset catalog image resource.
    static let zenWall13 = ImageResource(name: "zen_wall13", bundle: resourceBundle)

    /// The "zen_wall14" asset catalog image resource.
    static let zenWall14 = ImageResource(name: "zen_wall14", bundle: resourceBundle)

    /// The "zen_wall15" asset catalog image resource.
    static let zenWall15 = ImageResource(name: "zen_wall15", bundle: resourceBundle)

    /// The "zen_wall16" asset catalog image resource.
    static let zenWall16 = ImageResource(name: "zen_wall16", bundle: resourceBundle)

    /// The "zen_wall17" asset catalog image resource.
    static let zenWall17 = ImageResource(name: "zen_wall17", bundle: resourceBundle)

    /// The "zen_wall18" asset catalog image resource.
    static let zenWall18 = ImageResource(name: "zen_wall18", bundle: resourceBundle)

    /// The "zen_wall19" asset catalog image resource.
    static let zenWall19 = ImageResource(name: "zen_wall19", bundle: resourceBundle)

    /// The "zen_wall2" asset catalog image resource.
    static let zenWall2 = ImageResource(name: "zen_wall2", bundle: resourceBundle)

    /// The "zen_wall20" asset catalog image resource.
    static let zenWall20 = ImageResource(name: "zen_wall20", bundle: resourceBundle)

    /// The "zen_wall21" asset catalog image resource.
    static let zenWall21 = ImageResource(name: "zen_wall21", bundle: resourceBundle)

    /// The "zen_wall22" asset catalog image resource.
    static let zenWall22 = ImageResource(name: "zen_wall22", bundle: resourceBundle)

    /// The "zen_wall23" asset catalog image resource.
    static let zenWall23 = ImageResource(name: "zen_wall23", bundle: resourceBundle)

    /// The "zen_wall24" asset catalog image resource.
    static let zenWall24 = ImageResource(name: "zen_wall24", bundle: resourceBundle)

    /// The "zen_wall25" asset catalog image resource.
    static let zenWall25 = ImageResource(name: "zen_wall25", bundle: resourceBundle)

    /// The "zen_wall26" asset catalog image resource.
    static let zenWall26 = ImageResource(name: "zen_wall26", bundle: resourceBundle)

    /// The "zen_wall27" asset catalog image resource.
    static let zenWall27 = ImageResource(name: "zen_wall27", bundle: resourceBundle)

    /// The "zen_wall28" asset catalog image resource.
    static let zenWall28 = ImageResource(name: "zen_wall28", bundle: resourceBundle)

    /// The "zen_wall29" asset catalog image resource.
    static let zenWall29 = ImageResource(name: "zen_wall29", bundle: resourceBundle)

    /// The "zen_wall3" asset catalog image resource.
    static let zenWall3 = ImageResource(name: "zen_wall3", bundle: resourceBundle)

    /// The "zen_wall30" asset catalog image resource.
    static let zenWall30 = ImageResource(name: "zen_wall30", bundle: resourceBundle)

    /// The "zen_wall31" asset catalog image resource.
    static let zenWall31 = ImageResource(name: "zen_wall31", bundle: resourceBundle)

    /// The "zen_wall32" asset catalog image resource.
    static let zenWall32 = ImageResource(name: "zen_wall32", bundle: resourceBundle)

    /// The "zen_wall33" asset catalog image resource.
    static let zenWall33 = ImageResource(name: "zen_wall33", bundle: resourceBundle)

    /// The "zen_wall34" asset catalog image resource.
    static let zenWall34 = ImageResource(name: "zen_wall34", bundle: resourceBundle)

    /// The "zen_wall35" asset catalog image resource.
    static let zenWall35 = ImageResource(name: "zen_wall35", bundle: resourceBundle)

    /// The "zen_wall36" asset catalog image resource.
    static let zenWall36 = ImageResource(name: "zen_wall36", bundle: resourceBundle)

    /// The "zen_wall37" asset catalog image resource.
    static let zenWall37 = ImageResource(name: "zen_wall37", bundle: resourceBundle)

    /// The "zen_wall38" asset catalog image resource.
    static let zenWall38 = ImageResource(name: "zen_wall38", bundle: resourceBundle)

    /// The "zen_wall39" asset catalog image resource.
    static let zenWall39 = ImageResource(name: "zen_wall39", bundle: resourceBundle)

    /// The "zen_wall4" asset catalog image resource.
    static let zenWall4 = ImageResource(name: "zen_wall4", bundle: resourceBundle)

    /// The "zen_wall40" asset catalog image resource.
    static let zenWall40 = ImageResource(name: "zen_wall40", bundle: resourceBundle)

    /// The "zen_wall41" asset catalog image resource.
    static let zenWall41 = ImageResource(name: "zen_wall41", bundle: resourceBundle)

    /// The "zen_wall42" asset catalog image resource.
    static let zenWall42 = ImageResource(name: "zen_wall42", bundle: resourceBundle)

    /// The "zen_wall43" asset catalog image resource.
    static let zenWall43 = ImageResource(name: "zen_wall43", bundle: resourceBundle)

    /// The "zen_wall44" asset catalog image resource.
    static let zenWall44 = ImageResource(name: "zen_wall44", bundle: resourceBundle)

    /// The "zen_wall45" asset catalog image resource.
    static let zenWall45 = ImageResource(name: "zen_wall45", bundle: resourceBundle)

    /// The "zen_wall46" asset catalog image resource.
    static let zenWall46 = ImageResource(name: "zen_wall46", bundle: resourceBundle)

    /// The "zen_wall47" asset catalog image resource.
    static let zenWall47 = ImageResource(name: "zen_wall47", bundle: resourceBundle)

    /// The "zen_wall48" asset catalog image resource.
    static let zenWall48 = ImageResource(name: "zen_wall48", bundle: resourceBundle)

    /// The "zen_wall49" asset catalog image resource.
    static let zenWall49 = ImageResource(name: "zen_wall49", bundle: resourceBundle)

    /// The "zen_wall5" asset catalog image resource.
    static let zenWall5 = ImageResource(name: "zen_wall5", bundle: resourceBundle)

    /// The "zen_wall50" asset catalog image resource.
    static let zenWall50 = ImageResource(name: "zen_wall50", bundle: resourceBundle)

    /// The "zen_wall51" asset catalog image resource.
    static let zenWall51 = ImageResource(name: "zen_wall51", bundle: resourceBundle)

    /// The "zen_wall52" asset catalog image resource.
    static let zenWall52 = ImageResource(name: "zen_wall52", bundle: resourceBundle)

    /// The "zen_wall53" asset catalog image resource.
    static let zenWall53 = ImageResource(name: "zen_wall53", bundle: resourceBundle)

    /// The "zen_wall54" asset catalog image resource.
    static let zenWall54 = ImageResource(name: "zen_wall54", bundle: resourceBundle)

    /// The "zen_wall55" asset catalog image resource.
    static let zenWall55 = ImageResource(name: "zen_wall55", bundle: resourceBundle)

    /// The "zen_wall56" asset catalog image resource.
    static let zenWall56 = ImageResource(name: "zen_wall56", bundle: resourceBundle)

    /// The "zen_wall57" asset catalog image resource.
    static let zenWall57 = ImageResource(name: "zen_wall57", bundle: resourceBundle)

    /// The "zen_wall58" asset catalog image resource.
    static let zenWall58 = ImageResource(name: "zen_wall58", bundle: resourceBundle)

    /// The "zen_wall59" asset catalog image resource.
    static let zenWall59 = ImageResource(name: "zen_wall59", bundle: resourceBundle)

    /// The "zen_wall6" asset catalog image resource.
    static let zenWall6 = ImageResource(name: "zen_wall6", bundle: resourceBundle)

    /// The "zen_wall60" asset catalog image resource.
    static let zenWall60 = ImageResource(name: "zen_wall60", bundle: resourceBundle)

    /// The "zen_wall61" asset catalog image resource.
    static let zenWall61 = ImageResource(name: "zen_wall61", bundle: resourceBundle)

    /// The "zen_wall62" asset catalog image resource.
    static let zenWall62 = ImageResource(name: "zen_wall62", bundle: resourceBundle)

    /// The "zen_wall63" asset catalog image resource.
    static let zenWall63 = ImageResource(name: "zen_wall63", bundle: resourceBundle)

    /// The "zen_wall64" asset catalog image resource.
    static let zenWall64 = ImageResource(name: "zen_wall64", bundle: resourceBundle)

    /// The "zen_wall65" asset catalog image resource.
    static let zenWall65 = ImageResource(name: "zen_wall65", bundle: resourceBundle)

    /// The "zen_wall7" asset catalog image resource.
    static let zenWall7 = ImageResource(name: "zen_wall7", bundle: resourceBundle)

    /// The "zen_wall8" asset catalog image resource.
    static let zenWall8 = ImageResource(name: "zen_wall8", bundle: resourceBundle)

    /// The "zen_wall9" asset catalog image resource.
    static let zenWall9 = ImageResource(name: "zen_wall9", bundle: resourceBundle)

}

// MARK: - Color Symbol Extensions -

#if canImport(AppKit)
@available(macOS 10.13, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

}
#endif

// MARK: - Image Symbol Extensions -

#if canImport(AppKit)
@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    /// The "banner_cover0" asset catalog image.
    static var bannerCover0: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .bannerCover0)
#else
        .init()
#endif
    }

    /// The "banner_cover1" asset catalog image.
    static var bannerCover1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .bannerCover1)
#else
        .init()
#endif
    }

    /// The "banner_cover10" asset catalog image.
    static var bannerCover10: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .bannerCover10)
#else
        .init()
#endif
    }

    /// The "banner_cover11" asset catalog image.
    static var bannerCover11: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .bannerCover11)
#else
        .init()
#endif
    }

    /// The "banner_cover12" asset catalog image.
    static var bannerCover12: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .bannerCover12)
#else
        .init()
#endif
    }

    /// The "banner_cover13" asset catalog image.
    static var bannerCover13: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .bannerCover13)
#else
        .init()
#endif
    }

    /// The "banner_cover14" asset catalog image.
    static var bannerCover14: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .bannerCover14)
#else
        .init()
#endif
    }

    /// The "banner_cover15" asset catalog image.
    static var bannerCover15: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .bannerCover15)
#else
        .init()
#endif
    }

    /// The "banner_cover16" asset catalog image.
    static var bannerCover16: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .bannerCover16)
#else
        .init()
#endif
    }

    /// The "banner_cover17" asset catalog image.
    static var bannerCover17: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .bannerCover17)
#else
        .init()
#endif
    }

    /// The "banner_cover18" asset catalog image.
    static var bannerCover18: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .bannerCover18)
#else
        .init()
#endif
    }

    /// The "banner_cover19" asset catalog image.
    static var bannerCover19: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .bannerCover19)
#else
        .init()
#endif
    }

    /// The "banner_cover2" asset catalog image.
    static var bannerCover2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .bannerCover2)
#else
        .init()
#endif
    }

    /// The "banner_cover3" asset catalog image.
    static var bannerCover3: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .bannerCover3)
#else
        .init()
#endif
    }

    /// The "banner_cover4" asset catalog image.
    static var bannerCover4: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .bannerCover4)
#else
        .init()
#endif
    }

    /// The "banner_cover5" asset catalog image.
    static var bannerCover5: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .bannerCover5)
#else
        .init()
#endif
    }

    /// The "banner_cover6" asset catalog image.
    static var bannerCover6: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .bannerCover6)
#else
        .init()
#endif
    }

    /// The "banner_cover7" asset catalog image.
    static var bannerCover7: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .bannerCover7)
#else
        .init()
#endif
    }

    /// The "banner_cover8" asset catalog image.
    static var bannerCover8: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .bannerCover8)
#else
        .init()
#endif
    }

    /// The "banner_cover9" asset catalog image.
    static var bannerCover9: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .bannerCover9)
#else
        .init()
#endif
    }

    /// The "breathe" asset catalog image.
    static var breathe: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .breathe)
#else
        .init()
#endif
    }

    /// The "cover0" asset catalog image.
    static var cover0: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cover0)
#else
        .init()
#endif
    }

    /// The "cover1" asset catalog image.
    static var cover1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cover1)
#else
        .init()
#endif
    }

    /// The "cover10" asset catalog image.
    static var cover10: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cover10)
#else
        .init()
#endif
    }

    /// The "cover11" asset catalog image.
    static var cover11: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cover11)
#else
        .init()
#endif
    }

    /// The "cover12" asset catalog image.
    static var cover12: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cover12)
#else
        .init()
#endif
    }

    /// The "cover13" asset catalog image.
    static var cover13: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cover13)
#else
        .init()
#endif
    }

    /// The "cover14" asset catalog image.
    static var cover14: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cover14)
#else
        .init()
#endif
    }

    /// The "cover15" asset catalog image.
    static var cover15: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cover15)
#else
        .init()
#endif
    }

    /// The "cover16" asset catalog image.
    static var cover16: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cover16)
#else
        .init()
#endif
    }

    /// The "cover17" asset catalog image.
    static var cover17: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cover17)
#else
        .init()
#endif
    }

    /// The "cover18" asset catalog image.
    static var cover18: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cover18)
#else
        .init()
#endif
    }

    /// The "cover19" asset catalog image.
    static var cover19: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cover19)
#else
        .init()
#endif
    }

    /// The "cover2" asset catalog image.
    static var cover2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cover2)
#else
        .init()
#endif
    }

    /// The "cover3" asset catalog image.
    static var cover3: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cover3)
#else
        .init()
#endif
    }

    /// The "cover4" asset catalog image.
    static var cover4: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cover4)
#else
        .init()
#endif
    }

    /// The "cover5" asset catalog image.
    static var cover5: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cover5)
#else
        .init()
#endif
    }

    /// The "cover6" asset catalog image.
    static var cover6: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cover6)
#else
        .init()
#endif
    }

    /// The "cover7" asset catalog image.
    static var cover7: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cover7)
#else
        .init()
#endif
    }

    /// The "cover8" asset catalog image.
    static var cover8: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cover8)
#else
        .init()
#endif
    }

    /// The "cover9" asset catalog image.
    static var cover9: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .cover9)
#else
        .init()
#endif
    }

    /// The "enmotion" asset catalog image.
    static var enmotion: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .enmotion)
#else
        .init()
#endif
    }

    /// The "meditation" asset catalog image.
    static var meditation: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .meditation)
#else
        .init()
#endif
    }

    /// The "zen_wall0" asset catalog image.
    static var zenWall0: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall0)
#else
        .init()
#endif
    }

    /// The "zen_wall1" asset catalog image.
    static var zenWall1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall1)
#else
        .init()
#endif
    }

    /// The "zen_wall10" asset catalog image.
    static var zenWall10: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall10)
#else
        .init()
#endif
    }

    /// The "zen_wall11" asset catalog image.
    static var zenWall11: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall11)
#else
        .init()
#endif
    }

    /// The "zen_wall12" asset catalog image.
    static var zenWall12: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall12)
#else
        .init()
#endif
    }

    /// The "zen_wall13" asset catalog image.
    static var zenWall13: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall13)
#else
        .init()
#endif
    }

    /// The "zen_wall14" asset catalog image.
    static var zenWall14: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall14)
#else
        .init()
#endif
    }

    /// The "zen_wall15" asset catalog image.
    static var zenWall15: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall15)
#else
        .init()
#endif
    }

    /// The "zen_wall16" asset catalog image.
    static var zenWall16: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall16)
#else
        .init()
#endif
    }

    /// The "zen_wall17" asset catalog image.
    static var zenWall17: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall17)
#else
        .init()
#endif
    }

    /// The "zen_wall18" asset catalog image.
    static var zenWall18: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall18)
#else
        .init()
#endif
    }

    /// The "zen_wall19" asset catalog image.
    static var zenWall19: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall19)
#else
        .init()
#endif
    }

    /// The "zen_wall2" asset catalog image.
    static var zenWall2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall2)
#else
        .init()
#endif
    }

    /// The "zen_wall20" asset catalog image.
    static var zenWall20: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall20)
#else
        .init()
#endif
    }

    /// The "zen_wall21" asset catalog image.
    static var zenWall21: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall21)
#else
        .init()
#endif
    }

    /// The "zen_wall22" asset catalog image.
    static var zenWall22: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall22)
#else
        .init()
#endif
    }

    /// The "zen_wall23" asset catalog image.
    static var zenWall23: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall23)
#else
        .init()
#endif
    }

    /// The "zen_wall24" asset catalog image.
    static var zenWall24: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall24)
#else
        .init()
#endif
    }

    /// The "zen_wall25" asset catalog image.
    static var zenWall25: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall25)
#else
        .init()
#endif
    }

    /// The "zen_wall26" asset catalog image.
    static var zenWall26: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall26)
#else
        .init()
#endif
    }

    /// The "zen_wall27" asset catalog image.
    static var zenWall27: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall27)
#else
        .init()
#endif
    }

    /// The "zen_wall28" asset catalog image.
    static var zenWall28: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall28)
#else
        .init()
#endif
    }

    /// The "zen_wall29" asset catalog image.
    static var zenWall29: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall29)
#else
        .init()
#endif
    }

    /// The "zen_wall3" asset catalog image.
    static var zenWall3: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall3)
#else
        .init()
#endif
    }

    /// The "zen_wall30" asset catalog image.
    static var zenWall30: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall30)
#else
        .init()
#endif
    }

    /// The "zen_wall31" asset catalog image.
    static var zenWall31: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall31)
#else
        .init()
#endif
    }

    /// The "zen_wall32" asset catalog image.
    static var zenWall32: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall32)
#else
        .init()
#endif
    }

    /// The "zen_wall33" asset catalog image.
    static var zenWall33: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall33)
#else
        .init()
#endif
    }

    /// The "zen_wall34" asset catalog image.
    static var zenWall34: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall34)
#else
        .init()
#endif
    }

    /// The "zen_wall35" asset catalog image.
    static var zenWall35: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall35)
#else
        .init()
#endif
    }

    /// The "zen_wall36" asset catalog image.
    static var zenWall36: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall36)
#else
        .init()
#endif
    }

    /// The "zen_wall37" asset catalog image.
    static var zenWall37: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall37)
#else
        .init()
#endif
    }

    /// The "zen_wall38" asset catalog image.
    static var zenWall38: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall38)
#else
        .init()
#endif
    }

    /// The "zen_wall39" asset catalog image.
    static var zenWall39: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall39)
#else
        .init()
#endif
    }

    /// The "zen_wall4" asset catalog image.
    static var zenWall4: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall4)
#else
        .init()
#endif
    }

    /// The "zen_wall40" asset catalog image.
    static var zenWall40: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall40)
#else
        .init()
#endif
    }

    /// The "zen_wall41" asset catalog image.
    static var zenWall41: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall41)
#else
        .init()
#endif
    }

    /// The "zen_wall42" asset catalog image.
    static var zenWall42: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall42)
#else
        .init()
#endif
    }

    /// The "zen_wall43" asset catalog image.
    static var zenWall43: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall43)
#else
        .init()
#endif
    }

    /// The "zen_wall44" asset catalog image.
    static var zenWall44: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall44)
#else
        .init()
#endif
    }

    /// The "zen_wall45" asset catalog image.
    static var zenWall45: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall45)
#else
        .init()
#endif
    }

    /// The "zen_wall46" asset catalog image.
    static var zenWall46: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall46)
#else
        .init()
#endif
    }

    /// The "zen_wall47" asset catalog image.
    static var zenWall47: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall47)
#else
        .init()
#endif
    }

    /// The "zen_wall48" asset catalog image.
    static var zenWall48: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall48)
#else
        .init()
#endif
    }

    /// The "zen_wall49" asset catalog image.
    static var zenWall49: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall49)
#else
        .init()
#endif
    }

    /// The "zen_wall5" asset catalog image.
    static var zenWall5: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall5)
#else
        .init()
#endif
    }

    /// The "zen_wall50" asset catalog image.
    static var zenWall50: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall50)
#else
        .init()
#endif
    }

    /// The "zen_wall51" asset catalog image.
    static var zenWall51: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall51)
#else
        .init()
#endif
    }

    /// The "zen_wall52" asset catalog image.
    static var zenWall52: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall52)
#else
        .init()
#endif
    }

    /// The "zen_wall53" asset catalog image.
    static var zenWall53: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall53)
#else
        .init()
#endif
    }

    /// The "zen_wall54" asset catalog image.
    static var zenWall54: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall54)
#else
        .init()
#endif
    }

    /// The "zen_wall55" asset catalog image.
    static var zenWall55: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall55)
#else
        .init()
#endif
    }

    /// The "zen_wall56" asset catalog image.
    static var zenWall56: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall56)
#else
        .init()
#endif
    }

    /// The "zen_wall57" asset catalog image.
    static var zenWall57: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall57)
#else
        .init()
#endif
    }

    /// The "zen_wall58" asset catalog image.
    static var zenWall58: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall58)
#else
        .init()
#endif
    }

    /// The "zen_wall59" asset catalog image.
    static var zenWall59: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall59)
#else
        .init()
#endif
    }

    /// The "zen_wall6" asset catalog image.
    static var zenWall6: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall6)
#else
        .init()
#endif
    }

    /// The "zen_wall60" asset catalog image.
    static var zenWall60: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall60)
#else
        .init()
#endif
    }

    /// The "zen_wall61" asset catalog image.
    static var zenWall61: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall61)
#else
        .init()
#endif
    }

    /// The "zen_wall62" asset catalog image.
    static var zenWall62: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall62)
#else
        .init()
#endif
    }

    /// The "zen_wall63" asset catalog image.
    static var zenWall63: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall63)
#else
        .init()
#endif
    }

    /// The "zen_wall64" asset catalog image.
    static var zenWall64: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall64)
#else
        .init()
#endif
    }

    /// The "zen_wall65" asset catalog image.
    static var zenWall65: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall65)
#else
        .init()
#endif
    }

    /// The "zen_wall7" asset catalog image.
    static var zenWall7: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall7)
#else
        .init()
#endif
    }

    /// The "zen_wall8" asset catalog image.
    static var zenWall8: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall8)
#else
        .init()
#endif
    }

    /// The "zen_wall9" asset catalog image.
    static var zenWall9: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .zenWall9)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// The "banner_cover0" asset catalog image.
    static var bannerCover0: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .bannerCover0)
#else
        .init()
#endif
    }

    /// The "banner_cover1" asset catalog image.
    static var bannerCover1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .bannerCover1)
#else
        .init()
#endif
    }

    /// The "banner_cover10" asset catalog image.
    static var bannerCover10: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .bannerCover10)
#else
        .init()
#endif
    }

    /// The "banner_cover11" asset catalog image.
    static var bannerCover11: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .bannerCover11)
#else
        .init()
#endif
    }

    /// The "banner_cover12" asset catalog image.
    static var bannerCover12: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .bannerCover12)
#else
        .init()
#endif
    }

    /// The "banner_cover13" asset catalog image.
    static var bannerCover13: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .bannerCover13)
#else
        .init()
#endif
    }

    /// The "banner_cover14" asset catalog image.
    static var bannerCover14: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .bannerCover14)
#else
        .init()
#endif
    }

    /// The "banner_cover15" asset catalog image.
    static var bannerCover15: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .bannerCover15)
#else
        .init()
#endif
    }

    /// The "banner_cover16" asset catalog image.
    static var bannerCover16: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .bannerCover16)
#else
        .init()
#endif
    }

    /// The "banner_cover17" asset catalog image.
    static var bannerCover17: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .bannerCover17)
#else
        .init()
#endif
    }

    /// The "banner_cover18" asset catalog image.
    static var bannerCover18: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .bannerCover18)
#else
        .init()
#endif
    }

    /// The "banner_cover19" asset catalog image.
    static var bannerCover19: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .bannerCover19)
#else
        .init()
#endif
    }

    /// The "banner_cover2" asset catalog image.
    static var bannerCover2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .bannerCover2)
#else
        .init()
#endif
    }

    /// The "banner_cover3" asset catalog image.
    static var bannerCover3: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .bannerCover3)
#else
        .init()
#endif
    }

    /// The "banner_cover4" asset catalog image.
    static var bannerCover4: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .bannerCover4)
#else
        .init()
#endif
    }

    /// The "banner_cover5" asset catalog image.
    static var bannerCover5: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .bannerCover5)
#else
        .init()
#endif
    }

    /// The "banner_cover6" asset catalog image.
    static var bannerCover6: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .bannerCover6)
#else
        .init()
#endif
    }

    /// The "banner_cover7" asset catalog image.
    static var bannerCover7: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .bannerCover7)
#else
        .init()
#endif
    }

    /// The "banner_cover8" asset catalog image.
    static var bannerCover8: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .bannerCover8)
#else
        .init()
#endif
    }

    /// The "banner_cover9" asset catalog image.
    static var bannerCover9: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .bannerCover9)
#else
        .init()
#endif
    }

    /// The "breathe" asset catalog image.
    static var breathe: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .breathe)
#else
        .init()
#endif
    }

    /// The "cover0" asset catalog image.
    static var cover0: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cover0)
#else
        .init()
#endif
    }

    /// The "cover1" asset catalog image.
    static var cover1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cover1)
#else
        .init()
#endif
    }

    /// The "cover10" asset catalog image.
    static var cover10: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cover10)
#else
        .init()
#endif
    }

    /// The "cover11" asset catalog image.
    static var cover11: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cover11)
#else
        .init()
#endif
    }

    /// The "cover12" asset catalog image.
    static var cover12: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cover12)
#else
        .init()
#endif
    }

    /// The "cover13" asset catalog image.
    static var cover13: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cover13)
#else
        .init()
#endif
    }

    /// The "cover14" asset catalog image.
    static var cover14: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cover14)
#else
        .init()
#endif
    }

    /// The "cover15" asset catalog image.
    static var cover15: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cover15)
#else
        .init()
#endif
    }

    /// The "cover16" asset catalog image.
    static var cover16: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cover16)
#else
        .init()
#endif
    }

    /// The "cover17" asset catalog image.
    static var cover17: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cover17)
#else
        .init()
#endif
    }

    /// The "cover18" asset catalog image.
    static var cover18: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cover18)
#else
        .init()
#endif
    }

    /// The "cover19" asset catalog image.
    static var cover19: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cover19)
#else
        .init()
#endif
    }

    /// The "cover2" asset catalog image.
    static var cover2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cover2)
#else
        .init()
#endif
    }

    /// The "cover3" asset catalog image.
    static var cover3: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cover3)
#else
        .init()
#endif
    }

    /// The "cover4" asset catalog image.
    static var cover4: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cover4)
#else
        .init()
#endif
    }

    /// The "cover5" asset catalog image.
    static var cover5: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cover5)
#else
        .init()
#endif
    }

    /// The "cover6" asset catalog image.
    static var cover6: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cover6)
#else
        .init()
#endif
    }

    /// The "cover7" asset catalog image.
    static var cover7: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cover7)
#else
        .init()
#endif
    }

    /// The "cover8" asset catalog image.
    static var cover8: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cover8)
#else
        .init()
#endif
    }

    /// The "cover9" asset catalog image.
    static var cover9: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .cover9)
#else
        .init()
#endif
    }

    /// The "enmotion" asset catalog image.
    static var enmotion: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .enmotion)
#else
        .init()
#endif
    }

    /// The "meditation" asset catalog image.
    static var meditation: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .meditation)
#else
        .init()
#endif
    }

    /// The "zen_wall0" asset catalog image.
    static var zenWall0: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall0)
#else
        .init()
#endif
    }

    /// The "zen_wall1" asset catalog image.
    static var zenWall1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall1)
#else
        .init()
#endif
    }

    /// The "zen_wall10" asset catalog image.
    static var zenWall10: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall10)
#else
        .init()
#endif
    }

    /// The "zen_wall11" asset catalog image.
    static var zenWall11: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall11)
#else
        .init()
#endif
    }

    /// The "zen_wall12" asset catalog image.
    static var zenWall12: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall12)
#else
        .init()
#endif
    }

    /// The "zen_wall13" asset catalog image.
    static var zenWall13: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall13)
#else
        .init()
#endif
    }

    /// The "zen_wall14" asset catalog image.
    static var zenWall14: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall14)
#else
        .init()
#endif
    }

    /// The "zen_wall15" asset catalog image.
    static var zenWall15: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall15)
#else
        .init()
#endif
    }

    /// The "zen_wall16" asset catalog image.
    static var zenWall16: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall16)
#else
        .init()
#endif
    }

    /// The "zen_wall17" asset catalog image.
    static var zenWall17: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall17)
#else
        .init()
#endif
    }

    /// The "zen_wall18" asset catalog image.
    static var zenWall18: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall18)
#else
        .init()
#endif
    }

    /// The "zen_wall19" asset catalog image.
    static var zenWall19: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall19)
#else
        .init()
#endif
    }

    /// The "zen_wall2" asset catalog image.
    static var zenWall2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall2)
#else
        .init()
#endif
    }

    /// The "zen_wall20" asset catalog image.
    static var zenWall20: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall20)
#else
        .init()
#endif
    }

    /// The "zen_wall21" asset catalog image.
    static var zenWall21: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall21)
#else
        .init()
#endif
    }

    /// The "zen_wall22" asset catalog image.
    static var zenWall22: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall22)
#else
        .init()
#endif
    }

    /// The "zen_wall23" asset catalog image.
    static var zenWall23: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall23)
#else
        .init()
#endif
    }

    /// The "zen_wall24" asset catalog image.
    static var zenWall24: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall24)
#else
        .init()
#endif
    }

    /// The "zen_wall25" asset catalog image.
    static var zenWall25: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall25)
#else
        .init()
#endif
    }

    /// The "zen_wall26" asset catalog image.
    static var zenWall26: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall26)
#else
        .init()
#endif
    }

    /// The "zen_wall27" asset catalog image.
    static var zenWall27: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall27)
#else
        .init()
#endif
    }

    /// The "zen_wall28" asset catalog image.
    static var zenWall28: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall28)
#else
        .init()
#endif
    }

    /// The "zen_wall29" asset catalog image.
    static var zenWall29: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall29)
#else
        .init()
#endif
    }

    /// The "zen_wall3" asset catalog image.
    static var zenWall3: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall3)
#else
        .init()
#endif
    }

    /// The "zen_wall30" asset catalog image.
    static var zenWall30: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall30)
#else
        .init()
#endif
    }

    /// The "zen_wall31" asset catalog image.
    static var zenWall31: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall31)
#else
        .init()
#endif
    }

    /// The "zen_wall32" asset catalog image.
    static var zenWall32: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall32)
#else
        .init()
#endif
    }

    /// The "zen_wall33" asset catalog image.
    static var zenWall33: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall33)
#else
        .init()
#endif
    }

    /// The "zen_wall34" asset catalog image.
    static var zenWall34: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall34)
#else
        .init()
#endif
    }

    /// The "zen_wall35" asset catalog image.
    static var zenWall35: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall35)
#else
        .init()
#endif
    }

    /// The "zen_wall36" asset catalog image.
    static var zenWall36: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall36)
#else
        .init()
#endif
    }

    /// The "zen_wall37" asset catalog image.
    static var zenWall37: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall37)
#else
        .init()
#endif
    }

    /// The "zen_wall38" asset catalog image.
    static var zenWall38: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall38)
#else
        .init()
#endif
    }

    /// The "zen_wall39" asset catalog image.
    static var zenWall39: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall39)
#else
        .init()
#endif
    }

    /// The "zen_wall4" asset catalog image.
    static var zenWall4: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall4)
#else
        .init()
#endif
    }

    /// The "zen_wall40" asset catalog image.
    static var zenWall40: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall40)
#else
        .init()
#endif
    }

    /// The "zen_wall41" asset catalog image.
    static var zenWall41: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall41)
#else
        .init()
#endif
    }

    /// The "zen_wall42" asset catalog image.
    static var zenWall42: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall42)
#else
        .init()
#endif
    }

    /// The "zen_wall43" asset catalog image.
    static var zenWall43: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall43)
#else
        .init()
#endif
    }

    /// The "zen_wall44" asset catalog image.
    static var zenWall44: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall44)
#else
        .init()
#endif
    }

    /// The "zen_wall45" asset catalog image.
    static var zenWall45: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall45)
#else
        .init()
#endif
    }

    /// The "zen_wall46" asset catalog image.
    static var zenWall46: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall46)
#else
        .init()
#endif
    }

    /// The "zen_wall47" asset catalog image.
    static var zenWall47: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall47)
#else
        .init()
#endif
    }

    /// The "zen_wall48" asset catalog image.
    static var zenWall48: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall48)
#else
        .init()
#endif
    }

    /// The "zen_wall49" asset catalog image.
    static var zenWall49: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall49)
#else
        .init()
#endif
    }

    /// The "zen_wall5" asset catalog image.
    static var zenWall5: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall5)
#else
        .init()
#endif
    }

    /// The "zen_wall50" asset catalog image.
    static var zenWall50: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall50)
#else
        .init()
#endif
    }

    /// The "zen_wall51" asset catalog image.
    static var zenWall51: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall51)
#else
        .init()
#endif
    }

    /// The "zen_wall52" asset catalog image.
    static var zenWall52: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall52)
#else
        .init()
#endif
    }

    /// The "zen_wall53" asset catalog image.
    static var zenWall53: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall53)
#else
        .init()
#endif
    }

    /// The "zen_wall54" asset catalog image.
    static var zenWall54: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall54)
#else
        .init()
#endif
    }

    /// The "zen_wall55" asset catalog image.
    static var zenWall55: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall55)
#else
        .init()
#endif
    }

    /// The "zen_wall56" asset catalog image.
    static var zenWall56: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall56)
#else
        .init()
#endif
    }

    /// The "zen_wall57" asset catalog image.
    static var zenWall57: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall57)
#else
        .init()
#endif
    }

    /// The "zen_wall58" asset catalog image.
    static var zenWall58: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall58)
#else
        .init()
#endif
    }

    /// The "zen_wall59" asset catalog image.
    static var zenWall59: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall59)
#else
        .init()
#endif
    }

    /// The "zen_wall6" asset catalog image.
    static var zenWall6: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall6)
#else
        .init()
#endif
    }

    /// The "zen_wall60" asset catalog image.
    static var zenWall60: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall60)
#else
        .init()
#endif
    }

    /// The "zen_wall61" asset catalog image.
    static var zenWall61: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall61)
#else
        .init()
#endif
    }

    /// The "zen_wall62" asset catalog image.
    static var zenWall62: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall62)
#else
        .init()
#endif
    }

    /// The "zen_wall63" asset catalog image.
    static var zenWall63: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall63)
#else
        .init()
#endif
    }

    /// The "zen_wall64" asset catalog image.
    static var zenWall64: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall64)
#else
        .init()
#endif
    }

    /// The "zen_wall65" asset catalog image.
    static var zenWall65: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall65)
#else
        .init()
#endif
    }

    /// The "zen_wall7" asset catalog image.
    static var zenWall7: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall7)
#else
        .init()
#endif
    }

    /// The "zen_wall8" asset catalog image.
    static var zenWall8: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall8)
#else
        .init()
#endif
    }

    /// The "zen_wall9" asset catalog image.
    static var zenWall9: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .zenWall9)
#else
        .init()
#endif
    }

}
#endif

// MARK: - Thinnable Asset Support -

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
@available(watchOS, unavailable)
extension ColorResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if AppKit.NSColor(named: NSColor.Name(thinnableName), bundle: bundle) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIColor(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    private convenience init?(thinnableResource: ColorResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

    private init?(thinnableResource: ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    private init?(thinnableResource: ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}
#endif

@available(iOS 11.0, macOS 10.7, tvOS 11.0, *)
@available(watchOS, unavailable)
extension ImageResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if bundle.image(forResource: NSImage.Name(thinnableName)) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIImage(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    private convenience init?(thinnableResource: ImageResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    private convenience init?(thinnableResource: ImageResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

// MARK: - Backwards Deployment Support -

/// A color resource.
struct ColorResource: Swift.Hashable, Swift.Sendable {

    /// An asset catalog color resource name.
    fileprivate let name: Swift.String

    /// An asset catalog color resource bundle.
    fileprivate let bundle: Foundation.Bundle

    /// Initialize a `ColorResource` with `name` and `bundle`.
    init(name: Swift.String, bundle: Foundation.Bundle) {
        self.name = name
        self.bundle = bundle
    }

}

/// An image resource.
struct ImageResource: Swift.Hashable, Swift.Sendable {

    /// An asset catalog image resource name.
    fileprivate let name: Swift.String

    /// An asset catalog image resource bundle.
    fileprivate let bundle: Foundation.Bundle

    /// Initialize an `ImageResource` with `name` and `bundle`.
    init(name: Swift.String, bundle: Foundation.Bundle) {
        self.name = name
        self.bundle = bundle
    }

}

#if canImport(AppKit)
@available(macOS 10.13, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    /// Initialize a `NSColor` with a color resource.
    convenience init(resource: ColorResource) {
        self.init(named: NSColor.Name(resource.name), bundle: resource.bundle)!
    }

}

protocol _ACResourceInitProtocol {}
extension AppKit.NSImage: _ACResourceInitProtocol {}

@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension _ACResourceInitProtocol {

    /// Initialize a `NSImage` with an image resource.
    init(resource: ImageResource) {
        self = resource.bundle.image(forResource: NSImage.Name(resource.name))! as! Self
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    /// Initialize a `UIColor` with a color resource.
    convenience init(resource: ColorResource) {
#if !os(watchOS)
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
#else
        self.init()
#endif
    }

}

@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// Initialize a `UIImage` with an image resource.
    convenience init(resource: ImageResource) {
#if !os(watchOS)
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
#else
        self.init()
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

    /// Initialize a `Color` with a color resource.
    init(_ resource: ColorResource) {
        self.init(resource.name, bundle: resource.bundle)
    }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Image {

    /// Initialize an `Image` with an image resource.
    init(_ resource: ImageResource) {
        self.init(resource.name, bundle: resource.bundle)
    }

}
#endif