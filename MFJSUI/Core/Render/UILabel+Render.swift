//
//  UILabel+Render.swift
//  MFJSUI
//
//  Created by Jialin MacMini on 2025/1/15.
//

import UIKit

extension UILabel {
    override func mf_renderSelfView(with node: ViewNode, bindData: Any?) {
        super.mf_renderSelfView(with: node, bindData: bindData)
        
        guard let node = node as? LabelNode else { return }
        for item in MFLabelPropertyName.allCases {
            self.mf_renderSelfView(with: item.rawValue, node: node, bindData: bindData)
        }
    }
    
    override func mf_renderSelfView(with key: String, node: ViewNode, bindData: Any?) {
        guard let enum1 = MFLabelPropertyName(rawValue: key) else {
            super.mf_renderSelfView(with: key, node: node, bindData: bindData)
            return
        }
        guard let node = node as? LabelNode else { return }
        switch enum1 {
        case .adjustsFontSizeToFitWidth:
            if let adjustsFontSizeToFitWidth = node.adjustsFontSizeToFitWidth {
                let flag = BoolFromObject(adjustsFontSizeToFitWidth, bindData)
                self.adjustsFontSizeToFitWidth = flag
            }
        case .text:
            if let text = node.text {
                let str = StringFromObject(text, bindData)
                self.text = str
                
                if let frame = node.frame {
                    if let rect = CGRectFromObject(frame, bindData) {
                        if rect.width == 0 || rect.height == 0 {
                            // 自适应宽高
                            self.sizeToFit()
                        }
                    }
                }
            }
        case .textColor:
            if let textColor = node.textColor {
                let str = StringFromObject(textColor, bindData)
                self.textColor = UIColor.colorHexString(str)
            }
        case .font:
            if let font = node.font {
                if let font = FontFromObject(object: font, bindData) {
                    self.font = font
                }
            }
        case .textAlignment:
            if let textAlignment = node.textAlignment {
                let str = StringFromObject(textAlignment, bindData)
                if let mode = MFTextAlignment(rawValue: str) {
                    self.textAlignment = mode.toTextAlignment()
                }
            }
        case .numberOfLines:
            if let numberOfLines = node.numberOfLines {
                let value = IntFromObject(numberOfLines, bindData)
                self.numberOfLines = value
            }
        case .lineBreakMode:
            if let lineBreakMode = node.lineBreakMode {
                let str = StringFromObject(lineBreakMode, bindData)
                if let mode = MFLineBreakMode(rawValue: str) {
                    self.lineBreakMode = mode.toLineBreakMode()
                }
            }
        case .attributedText:
            if let text = node.attributedText?.text {
                let str = StringFromObject(text, bindData)
                var attributes: [NSAttributedStringKey:Any] = [:]
                if let textColor = node.attributedText?.textColor {
                    let str = StringFromObject(textColor, bindData)
                    attributes.updateValue(UIColor.colorHexString(str), forKey: .foregroundColor)
                }
                if let font = node.attributedText?.font {
                    if let font = FontFromObject(object: font, bindData) {
                        attributes.updateValue(font, forKey: .font)
                    }
                }
                if let lineSpacing = node.attributedText?.lineSpacing {
                    let value = CGFloatFromObject(lineSpacing, bindData)
                    let para = NSMutableParagraphStyle()
                    para.lineSpacing = value
                    attributes.updateValue(para, forKey: .paragraphStyle)
                }
                let att = NSMutableAttributedString(string: str, attributes: attributes)
                if let highlights = node.attributedText?.highlights, highlights.count > 0 {
                    for highlight in highlights {
                        var highlightRange: NSRange?
                        if let highlightText = highlight.text, highlightText.count > 0 {
                            let hstr = StringFromObject(highlightText, bindData)
                            if let range = str.nsRange(of: hstr) {
                                highlightRange = range
                            }
                        } else if let location = highlight.location, let length = highlight.length {
                            let locationInt = IntFromObject(location, bindData)
                            let lengthInt = IntFromObject(length, bindData)
                            highlightRange = NSRange(location: locationInt, length: lengthInt)
                        }
                        if let highlightRange {
                            var highlightAttributes: [NSAttributedStringKey:Any] = [:]
                            if let textColor = highlight.textColor {
                                let str = StringFromObject(textColor, bindData)
                                highlightAttributes.updateValue(UIColor.colorHexString(str), forKey: .foregroundColor)
                            }
                            if let font = highlight.font {
                                if let font = FontFromObject(object: font, bindData) {
                                    highlightAttributes.updateValue(font, forKey: .font)
                                }
                            }
                            att.addAttributes(highlightAttributes, range: highlightRange)
                        }
                    }
                }
                self.attributedText = att
                
                if let frame = node.frame {
                    if let rect = CGRectFromObject(frame, bindData) {
                        if rect.width == 0 || rect.height == 0 {
                            // 自适应宽高
                            self.sizeToFit()
                        }
                    }
                }
            }
        }
    }
    
    override func mf_addKVO(with node: ViewNode) {
        super.mf_addKVO(with: node)
        
        for item in MFLabelPropertyName.allCases {
            if item == .attributedText {
                self.mf_addObserver(target: node, key: "attributedChangeFlag")
                return
            }
            self.mf_addObserver(target: node, key: item.rawValue)
        }
    }
    
    override func mf_reloadSingleData(key: String, data: Any?) {
        var targetKey = key
        if key == "attributedChangeFlag" {
            targetKey = MFLabelPropertyName.attributedText.rawValue
        }
        super.mf_reloadSingleData(key: targetKey, data: data)
    }
    
    override class func mf_createView(with node: ViewNode, bindData: Any?, superView: UIView) -> UIView {
        if let labelNode = node as? LabelNode {
            let view = UILabel()
            superView.addSubview(view)
            view.mf_renderView(with: labelNode, bindData: bindData)
            return view
        }
        return super.mf_createView(with: node, bindData: bindData, superView: superView)
    }
}
