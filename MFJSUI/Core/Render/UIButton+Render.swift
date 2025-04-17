//
//  UIButton+Render.swift
//  MFJSUI
//
//  Created by Jialin MacMini on 2025/1/15.
//

import UIKit

extension UIButton {
    override func mf_renderSelfView(with node: ViewNode, bindData: Any?) {
        super.mf_renderSelfView(with: node, bindData: bindData)
        guard let node = node as? ButtonNode else { return }
        for item in MFButtonPropertyName.allCases {
            self.mf_renderSelfView(with: item.rawValue, node: node, bindData: bindData)
        }
    }
    
    override func mf_renderSelfView(with key: String, node: ViewNode, bindData: Any?) {
        guard let enum1 = MFButtonPropertyName(rawValue: key) else {
            super.mf_renderSelfView(with: key, node: node, bindData: bindData)
            return
        }
        
        guard let node = node as? ButtonNode else { return }
        switch enum1 {
        case .title:
            if let title = node.title {
                let str = StringFromObject(title, bindData)
                self.setTitle(str, for: .normal)
            }
        case .titleColor:
            if let titleColor = node.titleColor {
                let str = StringFromObject(titleColor, bindData)
                self.setTitleColor(.colorHexString(str), for: .normal)
            }
        case .titleFont:
            if let titleFont = node.titleFont {
                if let font = FontFromObject(object: titleFont, bindData) {
                    self.titleLabel?.font = font
                }
            }
        case .titleAlignment:
            if let titleAlignment = node.titleAlignment {
                let str = StringFromObject(titleAlignment, bindData)
                if let mode = MFTextAlignment(rawValue: str) {
                    self.titleLabel?.textAlignment = mode.toTextAlignment()
                }
            }
        case .imageName:
            if let imageName = node.imageName {
                let str = StringFromObject(imageName, bindData)
                if let image = MFJSUIConfigure.shared.delegate?.jsUIConfigureImage(with: str) {
                    if node.tintColor?.count ?? 0 > 0 {
                        // 存在tintColor
                        self.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
                    } else {
                        self.setImage(image, for: .normal)
                    }
                }
            }
        case .backgroundImageName:
            if let backgroundImageName = node.backgroundImageName {
                let str = StringFromObject(backgroundImageName, bindData)
                if let image = MFJSUIConfigure.shared.delegate?.jsUIConfigureImage(with: str) {
                    if node.tintColor?.count ?? 0 > 0 {
                        // 存在tintColor
                        self.setBackgroundImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
                    } else {
                        self.setBackgroundImage(image, for: .normal)
                    }
                }
            }
        }
    }
    
    override func mf_addKVO(with node: ViewNode) {
        super.mf_addKVO(with: node)
        for item in MFButtonPropertyName.allCases {
            self.mf_addObserver(target: node, key: item.rawValue)
        }
    }
    
    override class func mf_createView(with node: ViewNode, bindData: Any?, superView: UIView) -> UIView {
        if let buttonNode = node as? ButtonNode {
            let view = UIButton()
            superView.addSubview(view)
            view.mf_renderView(with: buttonNode, bindData: bindData)
            return view
        }
        return super.mf_createView(with: node, bindData: bindData, superView: superView)
    }
}
