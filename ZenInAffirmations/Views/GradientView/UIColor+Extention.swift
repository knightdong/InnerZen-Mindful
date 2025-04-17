//
//  UIColor+Extention.swift
//  Cooraft-swift
//
//  Created by Tao Dong on 2025/3/5.
//

import UIKit

extension UIColor {
    /// 根据Light/Dark Mode返回不同颜色
    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { traitCollection in
                return traitCollection.userInterfaceStyle == .dark ? dark : light
            }
        } else {
            // 兼容iOS 12及以下，默认Light模式颜色
            return light
        }
    }
    
    /// 将 Hex 颜色字符串转换为 UIColor
       /// - Parameters:
       ///   - hex: 颜色字符串 (如 "#FF5733", "0xFF5733", "FF5733", "#000", "000")
       ///   - alpha: 透明度 (默认 1.0)
       convenience init?(hex: String, alpha: CGFloat = 1.0) {
           var cleanedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
           
           // 去除可能的前缀
           if cleanedHex.hasPrefix("#") {
               cleanedHex.removeFirst()
           } else if cleanedHex.hasPrefix("0X") {
               cleanedHex.removeFirst(2)
           }
           
           // 如果是3位字符，扩展为6位
           if cleanedHex.count == 3 {
               var expandedHex = ""
               for char in cleanedHex {
                   expandedHex.append(String(repeating: char, count: 2))
               }
               cleanedHex = expandedHex
           }
           
           // 验证字符串是否为6位
           guard cleanedHex.count == 6 else { return nil }
           
           // 将字符串转换为数值
           var rgbValue: UInt64 = 0
           guard Scanner(string: cleanedHex).scanHexInt64(&rgbValue) else { return nil }
           
           self.init(
               red: CGFloat((rgbValue >> 16) & 0xFF) / 255.0,
               green: CGFloat((rgbValue >> 8) & 0xFF) / 255.0,
               blue: CGFloat(rgbValue & 0xFF) / 255.0,
               alpha: alpha
           )
       }
}
