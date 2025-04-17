//
//  AttributedStringNode.swift
//  MFJSUI
//
//  Created by Jialin MacMini on 2025/1/15.
//

import UIKit
import HandyJSON

class AttributedStringNode: HandyJSON {
    
    var text: String?
    var textColor: String?
    var font: String?
    var lineSpacing: MFCGFloatAny?
    /// 高亮内容
    var highlights: [AttributedStringHighlightNode]?
    
    required init() {}
}

class AttributedStringHighlightNode: HandyJSON {
    /// 高亮文本
    var text: String?
    /// 高亮区域
    var location: MFIntAny?
    var length: MFIntAny?
    
    var textColor: String?
    var font: String?
    
    required init() {}
}
