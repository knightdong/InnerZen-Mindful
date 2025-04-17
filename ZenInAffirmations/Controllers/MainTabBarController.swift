import UIKit

class CustomTabBar: UIView {
    
    // 回调函数，当用户点击某个标签时触发
    var onTabSelected: ((Int) -> Void)?
    
    // 标签按钮数组
    private var tabButtons: [UIButton] = []
    
    // 当前选中的标签索引
    private var selectedIndex: Int = 0
    
    // 图标数组
    private let normalIcons = [
        UIImage(systemName: "sparkles"),
        UIImage(systemName: "leaf"),
        UIImage(systemName: "calendar"),
        UIImage(systemName: "heart"),
        UIImage(systemName: "figure.mind.and.body")
    ]
    
    private let selectedIcons = [
        UIImage(systemName: "sparkles"),
        UIImage(systemName: "leaf.fill"),
        UIImage(systemName: "calendar.badge.clock"),
        UIImage(systemName: "heart.fill"),
        UIImage(systemName: "figure.mind.and.body")
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .white
        
        // 添加阴影
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: -1)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 3
        
        // 初始化并添加五个标签按钮
        for i in 0..<5 {
            let button = UIButton(type: .system)
            
            // 增加图标大小配置
            let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
            let normalImage = normalIcons[i]?.withConfiguration(config)
            let selectedImage = selectedIcons[i]?.withConfiguration(config)
            
            button.setImage(normalImage, for: .normal)
            button.tintColor = .gray
            button.tag = i
            button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
            
            // 调整内容模式
            button.imageView?.contentMode = .center
            
            addSubview(button)
            tabButtons.append(button)
        }
        
        // 默认选中第一个标签
        selectTab(at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 计算每个标签按钮的宽度
        let buttonWidth = bounds.width / CGFloat(tabButtons.count)
        let buttonHeight = bounds.height - 10 // 留出安全区域
        
        // 设置每个标签按钮的位置
        for (index, button) in tabButtons.enumerated() {
            button.frame = CGRect(
                x: CGFloat(index) * buttonWidth,
                y: 0,
                width: buttonWidth,
                height: buttonHeight
            )
            
            // 添加上边距，让图标向上移动
            button.imageEdgeInsets = UIEdgeInsets(top: -10, left: 0, bottom: 10, right: 0)
        }
    }
    
    @objc private func tabButtonTapped(_ sender: UIButton) {
        // 添加触觉反馈
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
        
        selectTab(at: sender.tag)
        onTabSelected?(sender.tag)
    }
    
    func selectTab(at index: Int) {
        guard index >= 0 && index < tabButtons.count else { return }
        
        // 更新所有按钮状态
        for (i, button) in tabButtons.enumerated() {
            // 增加图标大小配置
            let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
            
            if i == index {
                let selectedImage = selectedIcons[i]?.withConfiguration(config)
                button.setImage(selectedImage, for: .normal)
                button.tintColor = UIColor(red: 0.2, green: 0.6, blue: 0.9, alpha: 1.0)
            } else {
                let normalImage = normalIcons[i]?.withConfiguration(config)
                button.setImage(normalImage, for: .normal)
                button.tintColor = .gray
            }
        }
        
        selectedIndex = index
    }
}

class MainTabBarController: UITabBarController {
    
    private let customTabBar = CustomTabBar()
    private let customTabBarHeight: CGFloat = 60
    private var isUpdatingSelection = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
        setupCustomTabBar()
        
        // 隐藏系统TabBar
        tabBar.isHidden = true
        
        // 初始选择第一个标签
        selectedIndex = 0
        customTabBar.selectTab(at: 0)
    }
    
    private func setupCustomTabBar() {
        view.addSubview(customTabBar)
        
        // 设置自定义TabBar位置
        customTabBar.frame = CGRect(
            x: 0,
            y: view.bounds.height - customTabBarHeight - view.safeAreaInsets.bottom,
            width: view.bounds.width,
            height: customTabBarHeight + view.safeAreaInsets.bottom
        )
        
        // 修复旋转屏幕时的位置问题
        view.bringSubviewToFront(customTabBar)
        
        // 处理标签点击事件
        customTabBar.onTabSelected = { [weak self] index in
            guard let self = self, !self.isUpdatingSelection else { return }
            
            self.isUpdatingSelection = true
            
            // 安全地检查索引是否有效
            if index >= 0 && index < (self.viewControllers?.count ?? 0) {
                if let viewControllers = self.viewControllers {
                    self.selectedViewController = viewControllers[index]
                }
            }
            
            self.isUpdatingSelection = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 更新自定义TabBar位置
        customTabBar.frame = CGRect(
            x: 0,
            y: view.bounds.height - customTabBarHeight - view.safeAreaInsets.bottom,
            width: view.bounds.width,
            height: customTabBarHeight + view.safeAreaInsets.bottom
        )
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // 当系统TabBar的项被选中时（如果没有完全隐藏），更新自定义TabBar的选中状态
        if let index = tabBar.items?.firstIndex(of: item) {
            customTabBar.selectTab(at: index)
        }
    }
    
    private func setupViewControllers() {
        // 情境练习页面（新的首页）
        let contextualVC = ContextualPracticeViewController()
        let contextualNav = UINavigationController(rootViewController: contextualVC)
        contextualNav.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "sparkles"),
            selectedImage: UIImage(systemName: "sparkles")
        )
        
        // 主页
        let homeVC = HomeViewController()
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "leaf"),
            selectedImage: UIImage(systemName: "leaf.fill")
        )
        
        // 每日打卡成就页
        let achievementVC = AchievementViewController()
        let achievementNav = UINavigationController(rootViewController: achievementVC)
        achievementNav.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "calendar"),
            selectedImage: UIImage(systemName: "calendar.badge.clock")
        )
        
        // 收藏与历史页面
        let favoritesVC = FavoritesViewController()
        let favoritesNav = UINavigationController(rootViewController: favoritesVC)
        favoritesNav.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        
        // 正念页面
        let mindfulnessVC = MindfulnessViewController()
        let mindfulnessNav = UINavigationController(rootViewController: mindfulnessVC)
        mindfulnessNav.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "figure.mind.and.body"),
            selectedImage: UIImage(systemName: "figure.mind.and.body")
        )
        
        // 设置标签控制器的子控制器
        viewControllers = [contextualNav, homeNav, achievementNav, favoritesNav, mindfulnessNav]
    }
    
    // 监听selectedIndex变化
    override var selectedIndex: Int {
        didSet {
            if !isUpdatingSelection {
                isUpdatingSelection = true
                customTabBar.selectTab(at: selectedIndex)
                isUpdatingSelection = false
            }
        }
    }
    
    // 监听selectedViewController变化
    override var selectedViewController: UIViewController? {
        didSet {
            if !isUpdatingSelection, let selectedVC = selectedViewController,
               let index = viewControllers?.firstIndex(of: selectedVC) {
                isUpdatingSelection = true
                customTabBar.selectTab(at: index)
                isUpdatingSelection = false
            }
        }
    }
} 
