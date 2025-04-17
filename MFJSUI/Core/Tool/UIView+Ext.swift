//
//  UIView+Identifier.swift
//  MFJSUI
//
//  Created by Jialin MacMini on 2025/1/15.
//

import UIKit

fileprivate struct MFUIViewAssociatedKey {
    static var identifier: Int = 1
    static var observer: Int = 2
    static var node: Int = 3
}

extension UIView {
    /// 视图的标识符
    public var mf_identifier: String? {
        set {
            objc_setAssociatedObject(self, &MFUIViewAssociatedKey.identifier, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &MFUIViewAssociatedKey.identifier) as? String
        }
    }
    
    /// 视图数据绑定观察者
    var mf_viewDataObverser: ViewDataObverser {
        if let obverser = objc_getAssociatedObject(self, &MFUIViewAssociatedKey.observer) as? ViewDataObverser {
            return obverser
        }
        let newObverser = ViewDataObverser()
        newObverser.kvoChangeAction = { [weak self] key, newValue in
            self?.mf_reloadSingleData(key: key, data: newValue)
        }
        objc_setAssociatedObject(self, &MFUIViewAssociatedKey.observer, newObverser, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return newObverser
    }
    
    func mf_addObserver(target: NSObject, key: String) {
        if !MFJSUIConfigure.shared.enableDataBind {
            // 不开启数据绑定
            return
        }
        self.mf_viewDataObverser.addObserver(target: target, key: key)
    }
    
    var mf_viewNode: ViewNode? {
        set {
            objc_setAssociatedObject(self, &MFUIViewAssociatedKey.node, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &MFUIViewAssociatedKey.node) as? ViewNode
        }
    }
}

/// 视图数据绑定观察者
class ViewDataObverser: NSObject {
    
    var observerKeys: [String] = []
    var target: NSObject?
    
    var kvoChangeAction: ((_ key: String, _ value: Any?)->Void)?
    
    deinit {
        // 去除KVO监听
        for key in observerKeys {
            target?.removeObserver(self, forKeyPath: key)
        }
    }
    
    func addObserver(target: NSObject, key: String) {
        if observerKeys.contains(key) {
            // 已添加过了
            return
        }
        observerKeys.append(key)
        target.addObserver(self, forKeyPath: key, options: .new, context: nil)
        self.target = target
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let keyPath {
            let newValue = change?[.newKey]
            kvoChangeAction?(keyPath, newValue)
        }
    }
}
