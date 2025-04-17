//
//  RootNode.swift
//  MFJSUI
//
//  Created by Jialin MacMini on 2025/1/15.
//

import UIKit
import HandyJSON

class RootNode: HandyJSON {
    /// SDK版本号
    var SDKVersion = ""
    /// 该JSON文件是按那个平台标准编写的
    var platform = ""
    /// 根视图节点数据
    var rootView: ViewNode?
    
    // 自定义映射
    func mapping(mapper: HelpingMapper) {
        // 处理根视图节点类型
        mapper <<< self.rootView <-- TransformOf<ViewNode, [String:Any]>(fromJSON: { json -> ViewNode in
            if let json {
                let node = MFJSUITool.nodeForDict(with: json)
                return node
            }
            return ViewNode()
        }, toJSON: { object -> [String:Any] in
            return [:]
        })
    }
    
    required init() {}
}
