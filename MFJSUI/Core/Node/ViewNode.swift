//
//  ViewNode.swift
//  MFJSUI
//
//  Created by Jialin MacMini on 2025/1/14.
//

import UIKit
import HandyJSON

class ViewNode: NSObject, HandyJSON {
    
    /// 类名
    var className = ""
    /// 视图标识
    var identifier: String?
    
    // MARK: - View属性
    // 支持数据绑定，动态更新
    @objc dynamic var frame: String?
    @objc dynamic var tag: MFIntAny?
    @objc dynamic var clipsToBounds: MFBoolAny?
    @objc dynamic var isUserInteractionEnabled: MFBoolAny?
    @objc dynamic var isHidden: MFBoolAny?
    @objc dynamic var backgroundColor: String?
    @objc dynamic var alpha: MFCGFloatAny?
    @objc dynamic var tintColor: String?
    @objc dynamic var contentMode: String?
    
    // MARK: - Layer属性
    // 支持数据绑定，动态更新
    @objc dynamic var layer_masksToBounds: MFBoolAny?
    @objc dynamic var layer_cornerRadius: MFCGFloatAny?
    @objc dynamic var layer_maskedCorners: String?
    @objc dynamic var layer_borderColor: String?
    @objc dynamic var layer_borderWidth: MFCGFloatAny?
    
    /// 子视图
    var subviews: [ViewNode]?
    
    /// 绑定事件
    var actions: [ActionNode]?
    
    /// 自定义字段
    /// 绑定数据模型
    var bindData: Any?
    var observerInfo: [String:NSObject] = [:]
    /// 扩展的监听key映射关系
    var extentKeyMap: [String:String] = [:]
    
    deinit {
        for key in observerInfo.keys {
            let object = observerInfo[key]
            object?.removeObserver(self, forKeyPath: key)
        }
    }
    
