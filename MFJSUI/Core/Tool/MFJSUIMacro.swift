//
//  MFJSUIMacro.swift
//  MFJSUI
//
//  Created by Jialin MacMini on 2025/1/16.
//

import UIKit
import HandyJSON

typealias MFBoolAny = Any
typealias MFIntAny = Any
typealias MFCGFloatAny = Any

enum MFContentMode: String, HandyJSONEnum {
    /// 拉伸填充满，会变形
    case scaleToFill
    /// 自适应宽高
    case scaleAspectFit
    /// 拉伸填充满，不会变形，可能会超出视图范围
    case scaleAspectFill
    
    func toViewContentMode() -> UIViewContentMode {
        if self == .scaleToFill {
            return .scaleToFill
        } else if self == .scaleAspectFit {
            return .scaleAspectFit
        }
        return .scaleAspectFill
    }
}

enum MFTextAlignment: String, HandyJSONEnum {
    case left
    case center
    case right
    
    func toTextAlignment() -> NSTextAlignment {
        if self == .left {
            return .left
        } else if self == .center {
            return .center
        }
        return .right
    }
}

enum MFLineBreakMode: String, HandyJSONEnum {
    case wordWrapping
    case charWrapping
    case clipping
    case truncatingHead
    case truncatingTail
    case truncatingMiddle
    
    func toLineBreakMode() -> NSLineBreakMode {
        if self == .wordWrapping {
            return .byWordWrapping
        } else if self == .charWrapping {
            return .byCharWrapping
        } else if self == .clipping {
            return .byClipping
        } else if self == .truncatingHead {
            return .byTruncatingHead
        } else if self == .truncatingTail {
            return .byTruncatingTail
        }
        return .byTruncatingMiddle
    }
}

// MARK: - UI控件的属性枚举
// UIView
enum MFViewPropertyName: String, CaseIterable {
    case frame,
         tag,
         clipsToBounds,
         isUserInteractionEnabled,
         isHidden,
         backgroundColor,
         alpha,
         tintColor,
         contentMode,
         layer_masksToBounds,
         layer_cornerRadius,
         layer_maskedCorners,
         layer_borderColor,
         layer_borderWidth
}

// UILabel
enum MFLabelPropertyName: String, CaseIterable {
    case adjustsFontSizeToFitWidth,
         text,
         textColor,
         font,
         textAlignment,
         numberOfLines,
         lineBreakMode,
         attributedText
}

// UIImageView
enum MFImageViewPropertyName: String, CaseIterable {
    case imageURLString
}

// UIControl
enum MFControlPropertyName: String, CaseIterable {
    case isSelected,
         isEnabled
}

// UIButton
enum MFButtonPropertyName: String, CaseIterable {
    case title,
         titleColor,
         titleFont,
         titleAlignment,
         imageName,
         backgroundImageName
}

// UIScrollView
enum MFScrollViewPropertyName: String, CaseIterable {
    case isScrollEnabled,
         bounces,
         contentInset,
         contentSize,
         isPagingEnabled
}

// UITextField
enum MFTextFieldPropertyName: String, CaseIterable {
    case text,
         textColor,
         font,
         placeholder,
         placeholderColor
}

// UITextView
enum MFTextViewPropertyName: String, CaseIterable {
    case text,
         textColor,
         font
}

// MARK: - 系统交互事件名定义
enum MFAction: String, HandyJSONEnum {
    /// UIView类
    case viewTap
    case viewDoubleTap
    case viewLongPress
    /// UIControl类
    case controlTouchUpInsize
    case controlTouchUpOutsize
    case controlTouchDown
    case controlTouchCancel
    case controlValueChanged
}

func BoolFromObject(_ object: Any, _ bindData: Any? = nil) -> Bool {
    if object is Bool {
        return object as! Bool
    }
    if let str = object as? String {
        let str = StringFromObject(str, bindData)
        let value = Bool("\(str)")
        return value ?? false
    }
    let value = Bool("\(object)")
    return value ?? false
}

func IntFromObject(_ object: Any, _ bindData: Any? = nil) -> Int {
    if object is Int {
        return object as! Int
    }
    if let str = object as? String {
        let str = StringFromObject(str, bindData)
        let value = Int(str)
        return value ?? 0
    }
    let value = Int("\(object)")
    return value ?? 0
}

func CGFloatFromObject(_ object: Any, _ bindData: Any? = nil) -> CGFloat {
    if object is CGFloat {
        return object as! CGFloat
    }
    if let str = object as? String {
        let str1 = StringFromObject(str, bindData) as NSString
        return str1.doubleValue
    }
    let valuef = Double("\(object)")
    let value1 = CGFloat(valuef ?? 0)
    return value1
}

func CGFloatFromObjectScale(_ object: Any, _ bindData: Any? = nil) -> CGFloat {
    if object is CGFloat {
        return object as! CGFloat
    }
    if let str = object as? String {
        let str = StringFromObject(str, bindData)
        let valuef = Double(str)
        if str.contains("px") {
            let value1 = CGFloat(valuef ?? 0)
            return value1
        }
        // 默认rpx
        let value1 = CGFloat(valuef ?? 0)
        return ScaleValue(value1)
    }
    let valuef = Double("\(object)")
    let value1 = CGFloat(valuef ?? 0)
    return value1
}

public func StringFromObject(_ object: Any, _ bindData: Any? = nil) -> String {
    if let object = ValueFromObject(object, bindData) {
        return "\(object)"
    }
    return "\(object)"
}

