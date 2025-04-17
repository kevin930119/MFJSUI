//
//  MFJSUITool.swift
//  MFJSUI
//
//  Created by Jialin MacMini on 2025/1/14.
//

import UIKit
import HandyJSON

enum MFClassName: String {
    case label = "Label"
    case imageView = "ImageView"
    case control = "Control"
    case button = "Button"
    case textField = "TextField"
    case textView = "TextView"
    case scrollView = "ScrollView"
    case tableView = "TableView"
    case collectionView = "CollectionView"
}

class MFJSUITool: NSObject {
    
    /// 解析JSON数据，转换为视图节点数据
    /// - Parameter json: json数据
    /// - Returns: 根节点数据
    static func analysisJSONToNode(with json: [String:Any]) -> RootNode? {
        return RootNode.deserialize(from: json)
    }
    
    /// 根据数据返回相对应的节点
    /// - Parameter dict: 字典数据
    /// - Returns: 节点类
    static func nodeForDict(with dict: [String:Any]) -> ViewNode {
        let name = dict["class"] as? String ?? ""
        guard let mfclass = MFClassName(rawValue: name) else {
            return (ViewNode.deserialize(from: dict) ?? ViewNode())
        }
        if mfclass == .label {
            return (LabelNode.deserialize(from: dict) ?? LabelNode())
        } else if mfclass == .imageView {
            return (ImageViewNode.deserialize(from: dict) ?? ImageViewNode())
        } else if mfclass == .control {
            return (ControlNode.deserialize(from: dict) ?? ControlNode())
        } else if mfclass == .button {
            return (ButtonNode.deserialize(from: dict) ?? ButtonNode())
        } else if mfclass == .textField {
            return (TextFieldNode.deserialize(from: dict) ?? TextFieldNode())
        } else if mfclass == .textView {
            return (TextViewNode.deserialize(from: dict) ?? TextViewNode())
        } else if mfclass == .scrollView {
            return (ScrollViewNode.deserialize(from: dict) ?? ScrollViewNode())
        } else if mfclass == .tableView {
            return (TableViewNode.deserialize(from: dict) ?? TableViewNode())
        } else if mfclass == .collectionView {
            return (CollectionViewNode.deserialize(from: dict) ?? CollectionViewNode())
        }
        return (ViewNode.deserialize(from: dict) ?? ViewNode())
    }
    
    /// 通过链式语法获取data里面的数据
    static func value(for key: String, in data: Any) -> Any? {
        if let dict = data as? [AnyHashable:Any] {
            // 切割字符串
            var subStrs = key.components(separatedBy: ".")
            var targetDict = dict
            var targetValue: Any?
            while subStrs.count > 0 {
                let value = targetDict[subStrs[0]]
                if let valueDict = value as? [String:Any] {
                    targetDict = valueDict
                    subStrs.removeFirst()
                } else {
                    targetValue = value
                    subStrs.removeAll()
                }
            }
            return targetValue ?? key
        } else if !isBaseType(with: data) {
            // 切割字符串
            var subStrs = key.components(separatedBy: ".")
            var targetObject = data
            var targetValue: Any?
            while subStrs.count > 0 {
                var fieldDatas: [String:Any] = [:]
                // 通过反射获取数据
                let mirror = Mirror(reflecting: targetObject)
                for child in mirror.children {
                    if let label = child.label {
                        fieldDatas.updateValue(child.value, forKey: label)
                    }
                }
                let value = fieldDatas[subStrs[0]]
                if !isBaseType(with: value), let value {
                    targetObject = value
                    subStrs.removeFirst()
                } else {
                    targetValue = value
                    subStrs.removeAll()
                }
            }
            return targetValue ?? key
        }
        return key
    }
    
    /// 通过链式语法获取数据字段的父层对象
    /// 用于KVO监听
    static func parentObject(for key: String, in data: Any) -> (NSObject, String)? {
        if isBaseType(with: data) || data is [AnyHashable:Any] || !(data is NSObject) {
            return nil
        }
        // 切割字符串
        var subStrs = key.components(separatedBy: ".")
        var targetObject: NSObject = data as! NSObject
        var targetKey: String?
        while subStrs.count > 0 {
            var fieldDatas: [String:Any] = [:]
            // 通过反射获取数据
            let mirror = Mirror(reflecting: targetObject)
            for child in mirror.children {
                if let label = child.label {
                    fieldDatas.updateValue(child.value, forKey: label)
                }
            }
            let value = fieldDatas[subStrs[0]] as? NSObject
            if !isBaseType(with: value), let value {
                targetObject = value
                subStrs.removeFirst()
            } else {
                targetKey = subStrs[0]
                subStrs.removeAll()
            }
        }
        if let targetKey {
            return (targetObject, targetKey)
        }
        return nil
    }
    
    /// 是否基础类型
    static func isBaseType(with object: Any?) -> Bool {
        guard let object else { return true }
        if object is String {
            return true
        }
        if object is NSString {
            return true
        }
        if object is NSNumber {
            return true
        }
        if Mirror(reflecting: object).children.count <= 0 {
            return true
        }
        return false
    }
}
