//
//  ButtonNode.swift
//  MFJSUI
//
//  Created by Jialin MacMini on 2025/1/14.
//

import UIKit

class ButtonNode: ControlNode {
    /// 支持数据绑定，动态更新
    @objc dynamic var title: String?
    @objc dynamic var titleColor: String?
    @objc dynamic var titleFont: String?
    @objc dynamic var titleAlignment: String?
    @objc dynamic var imageName: String?
    @objc dynamic var backgroundImageName: String?
    
    override func dataBind(with bindData: Any?) {
        super.dataBind(with: bindData)
        
        for item in MFButtonPropertyName.allCases {
            addKVO(with: item.rawValue)
        }
    }
    
    override func value(with key: String) -> Any? {
        guard let enum1 = MFButtonPropertyName(rawValue: key) else { return super.value(with: key) }
        switch enum1 {
        case .title:
            return title
        case .titleColor:
            return titleColor
        case .titleFont:
            return titleFont
        case .titleAlignment:
            return titleAlignment
        case .imageName:
            return imageName
        case .backgroundImageName:
            return backgroundImageName
        }
    }
    
    override func dataChange(with key: String, value: Any?) {
        guard let enum1 = MFButtonPropertyName(rawValue: key) else {
            super.dataChange(with: key, value: value)
            return
        }
        switch enum1 {
        case .title:
            title = value as? String
        case .titleColor:
            titleColor = value as? String
        case .titleFont:
            titleFont = value as? String
        case .titleAlignment:
            titleAlignment = value as? String
        case .imageName:
            imageName = value as? String
        case .backgroundImageName:
            backgroundImageName = value as? String
        }
    }
    
    override func createView(bindData: Any?, superView: UIView) -> UIView {
        return UIButton.mf_createView(with: self, bindData: bindData, superView: superView)
    }
}