public func ValueFromObject(_ object: Any, _ bindData: Any? = nil) -> Any? {
    if let str = object as? String, let bindData {
        // 判断是否需要绑定数据
        let pattern = "\\$\\{.*?\\}"
        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            if let result = regex.firstMatch(in: str, range: NSMakeRange(0, str.utf16.count)) {
                if result.range.location != 0 || result.range.length != str.count {
                    return object
                }
                let startIndex = str.index(str.startIndex, offsetBy: result.range.location+2)
                let toIndex = str.index(str.startIndex, offsetBy: result.range.location+2+result.range.length-3)
                let range = startIndex..<toIndex
                var paramStr = str.substring(with: range)
                if paramStr.count > 0 {
                    // 去除data.前缀
                    if paramStr.hasPrefix("data.") {
                        paramStr.removeSubrange(paramStr.startIndex..<paramStr.index(paramStr.startIndex, offsetBy: 5))
                    }
                    return MFJSUITool.value(for: paramStr, in: bindData)
                }
            }
        }
        return object
    }
    return object
}

/// 屏幕适配
/// - Parameter value: 大小
/// - Returns: 适配后的大小
func ScaleValue(_ value: CGFloat) -> CGFloat {
    let k = UIScreen.main.bounds.width / 375.0
    return ceil(value * k)
}

/// 示例："{"x":2px,"y":2rpx,"width":3,"height":"${data.contentInset.right}"}"
/// JSON字符串
func CGRectFromObject(_ object: Any, _ bindData: Any? = nil) -> CGRect? {
    let str = StringFromObject(object, bindData)
    if let jsonData = str.data(using: .utf8) {
        if let dict = (try? JSONSerialization.jsonObject(with: jsonData)) as? [String:Any] {
            var frame: CGRect = .zero
            if let x = dict["x"] {
                frame.origin.x =  CGFloatFromObjectScale("\(x)", bindData)
            }
            if let y = dict["y"] {
                frame.origin.y =  CGFloatFromObjectScale("\(y)", bindData)
            }
            if let width = dict["width"] {
                frame.size.width =  CGFloatFromObjectScale("\(width)", bindData)
            }
            if let height = dict["height"] {
                frame.size.height =  CGFloatFromObjectScale("\(height)", bindData)
            }
            return frame
        }
    }
    return nil
}

/// 示例："{"top":2px,"bottom":2rpx,"left":3,"right":"${data.contentInset.right}"}"
/// JSON字符串
func ContentInsetsFromObject(object: Any, _ bindData: Any? = nil) -> UIEdgeInsets? {
    let str = StringFromObject(object, bindData)
    if let jsonData = str.data(using: .utf8) {
        if let dict = (try? JSONSerialization.jsonObject(with: jsonData)) as? [String:Any] {
            var insets: UIEdgeInsets = .zero
            if let top = dict["top"] {
                insets.top =  CGFloatFromObjectScale("\(top)", bindData)
            }
            if let bottom = dict["bottom"] {
                insets.bottom =  CGFloatFromObjectScale("\(bottom)", bindData)
            }
            if let left = dict["left"] {
                insets.left =  CGFloatFromObjectScale("\(left)", bindData)
            }
            if let right = dict["right"] {
                insets.right =  CGFloatFromObjectScale("\(right)", bindData)
            }
            return insets
        }
    }
    return nil
}

/// 示例："{"width":2px,"height":"2rpx"}"
/// JSON字符串
func ContentSizeFromObject(object: Any, _ bindData: Any? = nil) -> CGSize? {
    let str = StringFromObject(object, bindData)
    if let jsonData = str.data(using: .utf8) {
        if let dict = (try? JSONSerialization.jsonObject(with: jsonData)) as? [String:Any] {
            var size: CGSize = .zero
            if let width = dict["width"] {
                size.width =  CGFloatFromObjectScale("\(width)", bindData)
            }
            if let height = dict["height"] {
                size.height =  CGFloatFromObjectScale("\(height)", bindData)
            }
            return size
        }
    }
    return nil
}

/// 圆角角度
/// 示例："topLeft,topRight,bottomLeft,bottomRight"
func LayerCornerMaskFromObject(object: Any, _ bindData: Any? = nil) -> CACornerMask? {
    let str = StringFromObject(object, bindData)
    let arr = str.components(separatedBy: ",")
    if arr.count > 0 {
        var mask: CACornerMask = []
        for str1 in arr {
            if str1 == "topLeft" {
                mask.formUnion(.layerMinXMinYCorner)
            } else if str1 == "topRight" {
                mask.formUnion(.layerMaxXMinYCorner)
            } else if str1 == "bottomLeft" {
                mask.formUnion(.layerMinXMaxYCorner)
            } else if str1 == "bottomRight" {
                mask.formUnion(.layerMaxXMaxYCorner)
            }
        }
        return mask
    }
    return nil
}

/// 字体
/// 示例："regular,10"
func FontFromObject(object: Any, _ bindData: Any? = nil) -> UIFont? {
    let str = StringFromObject(object, bindData)
    let arr = str.components(separatedBy: ",")
    if arr.count != 2 {
        return nil
    }
    let value = CGFloatFromObjectScale(arr[1], bindData)
    let fontName = arr[0]
    if fontName == "regular" {
        return UIFont.regularFont(with: value)
    } else if fontName == "medium" {
        return UIFont.mediumFont(with: value)
    } else if fontName == "semibold" {
        return UIFont.semiboldFont(with: value)
    } else if fontName == "bold" {
        return UIFont.boldFont(with: value)
    } else if fontName == "light" {
        return UIFont.lightFont(with: value)
    }
    return MFJSUIConfigure.shared.delegate?.jsUIConfigureFont(with: fontName, size: value)
}