    // 自定义映射
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.className <-- "class"
        // 处理子视图节点类型
        mapper <<< self.subviews <-- TransformOf<[ViewNode], [[String:Any]]>(fromJSON: { json -> [ViewNode] in
            if let json {
                var arr: [ViewNode] = []
                for dict in json {
                    let node = MFJSUITool.nodeForDict(with: dict)
                    arr.append(node)
                }
                return arr
            }
            return []
        }, toJSON: { object -> [[String:Any]] in
            return []
        })
    }
    
    /// 创建视图
    @discardableResult
    func createView(bindData: Any?, superView: UIView) -> UIView {
        return UIView.mf_createView(with: self, bindData: bindData, superView: superView)
    }
    
    /// 数据绑定
    func dataBind(with bindData: Any?) {
        self.bindData = bindData
        
        for item in MFViewPropertyName.allCases {
            addKVO(with: item.rawValue)
        }
        
        // 绑定子节点
        guard let subviews else { return }
        for subNode in subviews {
            subNode.dataBind(with: bindData)
        }
    }
    
    func addKVO(with key: String) {
        if !MFJSUIConfigure.shared.enableDataBind {
            // 不开启数据绑定
            return
        }
        
        // 扩展添加
        extendAddKVO(with: key)
        
        if !shouldAddKVO(with: key) {
            // 不需要绑定数据
            return
        }
        guard let paramStr = value(with: key) as? String else { return }
        guard let object = bindData as? NSObject else { return }
        // 获取参数
        var pat = paramStr.subString(start: 2, count: paramStr.count-3)
        if pat.hasPrefix("data.") {
            pat = pat.subString(start: 5, count: pat.count-5)
        }
        guard let kvoInfo = MFJSUITool.parentObject(for: pat, in: object) else { return }
        if observerInfo[kvoInfo.1] != nil {
            return
        }
        kvoInfo.0.addObserver(self, forKeyPath: kvoInfo.1, options: .new, context: nil)
        observerInfo.updateValue(kvoInfo.0, forKey: kvoInfo.1)
        extentKeyMap.updateValue(key, forKey: kvoInfo.1)
    }
    
    func dataChange(with key: String, value: Any?) {
        guard let enum1 = MFViewPropertyName(rawValue: key) else { return }
        switch enum1 {
        case .frame:
            // 不使用更改的数据，重新从绑定数据里解析
            let old = frame
            frame = old
        case .tag:
            tag = value
        case .clipsToBounds:
            clipsToBounds = value
        case .isUserInteractionEnabled:
            isUserInteractionEnabled = value
        case .isHidden:
            isHidden = value
        case .backgroundColor:
            backgroundColor = value as? String
        case .alpha:
            alpha = value
        case .tintColor:
            tintColor = value as? String
        case .contentMode:
            contentMode = value as? String
        case .layer_masksToBounds:
            layer_masksToBounds = value
        case .layer_cornerRadius:
            layer_cornerRadius = value
        case .layer_maskedCorners:
            layer_maskedCorners = value as? String
        case .layer_borderColor:
            layer_borderColor = value as? String
        case .layer_borderWidth:
            layer_borderWidth = value
        }
    }
    
    func shouldAddKVO(with key: String) -> Bool {
        let value = value(with: key) as? String
        guard let value else { return false }
        if value.hasPrefix("${") && value.hasSuffix("}") {
            return true
        }
        return false
    }
    
    func extendAddKVO(with key: String) {
        if key == "frame" {
            guard let value = value(with: key) as? String else { return }
            if value.hasPrefix("${") && value.hasSuffix("}") {
                // 简单数据绑定字段
                return
            }
            if !value.contains("${") {
                return
            }
            // 解析json
            if let jsonData = value.data(using: .utf8) {
                if let dict = (try? JSONSerialization.jsonObject(with: jsonData)) as? [String:Any] {
                    var waitToBindInfo: [(String, String)] = []
                    if let x = dict["x"] as? String {
                        if x.hasPrefix("${") && x.hasSuffix("}") {
                            // 绑定到frame字段
                            waitToBindInfo.append((x, "x"))
                        }
                    }
                    if let y = dict["y"] as? String {
                        if y.hasPrefix("${") && y.hasSuffix("}") {
                            // 绑定到frame字段
                            waitToBindInfo.append((y, "y"))
                        }
                    }
                    if let width = dict["width"] as? String {
                        if width.hasPrefix("${") && width.hasSuffix("}") {
                            // 绑定到frame字段
                            waitToBindInfo.append((width, "width"))
                        }
                    }
                    if let height = dict["height"] as? String {
                        if height.hasPrefix("${") && height.hasSuffix("}") {
                            // 绑定到frame字段
                            waitToBindInfo.append((height, "height"))
                        }
                    }
                    
                    for info in waitToBindInfo {
                        guard let object = bindData as? NSObject else { return }
                        // 获取参数
                        var pat = info.0.subString(start: 2, count: info.0.count-3)
                        if pat.hasPrefix("data.") {
                            pat = pat.subString(start: 5, count: pat.count-5)
                        }
                        guard let kvoInfo = MFJSUITool.parentObject(for: pat, in: object) else { return }
                        if observerInfo[kvoInfo.1] != nil {
                            continue
                        }
                        kvoInfo.0.addObserver(self, forKeyPath: kvoInfo.1, options: .new, context: nil)
                        observerInfo.updateValue(kvoInfo.0, forKey: kvoInfo.1)
                        // 扩展KVO字段
                        extentKeyMap.updateValue("frame", forKey: kvoInfo.1)
                    }
                }
            }
        }
    }
    
    func value(with key: String) -> Any? {
        guard let enum1 = MFViewPropertyName(rawValue: key) else { return nil }
        switch enum1 {
        case .frame:
            return frame
        case .tag:
            return tag
        case .clipsToBounds:
            return clipsToBounds
        case .isUserInteractionEnabled:
            return isUserInteractionEnabled
        case .isHidden:
            return isHidden
        case .backgroundColor:
            return backgroundColor
        case .alpha:
            return alpha
        case .tintColor:
            return tintColor
        case .contentMode:
            return contentMode
        case .layer_masksToBounds:
            return layer_masksToBounds
        case .layer_cornerRadius:
            return layer_cornerRadius
        case .layer_maskedCorners:
            return layer_maskedCorners
        case .layer_borderColor:
            return layer_borderColor
        case .layer_borderWidth:
            return layer_borderWidth
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        var key = keyPath ?? ""
        if let extentKey = extentKeyMap[key] {
            key = extentKey
        }
        self.dataChange(with: key, value: change?[.newKey])
    }
    
    required override init() {}
}

class ViewFrame: HandyJSON {
    var x = ""
    var y = ""
    var width = ""
    var height = ""
    
    required init() {}
}
