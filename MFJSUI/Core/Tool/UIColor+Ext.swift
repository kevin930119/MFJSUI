//
//  UIColor+Ext.swift
//  MFJSUI
//
//  Created by Jialin MacMini on 2025/1/24.
//

import UIKit

extension UIColor {
    static func colorHexString(_ hexString: String) -> UIColor {
        var resultHexString: String = "000000"
        if hexString.hasPrefix("0x") {
            resultHexString = hexString.subString(from: 2)
        } else if hexString.hasPrefix("#") {
            resultHexString = hexString.subString(from: 1)
        } else {
            resultHexString = hexString
        }
        
        if resultHexString.count < 6 {
            return UIColor.black
        }
        
        let scanner = Scanner(string: resultHexString)
        var hexInt: UInt64 = 0x000000
        scanner.scanHexInt64(&hexInt)
        
        if resultHexString.count == 6 {
            let r = (hexInt & 0x00FF0000) >> 16;
            let g = (hexInt & 0x0000FF00) >> 8;
            let b = (hexInt & 0x000000FF);
            let red = CGFloat(r)/255.0;
            let green = CGFloat(g)/255.0;
            let blue = CGFloat(b)/255.0;
            return UIColor(red: red, green: green, blue: blue, alpha: 1)
        } else if resultHexString.count == 8 {
            let red = CGFloat((hexInt & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((hexInt & 0xFF00) >> 8) / 255.0
            let blue = CGFloat(hexInt & 0xFF) / 255.0
            let alpha = CGFloat((hexInt & 0xFF000000) >> 24) / 255.0
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
        
        return .black
    }
}
