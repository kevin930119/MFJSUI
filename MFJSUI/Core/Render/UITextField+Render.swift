//
//  UITextField+Render.swift
//  MFJSUI
//
//  Created by Jialin MacMini on 2025/1/15.
//

import UIKit

extension UITextField {
    override func mf_renderSelfView(with node: ViewNode, bindData: Any?) {
        super.mf_renderSelfView(with: node, bindData: bindData)
        guard let node = node as? TextFieldNode else { return }
        for item in MFTextFieldPropertyName.allCases {
            self.mf_renderSelfView(with: item.rawValue, node: node, bindData: bindData)
        }
    }
    
    override func mf_renderSelfView(with key: String, node: ViewNode, bindData: Any?) {
        guard let enum1 = MFTextFieldPropertyName(rawValue: key) else {
            super.mf_renderSelfView(with: key, node: node, bindData: bindData)
            return
        }
        
        guard let node = node as? TextFieldNode else { return }
        switch enum1 {
        case .text:
            if let text = node.text {
                let str = StringFromObject(text, bindData)
                self.text = str
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
        case .placeholder, .placeholderColor:
            if let placeholder = node.placeholder {
                var placeholderColor1 = self.textColor
                if let placeholderColor = node.placeholderColor {
                    let str = StringFromObject(placeholderColor, bindData)
                    placeholderColor1 = UIColor.colorHexString(str)
                }
                var attrs: [NSAttributedString.Key : Any] = [:]
                if placeholderColor1 != nil {
                    attrs.updateValue(placeholderColor1!, forKey: .foregroundColor)
                }
                if self.font != nil {
                    attrs.updateValue(self.font!, forKey: .font)
                }
                let placeholderAtt = NSMutableAttributedString(string: placeholder, attributes: attrs)
                self.attributedPlaceholder = placeholderAtt
            }
        }
    }
    
    override func mf_addKVO(with node: ViewNode) {
        super.mf_addKVO(with: node)
        for item in MFTextFieldPropertyName.allCases {
            self.mf_addObserver(target: node, key: item.rawValue)
        }
    }
    
    override class func mf_createView(with node: ViewNode, bindData: Any?, superView: UIView) -> UIView {
        if let textFieldNode = node as? TextFieldNode {
            let view = UITextField()
            superView.addSubview(view)
            view.mf_renderView(with: textFieldNode, bindData: bindData)
            return view
        }
        return super.mf_createView(with: node, bindData: bindData, superView: superView)
    }
}
