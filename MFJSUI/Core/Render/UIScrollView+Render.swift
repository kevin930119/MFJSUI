//
//  UIScrollView+Render.swift
//  MFJSUI
//
//  Created by Jialin MacMini on 2025/1/15.
//

import UIKit

extension UIScrollView {
    override func mf_renderSelfView(with node: ViewNode, bindData: Any?) {
        super.mf_renderSelfView(with: node, bindData: bindData)
        guard let node = node as? ScrollViewNode else { return }
        for item in MFScrollViewPropertyName.allCases {
            self.mf_renderSelfView(with: item.rawValue, node: node, bindData: bindData)
        }
        
        if node.contentSize == nil {
            // 自适应
            var maxX: CGFloat = 0
            var maxY: CGFloat = 0
            for view in subviews {
                let frame = view.frame
                if maxX < frame.maxX {
                    maxX = frame.maxX
                }
                if maxY < frame.maxY {
                    maxY = frame.maxY
                }
            }
            if maxX > 0 || maxY > 0 {
                self.contentSize = .init(width: maxX, height: maxY)
            }
        }
    }
    
    override func mf_renderSelfView(with key: String, node: ViewNode, bindData: Any?) {
        guard let enum1 = MFScrollViewPropertyName(rawValue: key) else {
            super.mf_renderSelfView(with: key, node: node, bindData: bindData)
            return
        }
        guard let node = node as? ScrollViewNode else { return }
        switch enum1 {
        case .isScrollEnabled:
            if let isScrollEnabled = node.isScrollEnabled {
                let flag = BoolFromObject(isScrollEnabled, bindData)
                self.isScrollEnabled = flag
            }
        case .bounces:
            if let bounces = node.bounces {
                let flag = BoolFromObject(bounces, bindData)
                self.bounces = flag
            }
        case .contentInset:
            if let contentInset = node.contentInset {
                if let insets = ContentInsetsFromObject(object: contentInset, bindData) {
                    self.contentInset = insets
                }
            }
        case .contentSize:
            if let contentSize = node.contentSize {
                if let size = ContentSizeFromObject(object: contentSize, bindData) {
                    self.contentSize = size
                }
            }
        case .isPagingEnabled:
            if let isPagingEnabled = node.isPagingEnabled {
                let flag = BoolFromObject(isPagingEnabled, bindData)
                self.isPagingEnabled = flag
            }
        }
    }
    
    override func mf_addKVO(with node: ViewNode) {
        super.mf_addKVO(with: node)
        for item in MFScrollViewPropertyName.allCases {
            self.mf_addObserver(target: node, key: item.rawValue)
        }
    }
    
    override class func mf_createView(with node: ViewNode, bindData: Any?, superView: UIView) -> UIView {
        if let scrollViewNode = node as? ScrollViewNode {
            let view = UIScrollView()
            superView.addSubview(view)
            view.mf_renderView(with: scrollViewNode, bindData: bindData)
            return view
        }
        return super.mf_createView(with: node, bindData: bindData, superView: superView)
    }
}
