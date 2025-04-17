//
//  ControlNode.swift
//  MFJSUI
//
//  Created by Jialin MacMini on 2025/1/14.
//

import UIKit

class ControlNode: ViewNode {
    /// 支持数据绑定，动态更新
    @objc dynamic var isSelected: MFBoolAny?
    @objc dynamic var isEnabled: MFBoolAny?
    
    override func dataBind(with bindData: Any?) {
        super.dataBind(with: bindData)
        
        for item in MFControlPropertyName.allCases {
            addKVO(with: item.rawValue)
        }
    }
    
    override func value(with key: String) -> Any? {
        guard let enum1 = MFControlPropertyName(rawValue: key) else { return super.value(with: key) }
        switch enum1 {
        case .isSelected:
            return isSelected
        case .isEnabled:
            return isEnabled
        }
    }
    
    override func dataChange(with key: String, value: Any?) {
        guard let enum1 = MFControlPropertyName(rawValue: key) else {
            super.dataChange(with: key, value: value)
            return
        }
        switch enum1 {
        case .isSelected:
            isSelected = value
        case .isEnabled:
            isEnabled = value
        }
    }
    
    override func createView(bindData: Any?, superView: UIView) -> UIView {
        return UIControl.mf_createView(with: self, bindData: bindData, superView: superView)
    }
}
