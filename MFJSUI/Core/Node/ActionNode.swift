//
//  ActionNode.swift
//  MFJSUI
//
//  Created by Jialin MacMini on 2025/3/20.
//

import UIKit
import HandyJSON

class ActionNode: NSObject, HandyJSON {
    
    var event: String?
    var data: Any?
    
    required override init() {}
}
