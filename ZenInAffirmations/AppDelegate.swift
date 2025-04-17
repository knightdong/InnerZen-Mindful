//
//  AppDelegate.swift
//  ZenInAffirmations
//
//  Created by Tao Dong on 2025/4/10.
//

import UIKit
import SwiftyJSON
import IQKeyboardManager
import ProgressHUD

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 设置全局键盘管理器
        IQKeyboardManager.shared().isEnabled = true
        
        // 设置全局字体
        // setupGlobalFont()
        
        // 复制资源文件到应用程序包
        copyResourceFilesToBundle()
        
        // Create window
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Setup root view controller
        let homeViewController = HomeViewController()
        let navigationController = UINavigationController(rootViewController: homeViewController)
        
        // Setup navigation bar appearance
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.titleTextAttributes = [.foregroundColor: UIColor.darkGray]
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    private func setupGlobalFont() {
        // 设置全局默认字体为Oswald-Regular
        let fontName = "Ubuntu-Regular"
        
        // 确保字体有效
        guard let font = UIFont(name: fontName, size: UIFont.systemFontSize) else {
            print("警告: 未能加载字体 \(fontName)")
            return
        }
        
        // 添加UIFont扩展作为应用内的全局字体提供程序
        UIFont.customDefaultFont = font
        /*
        // 获取所有控件的外观代理
        let labelAppearance = UILabel.appearance()
        //let buttonAppearance = UIButton.appearance()
        //let textFieldAppearance = UITextField.appearance()
        //let textViewAppearance = UITextView.appearance()
        //let barButtonAppearance = UIBarButtonItem.appearance()
        ///let segmentedControlAppearance = UISegmentedControl.appearance()
        //let searchBarAppearance = UISearchBar.appearance()
        //let tabBarAppearance = UITabBar.appearance()
        
        // 为常用UI控件设置默认字体
        labelAppearance.font = font
       // textFieldAppearance.font = font
        //textViewAppearance.font = font
        
        // 设置导航栏标题字体
        let navigationBarAppearance = UINavigationBar.appearance()
        var titleTextAttributes = navigationBarAppearance.titleTextAttributes ?? [:]
        titleTextAttributes[.font] = UIFont(name: fontName, size: 17)
        navigationBarAppearance.titleTextAttributes = titleTextAttributes
        
        // 设置其他控件的字体
       // barButtonAppearance.setTitleTextAttributes([.font: UIFont(name: fontName, size: 14)!], for: .normal)
       // barButtonAppearance.setTitleTextAttributes([.font: UIFont(name: fontName, size: 14)!], for: .highlighted)
        
        // iOS 15及以上版本的导航栏外观
        if #available(iOS 15.0, *) {
            let navAppearance = UINavigationBarAppearance()
            navAppearance.configureWithOpaqueBackground()
            navAppearance.backgroundColor = .white
            navAppearance.titleTextAttributes = [.foregroundColor: UIColor.darkGray, .font: UIFont(name: fontName, size: 17)!]
            UINavigationBar.appearance().standardAppearance = navAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
            
            // 设置TabBar外观
            let tabAppearance = UITabBarAppearance()
            tabAppearance.configureWithOpaqueBackground()
            let tabItemAppearance = UITabBarItemAppearance()
            tabItemAppearance.normal.titleTextAttributes = [.font: UIFont(name: fontName, size: 10)!]
            tabItemAppearance.selected.titleTextAttributes = [.font: UIFont(name: fontName, size: 10)!]
            tabAppearance.stackedLayoutAppearance = tabItemAppearance
           // tabBarAppearance.standardAppearance = tabAppearance
           // tabBarAppearance.scrollEdgeAppearance = tabAppearance
        }
        */
        print("成功设置全局字体: \(fontName)")
    }
    
    private func copyResourceFilesToBundle() {
        // 查找 Resources 目录中的 JSON 文件
        if let resourcePath = Bundle.main.path(forResource: "affirmations", ofType: "json", inDirectory: "Resources") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: resourcePath))
                
                // 获取应用程序的文档目录
                if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    let destinationURL = documentsDirectory.appendingPathComponent("affirmations.json")
                    
                    // 写入文件
                    try data.write(to: destinationURL)
                    print("成功复制资源文件到: \(destinationURL.path)")
                }
            } catch {
                print("复制资源文件失败: \(error)")
            }
        } else {
            print("未找到资源文件 affirmations.json")
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

// 在AppDelegate.swift末尾添加UIFont扩展
extension UIFont {
    private static var _customDefaultFont: UIFont?
    
    static var customDefaultFont: UIFont? {
        get {
            return _customDefaultFont
        }
        set {
            _customDefaultFont = newValue
        }
    }
    
    // 提供适当大小的自定义字体
    static func customFont(ofSize size: CGFloat) -> UIFont {
        guard let customFont = customDefaultFont else {
            return UIFont.systemFont(ofSize: size)
        }
        
        return customFont.withSize(size)
    }
    
    // 替换系统字体方法 - 在应用代码中使用这些方法替代系统方法
    class func appSystemFont(ofSize size: CGFloat) -> UIFont {
        guard let customFont = customDefaultFont else {
            return UIFont.systemFont(ofSize: size)
        }
        return customFont.withSize(size)
    }
    
    class func appSystemFont(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        guard let customFont = customDefaultFont else {
            return UIFont.systemFont(ofSize: size, weight: weight)
        }
        return customFont.withSize(size)
    }
    
    class func appBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        guard let customFont = customDefaultFont else {
            return UIFont.boldSystemFont(ofSize: size)
        }
        // 尝试使用粗体版本的自定义字体
        if let boldDescriptor = customFont.fontDescriptor.withSymbolicTraits(.traitBold) {
            return UIFont(descriptor: boldDescriptor, size: size)
        }
        // 如果没有粗体版本，则返回原始字体
        return customFont.withSize(size)
    }
}

// 重载UIButton的标题字体设置方法
extension UIButton {
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        // 如果有自定义全局字体，应用到按钮
        if let customFont = UIFont.customDefaultFont, let titleLabel = self.titleLabel {
            let currentSize = titleLabel.font.pointSize
            titleLabel.font = customFont.withSize(currentSize)
        }
    }
}

// 添加TextView和TextField的扩展，确保它们也使用自定义字体
extension UITextField {
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        if let customFont = UIFont.customDefaultFont {
            let currentSize = font?.pointSize ?? UIFont.systemFontSize
            font = customFont.withSize(currentSize)
        }
    }
}

extension UITextView {
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        if let customFont = UIFont.customDefaultFont {
            let currentSize = font?.pointSize ?? UIFont.systemFontSize
            font = customFont.withSize(currentSize)
        }
    }
}

