//
//  CollectionViewNode.swift
//  MFJSUI
//
//  Created by Jialin MacMini on 2025/1/14.
//

import UIKit

class CollectionViewNode: ScrollViewNode {
    override func createView(bindData: Any?, superView: UIView) -> UIView {
        return UICollectionView.mf_createView(with: self, bindData: bindData, superView: superView)
    }
}
