//
//  TableViewNode.swift
//  MFJSUI
//
//  Created by Jialin MacMini on 2025/1/14.
//

import UIKit

class TableViewNode: ScrollViewNode {
    override func createView(bindData: Any?, superView: UIView) -> UIView {
        return UITableView.mf_createView(with: self, bindData: bindData, superView: superView)
    }
}
