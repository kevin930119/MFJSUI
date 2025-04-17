//
//  ImageViewNode.swift
//  MFJSUI
//
//  Created by Jialin MacMini on 2025/1/14.
//

import UIKit

class ImageViewNode: ViewNode {
    // 支持数据绑定
    /// 图片链接，支持本地图片以及网络图片
    @objc dynamic var imageURLString: String?
    
    override func dataBind(with bindData: Any?) {
        super.dataBind(with: bindData)
        
        for item in MFImageViewPropertyName.allCases {
            addKVO(with: item.rawValue)
        }
    }
    
    override func value(with key: String) -> Any? {
        guard let enum1 = MFImageViewPropertyName(rawValue: key) else { return super.value(with: key) }
        switch enum1 {
        case .imageURLString:
            return imageURLString
        }
    }
    
    override func dataChange(with key: String, value: Any?) {
        guard let enum1 = MFImageViewPropertyName(rawValue: key) else {
            super.dataChange(with: key, value: value)
            return
        }
        switch enum1 {
        case .imageURLString:
            imageURLString = value as? String
        }
    }
    
    override func createView(bindData: Any?, superView: UIView) -> UIView {
        return UIImageView.mf_createView(with: self, bindData: bindData, superView: superView)
    }
}
