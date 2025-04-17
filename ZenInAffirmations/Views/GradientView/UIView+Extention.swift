//
//  UIView+Extention.swift
//  Cooraft-swift
//
//  Created by Tao Dong on 2025/3/4.
//

import UIKit

extension UIView {
    
    /// 给 UIView 添加渐变色背景
    /// - Parameters:
    ///   - startColor: 渐变的起始颜色
    ///   - endColor: 渐变的结束颜色
    ///   - startPoint: 渐变起点（默认左上角）
    ///   - endPoint: 渐变终点（默认右下角）
    func addGradientBackground(startColor: UIColor, endColor: UIColor, startPoint: CGPoint = CGPoint(x: 0, y: 0), endPoint: CGPoint = CGPoint(x: 1, y: 1)) {
        // 如果已经存在渐变层，先移除
        removeExistingGradientLayer()

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = bounds
        gradientLayer.name = "gradientLayer"  // 给layer打个标记，方便后续移除
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    /// 移除已有的渐变层，防止重复添加
    private func removeExistingGradientLayer() {
        layer.sublayers?.removeAll(where: { $0.name == "gradientLayer" })
    }
    
    /// (如果你的View布局后frame会变化（比如Auto Layout），你可以在layoutSubviews()或viewDidLayoutSubviews()里调用：)
    func updateGradientFrame() {
        if let gradientLayer = layer.sublayers?.first(where: { $0.name == "gradientLayer" }) as? CAGradientLayer {
            gradientLayer.frame = bounds
        }
    }
}
