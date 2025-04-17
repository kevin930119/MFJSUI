//
//  UIView+Render.swift
//  MFJSUI
//
//  Created by Jialin MacMini on 2025/1/15.
//

import UIKit

extension UIView {
    @objc func mf_renderView(with node: ViewNode, bindData: Any?) {
        mf_renderSelfView(with: node, bindData: bindData)
        
        // 添加子视图
        if let subviewNodes = node.subviews, subviewNodes.count > 0 {
            for subviewNode in subviewNodes {
                subviewNode.createView(bindData: bindData, superView: self)
            }
        }
        
        // 添加事件
        if let actions = node.actions, actions.count > 0 {
            for action in actions {
                if let event = action.event {
                    if let actionName = MFAction(rawValue: event) {
                        if actionName == .viewTap {
                            self.isUserInteractionEnabled = true
                            let tap = UITapGestureRecognizer(target: self, action: #selector(mf_viewTap(ges:)))
                            tap.mf_data = action.data
                            self.addGestureRecognizer(tap)
                            self.gestureRecognizerDidAdd(gestureRecognizer: tap, to: self, identifier: self.mf_identifier)
                        } else if actionName == .viewDoubleTap {
                            self.isUserInteractionEnabled = true
                            let tap = UITapGestureRecognizer(target: self, action: #selector(mf_viewDoubleTap(ges:)))
                            tap.numberOfTapsRequired = 2
                            tap.mf_data = action.data
                            self.addGestureRecognizer(tap)
                            self.gestureRecognizerDidAdd(gestureRecognizer: tap, to: self, identifier: self.mf_identifier)
                        } else if actionName == .viewLongPress {
                            self.isUserInteractionEnabled = true
                            let ges = UILongPressGestureRecognizer(target: self, action: #selector(mf_viewLongPress(ges:)))
                            ges.mf_data = action.data
                            self.addGestureRecognizer(ges)
                            self.gestureRecognizerDidAdd(gestureRecognizer: ges, to: self, identifier: self.mf_identifier)
                        }
                    }
                }
            }
        }
        
        // 添加KVO监听
        self.mf_addKVO(with: node)
        
        // 添加约束
        
    }
    
    @objc func mf_viewTap(ges: UIGestureRecognizer) {
        var userInfo: [String:Any] = [MFViewActionKeyGestureRecognizer:ges]
        userInfo[MFViewActionKeyData] = ges.mf_data
        actionsOccured(event: MFAction.viewTap.rawValue, view: self, identifier: self.mf_identifier, userInfo: userInfo)
    }
    
    @objc func mf_viewDoubleTap(ges: UIGestureRecognizer) {
        var userInfo: [String:Any] = [MFViewActionKeyGestureRecognizer:ges]
        userInfo[MFViewActionKeyData] = ges.mf_data
        actionsOccured(event: MFAction.viewDoubleTap.rawValue, view: self, identifier: self.mf_identifier, userInfo: userInfo)
    }
    
    @objc func mf_viewLongPress(ges: UIGestureRecognizer) {
        var userInfo: [String:Any] = [MFViewActionKeyGestureRecognizer:ges]
        userInfo[MFViewActionKeyData] = ges.mf_data
        actionsOccured(event: MFAction.viewLongPress.rawValue, view: self, identifier: self.mf_identifier, userInfo: userInfo)
    }
    
    @objc func mf_renderSelfView(with node: ViewNode, bindData: Any?) {
        self.mf_viewNode = node
        
        if let identifier = node.identifier {
            self.mf_identifier = identifier
        }
        for item in MFViewPropertyName.allCases {
            self.mf_renderSelfView(with: item.rawValue, node: node, bindData: bindData)
        }
    }
    
    @objc func mf_renderSelfView(with key: String, node: ViewNode, bindData: Any?) {
        guard let property = MFViewPropertyName(rawValue: key) else { return }
        switch property {
        case .frame:
            if let frame = node.frame {
                if let rect = CGRectFromObject(frame, bindData) {
                    self.frame = rect
                }
            }
        case .tag:
            if let tag = node.tag {
                self.tag = IntFromObject(tag, bindData)
            }
        case .clipsToBounds:
            if let clipsToBounds = node.clipsToBounds {
                let flag = BoolFromObject(clipsToBounds, bindData)
                self.clipsToBounds = flag
            }
        case .isUserInteractionEnabled:
            if let isUserInteractionEnabled = node.isUserInteractionEnabled {
                let flag = BoolFromObject(isUserInteractionEnabled, bindData)
                self.isUserInteractionEnabled = flag
            }
        case .isHidden:
            if let isHidden = node.isHidden {
                let flag = BoolFromObject(isHidden, bindData)
                self.isHidden = flag
            }
        case .backgroundColor:
            if let backgroundColor = node.backgroundColor {
                let str = StringFromObject(backgroundColor, bindData)
                self.backgroundColor = UIColor.colorHexString(str)
            }
        case .alpha:
            if let alpha = node.alpha {
                let value = CGFloatFromObject(alpha, bindData)
                self.alpha = value
            }
        case .tintColor:
            if let tintColor = node.tintColor {
                let str = StringFromObject(tintColor, bindData)
                self.tintColor = UIColor.colorHexString(str)
            }
        case .contentMode:
            if let contentMode = node.contentMode {
                let str = StringFromObject(contentMode, bindData)
                if let mode = MFContentMode(rawValue: str) {
                    self.contentMode = mode.toViewContentMode()
                }
            }
        case .layer_masksToBounds:
            if let layer_masksToBounds = node.layer_masksToBounds {
                let flag = BoolFromObject(layer_masksToBounds, bindData)
                self.layer.masksToBounds = flag
            }
        case .layer_cornerRadius:
            if let layer_cornerRadius = node.layer_cornerRadius {
                let value = CGFloatFromObjectScale("\(layer_cornerRadius)", bindData)
                self.layer.cornerRadius = value
            }
        case .layer_maskedCorners:
            if let layer_maskedCorners = node.layer_maskedCorners {
                if let mask = LayerCornerMaskFromObject(object: layer_maskedCorners, bindData) {
                    self.layer.maskedCorners = mask
                }
            }
        case .layer_borderColor:
            if let layer_borderColor = node.layer_borderColor {
                let str = StringFromObject(layer_borderColor, bindData)
                self.layer.borderColor = UIColor.colorHexString(str).cgColor
            }
        case .layer_borderWidth:
            if let layer_borderWidth = node.layer_borderWidth {
                let value = CGFloatFromObject(layer_borderWidth, bindData)
                self.layer.borderWidth = value
            }
        }
    }
    
    @objc func mf_reloadData(with node: ViewNode, bindData: Any?) {
        mf_renderSelfView(with: node, bindData: bindData)
        
        // 刷新子视图数据
        for view in subviews {
            guard let viewNode = view.mf_viewNode else { return }
            view.mf_reloadData(with: viewNode, bindData: bindData)
        }
    }
    
    @objc func mf_reloadSingleData(key: String, data: Any?) {
        guard let mf_viewNode else { return }
        self.mf_renderSelfView(with: key, node: mf_viewNode, bindData: mf_viewNode.bindData)
    }
    
    @objc func mf_addKVO(with node: ViewNode) {
        for item in MFViewPropertyName.allCases {
            self.mf_addObserver(target: node, key: item.rawValue)
        }
    }
    
    @discardableResult
    @objc class func mf_createView(with node: ViewNode, bindData: Any?, superView: UIView) -> UIView {
        let view = UIView()
        superView.addSubview(view)
        view.mf_renderView(with: node, bindData: bindData)
        return view
    }
    
    @objc func actionsOccured(event: String, view: UIView, identifier: String?, userInfo: [String : Any]?) {
        // 事件冒泡向上传递
        superview?.actionsOccured(event: event, view: view, identifier: identifier, userInfo: userInfo)
    }
    
    @objc func gestureRecognizerDidAdd(gestureRecognizer: UIGestureRecognizer, to view: UIView, identifier: String?) {
        // 事件冒泡向上传递
        superview?.gestureRecognizerDidAdd(gestureRecognizer: gestureRecognizer, to: view, identifier: identifier)
    }
}
