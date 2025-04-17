import UIKit

/// 生成分享图片的工具类
class ShareImageGenerator {
    
    // MARK: - Public Methods
    
    /// 从渐变背景生成分享图片
    /// - Parameters:
    ///   - text: 显示的文本内容
    ///   - startColor: 渐变开始颜色
    ///   - endColor: 渐变结束颜色
    ///   - size: 图片尺寸
    /// - Returns: 生成的图片
    static func generateImageWithGradient(
        text: String,
        startColor: UIColor,
        endColor: UIColor,
        size: CGSize
    ) -> UIImage {
        // 创建图像上下文
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        // 渲染渐变背景
        let gradientImage = UIGraphicsImageRenderer(size: size).image { _ in
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = CGRect(origin: .zero, size: size)
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
            gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        }
        gradientImage.draw(in: CGRect(origin: .zero, size: size))
        
        // 添加文本和水印
        addTextAndWatermark(text: text, size: size)
        
        // 从上下文获取图片
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        
        // 结束上下文
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /// 根据当前主题生成分享图片
    /// - Parameters:
    ///   - text: 显示的文本内容
    ///   - theme: 当前主题
    ///   - size: 图片尺寸
    /// - Returns: 生成的图片
    static func generateImageWithTheme(
        text: String,
        theme: ThemeType,
        size: CGSize
    ) -> UIImage {
        if theme.isWallpaper, let imageName = theme.imageName {
            print("尝试加载背景图片: \(imageName)")
            
            // 方法1: 直接使用图片名称加载
            if let backgroundImage = UIImage(named: imageName) {
                print("方法1成功: 直接使用UIImage(named:)加载")
                return generateImageWithBackground(text: text, backgroundImage: backgroundImage, size: size)
            } 
            
            // 方法2: 尝试使用完整路径从bundle加载
            let bundle = Bundle.main
            if let imagePath = bundle.path(forResource: imageName, ofType: "jpeg", inDirectory: "background_wall/\(imageName).imageset") {
                print("找到图片路径: \(imagePath)")
                if let backgroundImage = UIImage(contentsOfFile: imagePath) {
                    print("方法2成功: 使用完整路径加载")
                    return generateImageWithBackground(text: text, backgroundImage: backgroundImage, size: size)
                }
            }
            
            // 方法3: 尝试在Assets.xcassets/background_wall目录查找
            if let backgroundImage = UIImage(named: "background_wall/\(imageName)") {
                print("方法3成功: 使用background_wall/前缀加载")
                return generateImageWithBackground(text: text, backgroundImage: backgroundImage, size: size)
            }
            
            print("所有图片加载方法均失败，回退到渐变背景")
            // 图片加载失败时使用默认渐变色
            return generateWithFallbackGradient(text: text, theme: theme, size: size)
        } else {
            // 使用渐变色
            print("非壁纸主题，使用渐变色背景")
            return generateWithFallbackGradient(text: text, theme: theme, size: size)
        }
    }
    
    // MARK: - Private Methods
    
    /// 在当前图形上下文中添加文本和水印
    /// - Parameters:
    ///   - text: 显示的文本内容
    ///   - size: 图片尺寸
    private static func addTextAndWatermark(text: String, size: CGSize) {
        // 渲染语录文本
        let textRect = CGRect(x: 30, y: size.height / 2 - 50, width: size.width - 60, height: 100)
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = .center
        
        // 创建文本阴影
        let textShadow = NSShadow()
        textShadow.shadowColor = UIColor.black.withAlphaComponent(0.3)
        textShadow.shadowOffset = CGSize(width: 1, height: 1)
        textShadow.shadowBlurRadius = 3
        
        
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 40, weight: .bold),
            .foregroundColor: UIColor.white,
            .paragraphStyle: textStyle,
            .shadow: textShadow
        ]
        
        text.draw(in: textRect, withAttributes: textAttributes)
        
        // 添加水印
        let watermarkText = "ZenInAffirmations"
        let watermarkStyle = NSMutableParagraphStyle()
        watermarkStyle.alignment = .center
        
        let watermarkAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: .medium),
            .foregroundColor: UIColor.white.withAlphaComponent(0.7),
            .paragraphStyle: watermarkStyle
        ]
        
        let watermarkRect = CGRect(x: 30, y: size.height - 40, width: size.width - 60, height: 20)
        watermarkText.draw(in: watermarkRect, withAttributes: watermarkAttributes)
    }
    
    // 提取渐变色处理逻辑为单独方法
    private static func generateWithFallbackGradient(text: String, theme: ThemeType, size: CGSize) -> UIImage {
        let themeColor = theme.backgroundColor
        
        // 创建略微不同的结束颜色以产生渐变效果
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        var endColor: UIColor
        
        if themeColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            // 稍微调整色调作为结束颜色
            let endHue = fmod(hue + 0.05, 1.0)
            endColor = UIColor(hue: endHue, saturation: saturation, brightness: max(0.0, brightness - 0.2), alpha: alpha)
        } else {
            // 如果getHue失败，使用默认渐变
            endColor = themeColor.withAlphaComponent(0.7)
        }
        
        return generateImageWithGradient(text: text, startColor: themeColor, endColor: endColor, size: size)
    }
    
    /// 从背景图片生成分享图片
    /// - Parameters:
    ///   - text: 显示的文本内容
    ///   - backgroundImage: 背景图片
    ///   - size: 图片尺寸
    /// - Returns: 生成的图片
    static func generateImageWithBackground(
        text: String,
        backgroundImage: UIImage,
        size: CGSize
    ) -> UIImage {
        print("绘制背景图片开始: \(backgroundImage.size)")
        
        // 创建一个新的图像上下文，确保使用不透明背景
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(size, true, scale)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            print("获取图形上下文失败")
            UIGraphicsEndImageContext()
            return UIImage()
        }
        
        // 绘制黑色背景作为底层
        context.setFillColor(UIColor.black.cgColor)
        context.fill(CGRect(origin: .zero, size: size))
        
        // 绘制背景图片，适当调整以填充整个区域
        let rect = CGRect(origin: .zero, size: size)
        
        // 根据图片比例计算合适的绘制区域以避免拉伸
        let imageSize = backgroundImage.size
        var drawRect = rect
        let imageAspect = imageSize.width / imageSize.height
        let rectAspect = size.width / size.height
        
        if imageAspect > rectAspect {
            // 图片更宽，按高度填充
            let newWidth = size.height * imageAspect
            let offsetX = (newWidth - size.width) / 2
            drawRect = CGRect(x: -offsetX, y: 0, width: newWidth, height: size.height)
        } else {
            // 图片更高，按宽度填充
            let newHeight = size.width / imageAspect
            let offsetY = (newHeight - size.height) / 2
            drawRect = CGRect(x: 0, y: -offsetY, width: size.width, height: newHeight)
        }
        
        // 在指定区域绘制背景图片
        backgroundImage.draw(in: drawRect)
        
        // 添加半透明暗色遮罩，确保文本可读性
        context.setFillColor(UIColor.black.withAlphaComponent(0.01).cgColor)
        context.fill(rect)
        
        // 添加文本和水印
        addTextAndWatermark(text: text, size: size)
        
        // 从上下文获取图片
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            print("从图形上下文获取图片失败")
            UIGraphicsEndImageContext()
            return UIImage()
        }
        
        // 结束上下文
        UIGraphicsEndImageContext()
        print("绘制背景图片完成")
        
        return image
    }
} 
