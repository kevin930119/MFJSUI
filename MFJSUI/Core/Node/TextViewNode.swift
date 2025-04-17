//
//  TextViewNode.swift
//  MFJSUI
//
//  Created by Jialin MacMini on 2025/1/14.
//

import UIKit

class TextViewNode: ScrollViewNode {
    /// 支持数据绑定，动态更新
    @objc dynamic var text: String?
    @objc dynamic var textColor: String?
    @objc dynamic var font: String?
    
    override func dataBind(with bindData: Any?) {
        super.dataBind(with: bindData)
        
        for item in MFTextViewPropertyName.allCases {
            addKVO(with: item.rawValue)
        }
    }
    
    override func value(with key: String) -> Any? {
        guard let enum1 = MFTextViewPropertyName(rawValue: key) else { return super.value(with: key) }
        switch enum1 {
        case .text:
            return text
        case .textColor:
            return textColor
        case .font:
            return font
        }
    }
    
    override func dataChange(with key: String, value: Any?) {
        guard let enum1 = MFTextViewPropertyName(rawValue: key) else {
            super.dataChange(with: key, value: value)
            return
        }
        switch enum1 {
        case .text:
            text = value as? String
        case .textColor:
            textColor = value as? String
        case .font:
            font = value as? String
        }
    }
    
    override func createView(bindData: Any?, superView: UIView) -> UIView {
        return UITextView.mf_createView(with: self, bindData: bindData, superView: superView)
    }
}
