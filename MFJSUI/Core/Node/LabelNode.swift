//
//  LabelNode.swift
//  MFJSUI
//
//  Created by Jialin MacMini on 2025/1/14.
//

import UIKit

class LabelNode: ViewNode {
    
    /// 支持数据绑定，动态更新
    @objc dynamic var adjustsFontSizeToFitWidth: MFBoolAny?
    @objc dynamic var text: String?
    @objc dynamic var textColor: String?
    @objc dynamic var font: String?
    @objc dynamic var textAlignment: String?
    @objc dynamic var numberOfLines: MFIntAny?
    @objc dynamic var lineBreakMode: String?
    var attributedText: AttributedStringNode?
    @objc dynamic var attributedChangeFlag: Int = 0
    
    override func createView(bindData: Any?, superView: UIView) -> UIView {
        return UILabel.mf_createView(with: self, bindData: bindData, superView: superView)
    }
    
    override func dataBind(with bindData: Any?) {
        super.dataBind(with: bindData)
        
        for item in MFLabelPropertyName.allCases {
            addKVO(with: item.rawValue)
        }
    }
    
    override func value(with key: String) -> Any? {
        guard let enum1 = MFLabelPropertyName(rawValue: key) else { return super.value(with: key) }
        switch enum1 {
        case .adjustsFontSizeToFitWidth:
            return adjustsFontSizeToFitWidth
        case .text:
            return text
        case .textColor:
            return textColor
        case .font:
            return font
        case .textAlignment:
            return textAlignment
        case .numberOfLines:
            return numberOfLines
        case .lineBreakMode:
            return lineBreakMode
        case .attributedText:
            return attributedText
        }
    }
    
    override func dataChange(with key: String, value: Any?) {
        guard let enum1 = MFLabelPropertyName(rawValue: key) else {
            super.dataChange(with: key, value: value)
            return
        }
        switch enum1 {
        case .adjustsFontSizeToFitWidth:
            adjustsFontSizeToFitWidth = value
        case .text:
            text = value as? String
        case .textColor:
            textColor = value as? String
        case .font:
            font = value as? String
        case .textAlignment:
            textAlignment = value as? String
        case .numberOfLines:
            numberOfLines = value
        case .lineBreakMode:
            lineBreakMode = value as? String
        case .attributedText:
            attributedChangeFlag += 1
        }
    }
    
    override func extendAddKVO(with key: String) {
        super.extendAddKVO(with: key)
        
        if key == "attributedText" {
            guard let attributedText else { return }
            var waitToBindInfo: [(String, String)] = []
            if let text = attributedText.text {
                if text.hasPrefix("${") && text.hasSuffix("}") {
                    // 绑定到attributedText字段
                    waitToBindInfo.append((text, "attributedText_text"))
                }
            }
            if let textColor = attributedText.textColor {
                if textColor.hasPrefix("${") && textColor.hasSuffix("}") {
                    // 绑定到attributedText字段
                    waitToBindInfo.append((textColor, "attributedText_textColor"))
                }
            }
            if let font = attributedText.font {
                if font.hasPrefix("${") && font.hasSuffix("}") {
                    // 绑定到attributedText字段
                    waitToBindInfo.append((font, "attributedText_font"))
                }
            }
            if let lineSpacing = attributedText.lineSpacing as? String {
                if lineSpacing.hasPrefix("${") && lineSpacing.hasSuffix("}") {
                    // 绑定到attributedText字段
                    waitToBindInfo.append((lineSpacing, "attributedText_lineSpacing"))
                }
            }
            if let highlights = attributedText.highlights {
                for highlight in highlights {
                    if let text = highlight.text {
                        if text.hasPrefix("${") && text.hasSuffix("}") {
                            // 绑定到attributedText字段
                            waitToBindInfo.append((text, "attributedTextHightlight_text"))
                        }
                    }
                    if let location = highlight.location as? String {
                        if location.hasPrefix("${") && location.hasSuffix("}") {
                            // 绑定到attributedText字段
                            waitToBindInfo.append((location, "attributedTextHightlight_location"))
                        }
                    }
                    if let length = highlight.length as? String {
                        if length.hasPrefix("${") && length.hasSuffix("}") {
                            // 绑定到attributedText字段
                            waitToBindInfo.append((length, "attributedTextHightlight_length"))
                        }
                    }
                    if let textColor = highlight.textColor {
                        if textColor.hasPrefix("${") && textColor.hasSuffix("}") {
                            // 绑定到attributedText字段
                            waitToBindInfo.append((textColor, "attributedTextHightlight_textColor"))
                        }
                    }
                    if let font = highlight.font {
                        if font.hasPrefix("${") && font.hasSuffix("}") {
                            // 绑定到attributedText字段
                            waitToBindInfo.append((font, "attributedTextHightlight_font"))
                        }
                    }
                }
            }
            
            for info in waitToBindInfo {
                print(info.0)
                guard let object = bindData as? NSObject else { return }
                // 获取参数
                var pat = info.0.subString(start: 2, count: info.0.count-3)
                if pat.hasPrefix("data.") {
                    pat = pat.subString(start: 5, count: pat.count-5)
                }
                guard let kvoInfo = MFJSUITool.parentObject(for: pat, in: object) else { return }
                if observerInfo[kvoInfo.1] != nil {
                    continue
                }
                kvoInfo.0.addObserver(self, forKeyPath: kvoInfo.1, options: .new, context: nil)
                observerInfo.updateValue(kvoInfo.0, forKey: kvoInfo.1)
                // 扩展KVO字段
                extentKeyMap.updateValue("attributedText", forKey: kvoInfo.1)
            }
        }
    }
}
