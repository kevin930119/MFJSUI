//
//  String+Ext.swift
//  MFJSUI
//
//  Created by Jialin MacMini on 2025/1/24.
//

import Foundation

extension String {
    /// 字符串截取，从头开始截取到目标位置
    /// - Parameter to: 目标位置
    /// - Returns: 结果
    func subString(to: Int) -> String {
        var to = to
        if to > self.count {
            to = self.count
        }
        return String(self.prefix(to))
    }
    
    /// 字符串截取，从目标位置截取到最后
    /// - Parameter from: 目标位置
    /// - Returns: 结果
    func subString(from: Int) -> String {
        if from >= self.count {
            return ""
        }
        let startIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.endIndex
        return String(self[startIndex..<endIndex])
    }
    
    /// 字符串截取，从开始位置截取到结束位置
    /// - Parameters:
    ///   - start: 开始位置
    ///   - end: 结束位置
    /// - Returns: 结果
    func subString(start: Int, end: Int) -> String {
        if start < end {
            let startIndex = self.index(self.startIndex, offsetBy: start)
            let endIndex = self.index(self.startIndex, offsetBy: end)
            
            return String(self[startIndex..<endIndex])
        }
        return ""
    }
    
    /// 字符串截取，从开始位置截取目标个数
    /// - Parameters:
    ///   - start: 开始位置
    ///   - count: 个数
    /// - Returns: 结果
    func subString(start: Int, count: Int) -> String {
        if count == 0 {
            return ""
        }
        let end = start+count
        return subString(start: start, end: end)
    }
    
    /// 将Range转化成NSRange
    /// - Parameter range: range
    /// - Returns: nsrange
    func nsRange(from range: Range<String.Index>) -> NSRange? {
        let from = range.lowerBound.samePosition(in: utf16)
        let to = range.upperBound.samePosition(in: utf16)
        if from == nil || to == nil {
            return nil
        }
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from!), length: utf16.distance(from: from!, to: to!))
    }
    
    /// 将NSRange转化成Range
    /// - Parameter nsRange: nsrange
    /// - Returns: range
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location,
                                     limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length,
                                   limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
    
    /// 获取子字符串的NSRange
    /// - Parameter str: 子字符串
    /// - Returns: NSRange，不存在则返回nil
    func nsRange(of str: String) -> NSRange? {
        guard let range = self.range(of: str) else { return nil }
        let nsRange = NSRange(range, in: self)
        return nsRange
    }
}
