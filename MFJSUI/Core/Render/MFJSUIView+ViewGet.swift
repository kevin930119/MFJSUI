//
//  MFJSUIView+ViewGet.swift
//  MFJSUI
//
//  Created by Jialin MacMini on 2025/1/15.
//

import UIKit

extension MFJSUIView {
    public func view(with identifier: String) -> UIView? {
        let ids = identifier.components(separatedBy: ".")
        var superView: UIView = self
        var targetView: UIView?
        for (index, id) in ids.enumerated() {
            targetView = superView.subviews.first { view in
                return view.mf_identifier == id
            }
            if index != ids.count-1 && targetView != nil {
                superView = targetView!
                targetView = nil
            }
        }
        let firstView = subviews.first { view in
            return view.mf_identifier == identifier
        }
        return firstView
    }
    
    public func label(with identifier: String) -> UILabel? {
        return view(with: identifier) as? UILabel
    }
    
    public func imageView(with identifier: String) -> UIImageView? {
        return view(with: identifier) as? UIImageView
    }
    
    public func control(with identifier: String) -> UIControl? {
        return view(with: identifier) as? UIControl
    }
    
    public func button(with identifier: String) -> UIButton? {
        return view(with: identifier) as? UIButton
    }
    
    public func scrollView(with identifier: String) -> UIScrollView? {
        return view(with: identifier) as? UIScrollView
    }
    
    public func textField(with identifier: String) -> UITextField? {
        return view(with: identifier) as? UITextField
    }
    
    public func textView(with identifier: String) -> UITextView? {
        return view(with: identifier) as? UITextView
    }
    
    public func tableView(with identifier: String) -> UITableView? {
        return view(with: identifier) as? UITableView
    }
    
    public func collectionView(with identifier: String) -> UICollectionView? {
        return view(with: identifier) as? UICollectionView
    }
}
