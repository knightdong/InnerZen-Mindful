import UIKit

// Gradient view for backgrounds
class GradientView: UIView {
    var startColor: UIColor = UIColor(red: 0.4, green: 0.8, blue: 0.9, alpha: 1.0)
    var endColor: UIColor = UIColor(red: 0.2, green: 0.6, blue: 0.8, alpha: 1.0)
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func draw(_ rect: CGRect) {
        guard let gradientLayer = layer as? CAGradientLayer else { return }
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    }
} 