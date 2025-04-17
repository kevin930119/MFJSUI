//
//  MFJSUIConfigure.swift
//  MFJSUI
//
//  Created by Jialin MacMini on 2025/1/14.
//

import UIKit

private let kMFJSUIConfigureSDKVersion = "1.0"

public protocol MFJSUIConfigureDelegate: NSObjectProtocol {
    /// 获取自定义字体
    func jsUIConfigureFont(with fontName: String, size: CGFloat) -> UIFont
    /// 获取本地图片（UIButton使用）
    func jsUIConfigureImage(with imageName: String) -> UIImage?
    /// 获取本地图片（外部设置图片）
    func jsUIConfigureImage(with imageName: String, for imageView: UIImageView)
    /// 获取网络图片（外部设置图片）
    func jsUIConfigureNetImage(with urlString: String, for imageView: UIImageView)
}

extension MFJSUIConfigureDelegate {
    func jsUIConfigureFont(with fontName: String, size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size)
    }
    
    func jsUIConfigureImage(with imageName: String) -> UIImage? {
        return nil
    }
    
    func jsUIConfigureImage(with imageName: String, for imageView: UIImageView) {}
    
    func jsUIConfigureNetImage(with urlString: String, for imageView: UIImageView) {}
}

public class MFJSUIConfigure: NSObject {
    
    public weak var delegate: MFJSUIConfigureDelegate?
    
    /// SDK 的版本号
    /// - Note: 当前 SDK 的版本信息。
    public class var SDKVersion: String { return kMFJSUIConfigureSDKVersion }
    
    /// 命名空间属性
    /// - Description: 用于存储命名空间名称的字符串值，可为空。
    public var nameSpace: String?
    
    /// 数据绑定开关
    /// 默认开，关闭时，数据模型的数据字段改变无法实时更新到UI，要更新到UI请调用MFJSUIView.reloadData
    public var enableDataBind = true
    
    /// 获取 MFJSUI 的单例对象
    /// - Returns: MFJSUI 的共享实例
    public static let shared: MFJSUIConfigure = {
        return MFJSUIConfigure()
    }()
}
