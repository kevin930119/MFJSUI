//
//  ScrollViewNode.swift
//  MFJSUI
//
//  Created by Jialin MacMini on 2025/1/14.
//

import UIKit

class ScrollViewNode: ViewNode {
    /// 支持数据绑定，动态更新
    @objc dynamic var isScrollEnabled: MFBoolAny?
    @objc dynamic var bounces: MFBoolAny?
    @objc dynamic var contentInset: String?
    @objc dynamic var contentSize: String?
    @objc dynamic var isPagingEnabled: MFBoolAny?
    
    override func dataBind(with bindData: Any?) {
        super.dataBind(with: bindData)
        
        for item in MFScrollViewPropertyName.allCases {
            addKVO(with: item.rawValue)
        }
    }
    
    override func value(with key: String) -> Any? {
        guard let enum1 = MFScrollViewPropertyName(rawValue: key) else { return super.value(with: key) }
        switch enum1 {
        case .isScrollEnabled:
            return isScrollEnabled
        case .bounces:
            return bounces
        case .contentInset:
            return contentInset
        case .contentSize:
            return contentSize
        case .isPagingEnabled:
            return isPagingEnabled
        }
    }
    
    override func dataChange(with key: String, value: Any?) {
        guard let enum1 = MFScrollViewPropertyName(rawValue: key) else {
            super.dataChange(with: key, value: value)
            return
        }
        switch enum1 {
        case .isScrollEnabled:
            isScrollEnabled = value
        case .bounces:
            bounces = value
        case .contentInset:
            contentInset = value as? String
        case .contentSize:
            contentSize = value as? String
        case .isPagingEnabled:
            isPagingEnabled = value
        }
    }
    
    override func createView(bindData: Any?, superView: UIView) -> UIView {
        return UIScrollView.mf_createView(with: self, bindData: bindData, superView: superView)
    }
}
