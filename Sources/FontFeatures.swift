//
//  FontFeatures.swift
//
//  Created by Brian King on 8/31/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

/// Protocol to provide values to be used by UIFontFeatureTypeIdentifierKey and UIFontFeatureSelectorIdentifierKey.
public protocol FontFeatureProvider {
    func featureSettings() -> (Int, Int)
}

public extension BONFont {
    /// Create a new UIFont and attempt to enable the specified font features. The returned font will have all
    /// features enabled that are supported by the font.
    public func font(withFeatures featureProviders: [FontFeatureProvider]) -> BONFont {
        var fontAttributes = fontDescriptor.fontAttributes
        var features = fontAttributes[BONFontDescriptorFeatureSettingsAttribute] as? [StyleAttributes] ?? []
        let newFeatures = featureProviders.map() { $0.featureAttribute() }
        features.append(contentsOf: newFeatures)
        fontAttributes[BONFontDescriptorFeatureSettingsAttribute] = features
        let descriptor = BONFontDescriptor(fontAttributes: fontAttributes)
        #if os(OSX)
            return BONFont(descriptor: descriptor, size: pointSize)!
        #else
            return BONFont(descriptor: descriptor, size: pointSize)
        #endif
    }
}

/// An enumeration representing the kNumberCaseType features.
public enum NumberCase: FontFeatureProvider {
    case upper, lower
    public func featureSettings() -> (Int, Int) {
        switch self {
        case .upper:
            return (kNumberCaseType, kUpperCaseNumbersSelector)
        case .lower:
            return (kNumberCaseType, kLowerCaseNumbersSelector)
        }
    }
}

/// An enumeration representing the kNumberSpacingType features.
public enum NumberSpacing: FontFeatureProvider {
    case monospaced, proportional
    public func featureSettings() -> (Int, Int) {
        switch self {
        case .monospaced:
            return (kNumberSpacingType, kMonospacedNumbersSelector)
        case .proportional:
            return (kNumberSpacingType, kProportionalNumbersSelector)
        }
    }
}

extension FontFeatureProvider {
    /// Return a dictionary representing one feature for the attributes key in the font attributes
    func featureAttribute() -> StyleAttributes {
        let featureSettings = self.featureSettings()
        return [
            BONFontFeatureTypeIdentifierKey: featureSettings.0,
            BONFontFeatureSelectorIdentifierKey: featureSettings.1
        ]
    }
}
