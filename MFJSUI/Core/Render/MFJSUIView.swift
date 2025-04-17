//
//  MFJSUIView.swift
//  MFJSUI
//
//  Created by Jialin MacMini on 2025/1/14.
//

import UIKit
import Kingfisher

public let MFViewActionKeyGestureRecognizer = "MFViewActionKeyGestureRecognizer"
public let MFViewActionKeyData = "MFViewActionKeyData"

public protocol MFJSUIViewDelegate: NSObjectProtocol {
    /// 内部视图触发事件
    /// - Parameters:
    ///   - actionName: 事件名
    ///   - View: 响应事件的视图
    ///   - userInfo: 额外信息 如果是手势事件
    ///   key[MFViewActionKeyGestureRecognizer]里面存储手势对象
    ///   key[data]里面存储JSON文件事件里面存储的data数据
    func actionsOccured(event: String, view: UIView, identifier: String?, userInfo: [String:Any]?)
    
    /// 内部手势被添加
    /// 外部可通过该手势做一些处理，例如：不同手势间的交互兼容
    /// - Parameter gestureRecognizer: 手势
    /// - Parameter view: 添加视图
    /// - Parameter identifier: 视图标识
    func gestureRecognizerDidAdd(gestureRecognizer: UIGestureRecognizer, to view: UIView, identifier: String?)
}

open class MFJSUIView: UIView {

    /// 事件代理
    public weak var delegate: MFJSUIViewDelegate?
    
    /// 绑定的数据
    public var bindedData: Any?
    /// 内部渲染json数据
    var jsonData: [String:Any]?
    /// 内部保存的节点数据
    var node: ViewNode?
    
    open func render(with jsonString: String, bindData: Any? = nil) {
        guard let data = jsonString.data(using: .utf8) else { return }
        guard let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String:Any] else { return }
        render(with: json, bindData: bindData)
    }
    
    open func render(with json: [String:Any], bindData: Any? = nil) {
        self.bindedData = bindData
        self.jsonData = json
        // 清除旧视图
        let subviews = self.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
        // 解析为节点数据
        guard let rootNode = MFJSUITool.analysisJSONToNode(with: json) else { return }
        guard let rootView = rootNode.rootView else { return }
        self.node = rootView
        // 数据绑定到节点，再由节点绑定到UI
        rootView.dataBind(with: bindData)
        self.mf_renderView(with: rootView, bindData: bindData)
    }
    
    /// 绑定数据
    /// - Parameter data: 数据，可以是基础数据类型，可以是Dict或Array，也可以是模型
    open func bindData(_ data: Any) {
        self.bindedData = data
        reloadData()
    }
    
    /// 刷新UI
    open func refreshUI() {
        guard let jsonData else { return }
        render(with: jsonData)
    }
    
    /// 刷新数据
    /// 使用绑定数据进行刷新
    open func reloadData() {
        guard let node else { return }
        self.mf_reloadData(with: node, bindData: bindedData)
    }
    
    // MARK: - ViewActionProtocol
    override func actionsOccured(event: String, view: UIView, identifier: String?, userInfo: [String : Any]?) {
        delegate?.actionsOccured(event: event, view: view, identifier: identifier, userInfo: userInfo)
    }
    
    override func gestureRecognizerDidAdd(gestureRecognizer: UIGestureRecognizer, to view: UIView, identifier: String?) {
        delegate?.gestureRecognizerDidAdd(gestureRecognizer: gestureRecognizer, to: view, identifier: identifier)
    }
}
