//
//  UIControl+Render.swift
//  MFJSUI
//
//  Created by Jialin MacMini on 2025/1/15.
//

import UIKit

extension UIControl {
    override func mf_renderView(with node: ViewNode, bindData: Any?) {
        super.mf_renderView(with: node, bindData: bindData)
        
        if let actions = node.actions, actions.count > 0 {
            for action in actions {
                if let event = action.event {
                    if let actionName = MFAction(rawValue: event) {
                        if actionName == .controlTouchUpInsize {
                            self.addTarget(self, action: #selector(mf_controlTouchUpInsize), for: .touchUpInside)
                        } else if actionName == .controlTouchUpOutsize {
                            self.addTarget(self, action: #selector(mf_controlTouchUpOutsize), for: .touchUpOutside)
                        } else if actionName == .controlTouchDown {
                            self.addTarget(self, action: #selector(mf_controlTouchDown), for: .touchDown)
                        } else if actionName == .controlTouchCancel {
                            self.addTarget(self, action: #selector(mf_controlTouchCancel), for: .touchCancel)
                        } else if actionName == .controlValueChanged {
                            self.addTarget(self, action: #selector(mf_controlValueChanged), for: .valueChanged)
                        }
                    }
                }
            }
        }
    }
    
    override func mf_renderSelfView(with node: ViewNode, bindData: Any?) {
        super.mf_renderSelfView(with: node, bindData: bindData)
        guard let node = node as? ControlNode else { return }
        for item in MFControlPropertyName.allCases {
            self.mf_renderSelfView(with: item.rawValue, node: node, bindData: bindData)
        }
    }
    
    @objc func mf_controlTouchUpInsize() {
        var data: Any?
        if let actions = mf_viewNode?.actions, actions.count > 0 {
            for action in actions {
                if let event = action.event {
                    if let actionName = MFAction(rawValue: event) {
                        if actionName == .controlTouchUpInsize {
                            data = action.data
                            break
                        }
                    }
                }
            }
        }
        var userInfo: [String:Any] = [:]
        userInfo[MFViewActionKeyData] = data
        actionsOccured(event: MFAction.controlTouchUpInsize.rawValue, view: self, identifier: self.mf_identifier, userInfo: userInfo)
    }
    
    @objc func mf_controlTouchUpOutsize() {
        var data: Any?
        if let actions = mf_viewNode?.actions, actions.count > 0 {
            for action in actions {
                if let event = action.event {
                    if let actionName = MFAction(rawValue: event) {
                        if actionName == .controlTouchUpOutsize {
                            data = action.data
                            break
                        }
                    }
                }
            }
        }
        var userInfo: [String:Any] = [:]
        userInfo[MFViewActionKeyData] = data
        actionsOccured(event: MFAction.controlTouchUpOutsize.rawValue, view: self, identifier: self.mf_identifier, userInfo: userInfo)
    }
    
    @objc func mf_controlTouchDown() {
        var data: Any?
        if let actions = mf_viewNode?.actions, actions.count > 0 {
            for action in actions {
                if let event = action.event {
                    if let actionName = MFAction(rawValue: event) {
                        if actionName == .controlTouchDown {
                            data = action.data
                            break
                        }
                    }
                }
            }
        }
        var userInfo: [String:Any] = [:]
        userInfo[MFViewActionKeyData] = data
        actionsOccured(event: MFAction.controlTouchDown.rawValue, view: self, identifier: self.mf_identifier, userInfo: userInfo)
    }
    
    @objc func mf_controlTouchCancel() {
        var data: Any?
        if let actions = mf_viewNode?.actions, actions.count > 0 {
            for action in actions {
                if let event = action.event {
                    if let actionName = MFAction(rawValue: event) {
                        if actionName == .controlTouchCancel {
                            data = action.data
                            break
                        }
                    }
                }
            }
        }
        var userInfo: [String:Any] = [:]
        userInfo[MFViewActionKeyData] = data
        actionsOccured(event: MFAction.controlTouchCancel.rawValue, view: self, identifier: self.mf_identifier, userInfo: userInfo)
    }
    
    @objc func mf_controlValueChanged() {
        var data: Any?
        if let actions = mf_viewNode?.actions, actions.count > 0 {
            for action in actions {
                if let event = action.event {
                    if let actionName = MFAction(rawValue: event) {
                        if actionName == .controlValueChanged {
                            data = action.data
                            break
                        }
                    }
                }
            }
        }
        var userInfo: [String:Any] = [:]
        userInfo[MFViewActionKeyData] = data
        actionsOccured(event: MFAction.controlValueChanged.rawValue, view: self, identifier: self.mf_identifier, userInfo: userInfo)
    }
    
    override func mf_renderSelfView(with key: String, node: ViewNode, bindData: Any?) {
        guard let enum1 = MFControlPropertyName(rawValue: key) else {
            super.mf_renderSelfView(with: key, node: node, bindData: bindData)
            return
        }
        
        guard let node = node as? ControlNode else { return }
        switch enum1 {
        case .isSelected:
            if let isSelected = node.isSelected {
                let flag = BoolFromObject(isSelected, bindData)
                self.isSelected = flag
            }
        case .isEnabled:
            if let isEnabled = node.isEnabled {
                let flag = BoolFromObject(isEnabled, bindData)
                self.isEnabled = flag
            }
        }
    }
    
    override func mf_addKVO(with node: ViewNode) {
        super.mf_addKVO(with: node)
        
        for item in MFControlPropertyName.allCases {
            self.mf_addObserver(target: node, key: item.rawValue)
        }
    }
    
    override class func mf_createView(with node: ViewNode, bindData: Any?, superView: UIView) -> UIView {
        if let controlNode = node as? ControlNode {
            let view = UIControl()
            superView.addSubview(view)
            view.mf_renderView(with: controlNode, bindData: bindData)
            return view
        }
        return super.mf_createView(with: node, bindData: bindData, superView: superView)
    }
}
