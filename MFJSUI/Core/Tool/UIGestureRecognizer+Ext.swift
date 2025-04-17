//
//  UIGestureRecognizer+Ext.swift
//  MFJSUI
//
//  Created by Jialin MacMini on 2025/3/20.
//

import UIKit

fileprivate struct MFUIGestureRecognizerAssociatedKey {
    static var data: Int = 1
}

extension UIGestureRecognizer {
    var mf_data: Any? {
        set {
            objc_setAssociatedObject(self, &MFUIGestureRecognizerAssociatedKey.data, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &MFUIGestureRecognizerAssociatedKey.data) as? String
        }
    }
}
