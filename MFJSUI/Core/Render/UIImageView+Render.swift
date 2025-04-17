//
//  UIImageView+Render.swift
//  MFJSUI
//
//  Created by Jialin MacMini on 2025/1/15.
//

import UIKit
import Kingfisher

extension UIImageView {
    override func mf_renderSelfView(with node: ViewNode, bindData: Any?) {
        super.mf_renderSelfView(with: node, bindData: bindData)
        
        guard let node = node as? ImageViewNode else { return }
        self.mf_renderSelfView(with: MFImageViewPropertyName.imageURLString.rawValue, node: node, bindData: bindData)
    }
    
    override func mf_renderSelfView(with key: String, node: ViewNode, bindData: Any?) {
        guard let enum1 = MFImageViewPropertyName(rawValue: key) else {
            super.mf_renderSelfView(with: key, node: node, bindData: bindData)
            return
        }
        
        guard let node = node as? ImageViewNode else { return }
        if enum1 == .imageURLString {
            if let imageURLString = node.imageURLString {
                let str = StringFromObject(imageURLString, bindData)
                if MFJSUIConfigure.shared.delegate != nil {
                    if str.nsRange(of: "http") != nil {
                        // 网络图片
                        MFJSUIConfigure.shared.delegate?.jsUIConfigureNetImage(with: str, for: self)
                    } else {
                        MFJSUIConfigure.shared.delegate?.jsUIConfigureImage(with: str, for: self)
                    }
                } else {
                    if let url = URL(string: str) {
                        self.kf.setImage(with: url)
                    }
                }
            }
        }
    }
    
    override func mf_addKVO(with node: ViewNode) {
        super.mf_addKVO(with: node)
        
        self.mf_addObserver(target: node, key: MFImageViewPropertyName.imageURLString.rawValue)
    }
    
    override class func mf_createView(with node: ViewNode, bindData: Any?, superView: UIView) -> UIView {
        if let imageViewNode = node as? ImageViewNode {
            let view = UIImageView()
            superView.addSubview(view)
            view.mf_renderView(with: imageViewNode, bindData: bindData)
            return view
        }
        return super.mf_createView(with: node, bindData: bindData, superView: superView)
    }
}
