//
//  UIFont+Ext.swift
//  MFJSUI
//
//  Created by Jialin MacMini on 2025/1/24.
//

import UIKit

extension UIFont {
    static func regularFont(with size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size, weight: .regular)
    }
    
    static func mediumFont(with size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size, weight: .medium)
    }
    
    static func semiboldFont(with size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size, weight: .semibold)
    }
    
    static func boldFont(with size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size, weight: .bold)
    }
    
    static func lightFont(with size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size, weight: .light)
    }
}
