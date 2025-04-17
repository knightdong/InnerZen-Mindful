import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyCustomFontsToViews()
        self.view.addGradientBackground(startColor: UIColor(hex: "#d4d7cf") ?? .systemGroupedBackground,
                                        endColor:  UIColor(hex: "#f6f0e6") ?? .systemGroupedBackground)
        setupAdditionalSafeAreaInsets()
    }
    
    // 设置额外的安全区域边距，以适应隐藏导航栏后的布局
    private func setupAdditionalSafeAreaInsets() {
        // 为顶部添加额外的边距，模拟导航栏的高度
        let statusBarHeight = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let topInset: CGFloat = 10 // 额外顶部边距
        
        additionalSafeAreaInsets = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
    }
    
    // 递归遍历视图层次结构，应用自定义字体
    func applyCustomFontsToViews() {
        applyCustomFontToSubviews(view)
    }
    
    private func applyCustomFontToSubviews(_ view: UIView) {
        // 确保有自定义字体
        guard let customFont = UIFont.customDefaultFont else { return }
        
        // 遍历所有子视图
        for subview in view.subviews {
            // 处理标签
            if let label = subview as? UILabel {
                let fontSize = label.font.pointSize
                label.font = customFont.withSize(fontSize)
            }
            
            // 处理按钮
            if let button = subview as? UIButton, let titleLabel = button.titleLabel {
                let fontSize = titleLabel.font.pointSize
                titleLabel.font = customFont.withSize(fontSize)
            }
            
            // 处理文本框
            if let textField = subview as? UITextField {
                let fontSize = textField.font?.pointSize ?? UIFont.systemFontSize
                textField.font = customFont.withSize(fontSize)
            }
            
            // 处理文本视图
            if let textView = subview as? UITextView {
                let fontSize = textView.font?.pointSize ?? UIFont.systemFontSize
                textView.font = customFont.withSize(fontSize)
            }
            
            // 递归处理子视图
            applyCustomFontToSubviews(subview)
        }
    }
    
    // 在视图出现前应用字体并隐藏导航栏
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyCustomFontsToViews()
        
        // 隐藏导航栏
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // 在视图消失前重置导航栏状态
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 如果下一个视图控制器不是继承自BaseViewController，则恢复导航栏显示
        // 这样可以防止其他库或系统视图控制器出现问题
        if let nextVC = navigationController?.topViewController {
            if !(nextVC is BaseViewController) {
                navigationController?.setNavigationBarHidden(false, animated: animated)
            }
        }
    }
    
    // 为子类提供的方法，用于特定控件设置自定义字体
    func applyCustomFont(to label: UILabel, size: CGFloat? = nil) {
        if let customFont = UIFont.customDefaultFont {
            let fontSize = size ?? label.font.pointSize
            label.font = customFont.withSize(fontSize)
        }
    }
    
    func applyCustomFont(to button: UIButton, size: CGFloat? = nil) {
        if let customFont = UIFont.customDefaultFont, let titleLabel = button.titleLabel {
            let fontSize = size ?? titleLabel.font.pointSize
            titleLabel.font = customFont.withSize(fontSize)
        }
    }
    
    func applyCustomFont(to textField: UITextField, size: CGFloat? = nil) {
        if let customFont = UIFont.customDefaultFont {
            let fontSize = size ?? textField.font?.pointSize ?? UIFont.systemFontSize
            textField.font = customFont.withSize(fontSize)
        }
    }
    
    func applyCustomFont(to textView: UITextView, size: CGFloat? = nil) {
        if let customFont = UIFont.customDefaultFont {
            let fontSize = size ?? textView.font?.pointSize ?? UIFont.systemFontSize
            textView.font = customFont.withSize(fontSize)
        }
    }
} 
