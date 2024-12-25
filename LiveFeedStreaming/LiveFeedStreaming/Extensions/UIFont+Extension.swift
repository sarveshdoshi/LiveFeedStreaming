//
//  UIFont+Extension.swift
//  LiveFeedStreaming
//
//  Created by Sarvesh Doshi on 19/12/24.
//


import UIKit

extension UIFont {
    enum FontType: String {
        case regular = "SFProDisplay-Regular"
        case medium = "SFProDisplay-Medium"
        case semiBold = "SFProDisplay-SemiBold"
        case bold = "SFProDisplay-Bold"
        case extraBold = "SFProDisplay-ExtraBold"
        case light = "SFProDisplay-Light"
        case extraLight = "SFProDisplay-ExtraLight"
        case black = "SFProDisplay-Black"
        case thin = "SFProDisplay-Thin"
    }
    
    static func customFont(type: FontType, size: CGFloat) -> UIFont {
        if let font = UIFont(name: type.rawValue, size: size) {
            return font
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }
}
