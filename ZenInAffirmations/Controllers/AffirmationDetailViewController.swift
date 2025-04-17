import UIKit
import AVFoundation
import ProgressHUD
import SnapKit

class AffirmationDetailViewController: BaseViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate, ThemeSelectionDelegate {
    
    // MARK: - Properties
    private let dataManager = AffirmationDataManager.shared
    private let favoriteManager = FavoriteManager.shared
    private var currentAffirmation: Affirmation
    private var allAffirmations: [Affirmation] = []
    private var categoryAffirmations: [Affirmation] = [] // 存储特定分类的语录
    private var viewedAffirmations: Set<String> = [] // 记录已查看的语录
    private var fromCategory: Bool = false // 标记是否从分类进入
    private var currentCategory: AffirmationCategory? // 当前分类
    
    // 新增：成就视图控制器引用，用于记录每日统计
    private lazy var achievementVC = AchievementViewController()
    
    // 音频相关
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var isRecording = false
    
    // 主题设置
    private var currentTheme: ThemeType = .sunset
    
    // 手势识别
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var initialTouchPoint: CGPoint = CGPoint.zero
    
    // 动画状态跟踪
    private var isAnimating = false
    private var currentAnimationWorkItem: DispatchWorkItem?
    private var temporaryLabel: UILabel?
    
    // MARK: - UI Components
    private let gradientView: GradientView = {
        let view = GradientView()
        view.startColor = UIColor(red: 0.4, green: 0.8, blue: 0.9, alpha: 1.0)
        view.endColor = UIColor(red: 0.2, green: 0.6, blue: 0.8, alpha: 1.0)
        return view
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isHidden = true
        return imageView
    }()
    
    private let videoContainerView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    private let affirmationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 1, height: 1)
        label.layer.shadowRadius = 3
        label.layer.shadowOpacity = 0.3
        return label
    }()
    
    private let bottomToolbar: UIView = {
        let view = UIView()
        // 移除工具栏背景
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .white
        // 添加阴影
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.25
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .white
        // 添加阴影
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.5
        return button
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .white
        // 添加阴影
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.5
        return button
    }()
    
    private let themeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "paintpalette"), for: .normal)
        button.tintColor = .white
        // 添加阴影
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.5
        return button
    }()
    
    private let recordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "mic"), for: .normal)
        button.tintColor = .white
        // 添加阴影
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.5
        return button
    }()
    
    // MARK: - Initialization
    init(affirmation: Affirmation) {
        self.currentAffirmation = affirmation
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
        self.fromCategory = false
    }
    
    // 从分类进入的初始化方法
    init(affirmation: Affirmation, category: AffirmationCategory) {
        self.currentAffirmation = affirmation
        self.currentCategory = category
        self.fromCategory = true
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadAllAffirmations()
        updateUI()
        setupGestures()
        
        // 当进入详情页面时，自动计为阅读一次
        //achievementVC.didReadAffirmation()
        
        // Debug: Print stored data when view loads
        print("AffirmationDetailViewController - viewDidLoad for affirmation: \(currentAffirmation.id)")
        favoriteManager.printStoredData()
    }
    
    // MARK: - Setup
    private func setupViews() {
        // 添加背景视图
        view.addSubview(gradientView)
        view.addSubview(backgroundImageView)
        view.addSubview(videoContainerView)
        
        // 添加文本和工具栏
        view.addSubview(affirmationLabel)
        view.addSubview(bottomToolbar)
        
        // 添加按钮到工具栏
        bottomToolbar.addSubview(backButton)
        bottomToolbar.addSubview(shareButton)
        bottomToolbar.addSubview(favoriteButton)
        bottomToolbar.addSubview(themeButton)
        bottomToolbar.addSubview(recordButton)
        
        // 设置约束
        setupConstraints()
        
        // 设置按钮动作
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        themeButton.addTarget(self, action: #selector(themeButtonTapped), for: .touchUpInside)
        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        
        // 添加长按手势用于重新录制
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(recordButtonLongPressed(_:)))
        recordButton.addGestureRecognizer(longPressGesture)
        
        // 加载保存的主题设置
        loadThemeSettings()
    }
    
    private func setupConstraints() {
        // 背景视图
        gradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        videoContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 语录文本
        affirmationLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(30)
        }
        
        // 底部工具栏 - 考虑安全区域
        bottomToolbar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(80)
        }
        
        // 工具栏按钮
        let buttonSize: CGFloat = 44
        let spacing: CGFloat = (UIScreen.main.bounds.width - buttonSize * 5) / 6
        
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(spacing)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(buttonSize)
        }
        
        shareButton.snp.makeConstraints { make in
            make.left.equalTo(backButton.snp.right).offset(spacing)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(buttonSize)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.left.equalTo(shareButton.snp.right).offset(spacing)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(buttonSize)
        }
        
        themeButton.snp.makeConstraints { make in
            make.left.equalTo(favoriteButton.snp.right).offset(spacing)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(buttonSize)
        }
        
        recordButton.snp.makeConstraints { make in
            make.left.equalTo(themeButton.snp.right).offset(spacing)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(buttonSize)
        }
    }
    
    private func setupGestures() {
        // 添加全屏上下滑动手势
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.delegate = self
        
        // 添加双击收藏手势
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapGesture)
    }
    
    // MARK: - Data Loading
    private func loadAllAffirmations() {
        // 获取所有语录
        allAffirmations = []
        
        // 获取所有分类
        let categories = dataManager.getAllCategories()
        
        // 合并所有分类的语录
        for category in categories {
            let categoryAffirmations = dataManager.getAffirmations(for: category)
            allAffirmations.append(contentsOf: categoryAffirmations)
        }
        
        // 如果没有数据，添加默认语录
        if allAffirmations.isEmpty {
            allAffirmations = [
                Affirmation(content: "每一天都是新的开始", category: "general"),
                Affirmation(content: "今天会比昨天更好", category: "general"),
                Affirmation(content: "我充满力量和希望", category: "general")
            ]
        }
        
        // 如果是从分类进入，加载该分类下的所有语录
        if fromCategory && currentCategory != nil {
            categoryAffirmations = dataManager.getAffirmations(for: currentCategory!)
            print("Loaded \(categoryAffirmations.count) affirmations for category: \(currentCategory!.displayName)")
        }
        
        // 初始化已查看集合，将当前语录添加进去
        viewedAffirmations.insert(currentAffirmation.content)
    }
    
    private func loadThemeSettings() {
        // 从UserDefaults加载主题设置
        if let savedTheme = UserDefaults.standard.string(forKey: "selectedTheme"),
           let theme = ThemeType(rawValue: savedTheme) {
            currentTheme = theme
        } else {
            // 使用默认主题
            currentTheme = .sunset
        }
        
        updateTheme()
    }
    
    // MARK: - UI Updates
    private func updateUI() {
        affirmationLabel.text = currentAffirmation.content
        
        // 检查是否有录音，有则显示播放按钮
        updateRecordButtonState()
        
        // 更新收藏状态
        updateFavoriteButtonState()
    }
    
    private func updateTheme() {
        // 隐藏所有背景
        gradientView.isHidden = false
        backgroundImageView.isHidden = true
        videoContainerView.isHidden = true
        
        // 根据主题类型设置不同的背景
        if currentTheme.isWallpaper {
            // 使用图片背景
            if let imageName = currentTheme.imageName, let image = UIImage(named: imageName) {
                backgroundImageView.image = image
                backgroundImageView.isHidden = false
                gradientView.isHidden = true
            } else {
                // 如果图片加载失败，则回退到渐变色
                setGradientForCurrentTheme()
            }
        } else {
            // 使用渐变色背景
            setGradientForCurrentTheme()
        }
    }
    
    private func setGradientForCurrentTheme() {
        // 使用主题的背景颜色设置渐变色
        let themeColor = currentTheme.backgroundColor
        
        // 创建略微不同的结束颜色以产生渐变效果
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        if themeColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            // 稍微调整色调作为结束颜色
            let endHue = fmod(hue + 0.05, 1.0)
            let endColor = UIColor(hue: endHue, saturation: saturation, brightness: max(0.0, brightness - 0.2), alpha: alpha)
            
            gradientView.startColor = themeColor
            gradientView.endColor = endColor
        } else {
            // 如果getHue失败，使用默认渐变
            gradientView.startColor = themeColor
            gradientView.endColor = themeColor.withAlphaComponent(0.7)
        }
        
        gradientView.setNeedsDisplay()
    }
    
    private func setBackgroundImageForCurrentAffirmation() {
        // 根据当前语录的分类设置背景图片
        if let categoryIndex = findCategoryIndex(for: currentAffirmation.category) {
            let backgroundImageName = "detail_bg\(categoryIndex)"
            backgroundImageView.image = UIImage(named: backgroundImageName) ?? UIImage(named: "default_background")
        } else {
            backgroundImageView.image = UIImage(named: "default_background")
        }
    }
    
    private func setBackgroundVideoForCurrentAffirmation() {
        // 实现视频背景的播放
        // 省略具体实现...
    }
    
    private func updateRecordButtonState() {
        // 检查是否有录音文件
        let audioURL = getAudioFileURL(for: currentAffirmation)
        if FileManager.default.fileExists(atPath: audioURL.path) {
            recordButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            recordButton.setImage(UIImage(systemName: "mic"), for: .normal)
        }
        
        // 确保按钮颜色恢复为白色（解决停止录音后按钮仍为红色的问题）
        recordButton.tintColor = .white
    }
    
    private func updateFavoriteButtonState() {
        // 检查是否是收藏的语录
        let isFavorite = dataManager.isFavorite(for: currentAffirmation)
        favoriteButton.setImage(UIImage(systemName: isFavorite ? "heart.fill" : "heart"), for: .normal)
        favoriteButton.tintColor = isFavorite ? .systemRed : .white
    }
    
    // MARK: - Navigation
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Actions
    @objc private func shareButtonTapped() {
        // 添加调试日志
        print("分享图片 - 当前主题: \(currentTheme.rawValue), 是否壁纸: \(currentTheme.isWallpaper), 图片名称: \(currentTheme.imageName ?? "无")")
        
        // 生成分享图片
        let imageToShare = generateShareImage()
        
        // 弹出分享选项
        let activityViewController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        
        // 设置分享完成的回调
        activityViewController.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            if completed {
                // 分享成功，显示提示
                if let activityType = activityType {
                    if activityType.rawValue == "com.apple.UIKit.activity.SaveToCameraRoll" {
                        // 保存到相册成功
                        ProgressHUD.succeed("Image saved successfully")
                    } else {
                        // 其他分享成功
                        ProgressHUD.succeed("Shared successfully")
                    }
                } else {
                    // 未指定活动类型但成功完成
                    ProgressHUD.succeed("Shared successfully")
                }
            }
        }
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    @objc private func favoriteButtonTapped() {
        // 收藏功能
        let newStatus = dataManager.toggleFavorite(for: currentAffirmation)
        
        // 更新按钮状态
        if newStatus {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favoriteButton.tintColor = .systemRed
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            favoriteButton.tintColor = .white
        }
        
        // 更新当前语录的收藏状态
        currentAffirmation.isFavorite = newStatus
        
        // 提供触觉反馈
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        // Debug: Print stored data after favorite change
        print("After favorite change - Affirmation ID: \(currentAffirmation.id), Favorited: \(newStatus)")
        favoriteManager.printStoredData()
        
        // Refresh Favorites view controller if it exists
        notifyFavoritesViewControllerToRefresh()
    }
    
    @objc private func themeButtonTapped() {
        // 显示主题选择控制器
        let themeVC = ThemeSelectionViewController(currentTheme: currentTheme)
        themeVC.delegate = self
        present(themeVC, animated: true)
    }
    
    @objc private func recordButtonTapped() {
        // 检查是否有录音
        let audioURL = getAudioFileURL(for: currentAffirmation)
        
        if FileManager.default.fileExists(atPath: audioURL.path) {
            // 有录音，播放
            if audioPlayer?.isPlaying == true {
                stopPlayback()
            } else {
                playRecordedAudio()
            }
        } else {
            // 没有录音，开始录制
            if isRecording {
                stopRecording()
            } else {
                startRecording()
            }
        }
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let touchPoint = gesture.translation(in: view)
        
        switch gesture.state {
        case .began:
            initialTouchPoint = touchPoint
        case .changed:
            // 让文本标签跟随手指移动
            let moveDistance = touchPoint.y
            
            // 根据滑动距离设置视图的透明度
            let alpha = min(1.0, max(0.5, 1.0 - abs(moveDistance) / 300))
            affirmationLabel.alpha = alpha
            
            // 添加向上或向下的变换，让文本跟随手指移动
            affirmationLabel.transform = CGAffineTransform(translationX: 0, y: moveDistance)
            
        case .ended, .cancelled:
            // 修改为总是根据方向切换，不考虑距离
            if touchPoint.y < 0 { // 上滑，任何距离
                showNextAffirmation()
            } else if touchPoint.y > 0 { // 下滑，任何距离
                showPreviousAffirmation()
            } else {
                // 完全没有移动时恢复到原位
                UIView.animate(withDuration: 0.3) {
                    self.affirmationLabel.transform = .identity
                    self.affirmationLabel.alpha = 1.0
                }
            }
        default:
            break
        }
    }
    
    // MARK: - Navigation
    private func showNextAffirmation() {
        // 随机选择一条不同的语录
        if let nextAffirmation = getRandomAffirmation() {
            // 下一条语录应该从下方滑入
            animateAffirmationTransition(to: nextAffirmation, direction: .down)
        }
    }
    
    private func showPreviousAffirmation() {
        // 随机选择一条不同的语录
        if let prevAffirmation = getRandomAffirmation() {
            // 上一条语录应该从上方滑入
            animateAffirmationTransition(to: prevAffirmation, direction: .up)
        }
    }
    
    private func getRandomAffirmation() -> Affirmation? {
        // 如果是从分类进入，优先显示同一分类下的未查看语录
        if fromCategory && currentCategory != nil {
            // 过滤出当前分类下尚未查看的语录
            let unviewedInCategory = categoryAffirmations.filter { 
                !viewedAffirmations.contains($0.content) 
            }
            
            if !unviewedInCategory.isEmpty {
                // 随机选择一条未查看的分类内语录
                let randomAffirmation = unviewedInCategory.randomElement()!
                // 添加到已查看集合
                viewedAffirmations.insert(randomAffirmation.content)
                return randomAffirmation
            }
            
            // 如果该分类内的语录已全部查看过，提示用户
            ProgressHUD.succeed("All affirmations in this category viewed. Showing other categories.")
            
            // 获取下一个分类
            let allCategories = dataManager.getAllCategories()
            if let currentIndex = allCategories.firstIndex(of: currentCategory!),
               let nextCategory = getNextCategory(from: allCategories, currentIndex: currentIndex) {
                // 切换到下一个分类
                currentCategory = nextCategory
                // 更新该分类下的语录
                categoryAffirmations = dataManager.getAffirmations(for: nextCategory)
                // 随机选择一条该分类下的语录
                if let nextCategoryAffirmation = categoryAffirmations.randomElement() {
                    viewedAffirmations.insert(nextCategoryAffirmation.content)
                    return nextCategoryAffirmation
                }
            }
        }
        
        // 否则，从所有未查看的语录中随机选择
        let unviewedGlobal = allAffirmations.filter { 
            !viewedAffirmations.contains($0.content) && $0.content != currentAffirmation.content 
        }
        
        if !unviewedGlobal.isEmpty {
            let randomAffirmation = unviewedGlobal.randomElement()!
            viewedAffirmations.insert(randomAffirmation.content)
            return randomAffirmation
        }
        
        // 如果所有语录都已查看，重置已查看集合，仅保留当前语录
        viewedAffirmations = [currentAffirmation.content]
        
        // 随机选择一条不同于当前语录的语录
        let filteredAffirmations = allAffirmations.filter { $0.content != currentAffirmation.content }
        return filteredAffirmations.randomElement()
    }
    
    // 获取下一个非空分类
    private func getNextCategory(from categories: [AffirmationCategory], currentIndex: Int) -> AffirmationCategory? {
        var nextIndex = (currentIndex + 1) % categories.count
        var attempts = 0
        
        // 尝试最多一个循环找到非空分类
        while attempts < categories.count {
            let nextCategory = categories[nextIndex]
            let categoryAffirmations = dataManager.getAffirmations(for: nextCategory)
            
            if !categoryAffirmations.isEmpty {
                return nextCategory
            }
            
            nextIndex = (nextIndex + 1) % categories.count
            attempts += 1
        }
        
        return nil // 没有找到非空分类
    }
    
    private enum TransitionDirection {
        case up, down
    }
    
    private func animateAffirmationTransition(to newAffirmation: Affirmation, direction: TransitionDirection) {
        // 如果正在播放录音，先停止播放
        if audioPlayer?.isPlaying == true {
            stopPlayback()
        }
        
        // 如果已经在动画中，取消当前动画
        if isAnimating {
            // 取消之前的延迟执行工作项
            currentAnimationWorkItem?.cancel()
            
            // 立即完成当前动画，确保视图状态一致
            cleanupCurrentAnimation()
        }
        
        // 设置动画状态为正在进行
        isAnimating = true
        
        let screenHeight = view.bounds.height
        let offscreenYPosition: CGFloat = direction == .up ? -screenHeight : screenHeight
        
        // 创建一个新的标签用于动画
        let newLabel = UILabel()
        newLabel.textAlignment = .center
        newLabel.numberOfLines = 0
        newLabel.textColor = .white
        newLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        newLabel.layer.shadowColor = UIColor.black.cgColor
        newLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
        newLabel.layer.shadowRadius = 3
        newLabel.layer.shadowOpacity = 0.3
        newLabel.text = newAffirmation.content
        newLabel.alpha = 0
        
        // 保存对临时标签的引用
        temporaryLabel = newLabel
        
        view.addSubview(newLabel)
        newLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(30)
        }
        
        // 移动新标签到屏幕外
        newLabel.transform = CGAffineTransform(translationX: 0, y: offscreenYPosition)
        
        // 创建一个动画完成后的工作项
        let animationWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            
            // 更新当前语录
            self.currentAffirmation = newAffirmation
            
            // 更新背景和UI
            self.updateTheme()
            self.updateUI()
            
            // 删除临时标签，重置主标签
            self.temporaryLabel?.removeFromSuperview()
            self.temporaryLabel = nil
            self.affirmationLabel.transform = .identity
            self.affirmationLabel.alpha = 1
            self.affirmationLabel.text = newAffirmation.content
            
            // 检查是否有录音并播放
            self.checkAndPlayRecording()
            
            // 切换到新语录时，增加阅读计数
            self.achievementVC.didReadAffirmation()
            
            // 重置动画状态
            self.isAnimating = false
            self.currentAnimationWorkItem = nil
        }
        
        // 保存当前工作项的引用
        currentAnimationWorkItem = animationWorkItem
        
        // 动画切换
        UIView.animate(withDuration: 0.5, animations: {
            // 当前标签移出屏幕
            self.affirmationLabel.transform = CGAffineTransform(translationX: 0, y: -offscreenYPosition)
            self.affirmationLabel.alpha = 0
            
            // 新标签移入屏幕
            newLabel.transform = .identity
            newLabel.alpha = 1
        }) { [weak self] completed in
            guard let self = self else { return }
            
            // 只有在动画完成并且没有被取消的情况下执行完成操作
            if completed && !animationWorkItem.isCancelled {
                // 使用主线程执行完成操作
                DispatchQueue.main.async {
                    animationWorkItem.perform()
                }
            }
        }
    }
    
    // 清理当前动画的方法
    private func cleanupCurrentAnimation() {
        // 停止所有视图动画
        affirmationLabel.layer.removeAllAnimations()
        temporaryLabel?.layer.removeAllAnimations()
        
        // 删除临时标签
        temporaryLabel?.removeFromSuperview()
        temporaryLabel = nil
        
        // 重置主标签
        affirmationLabel.transform = .identity
        affirmationLabel.alpha = 1
    }
    
    // MARK: - Audio Recording & Playback
    private func startRecording() {
        // 停止背景音乐
        stopBackgroundMusicIfNeeded()
        
        // 请求麦克风权限
        requestMicrophonePermission { [weak self] granted in
            guard let self = self, granted else { return }
            
            // 准备录音设置
            let audioSession = AVAudioSession.sharedInstance()
            
            do {
                try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
                try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
                
                // 录音设置 - 使用线性PCM格式，这是一种更简单和兼容性更好的格式
                let settings: [String: Any] = [
                    AVFormatIDKey: Int(kAudioFormatLinearPCM),
                    AVSampleRateKey: 44100.0,
                    AVNumberOfChannelsKey: 1,
                    AVLinearPCMBitDepthKey: 16,
                    AVLinearPCMIsFloatKey: false,
                    AVLinearPCMIsBigEndianKey: false,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                ]
                
                // 创建录音器
                let audioURL = self.getAudioFileURL(for: self.currentAffirmation)
                
                // 确保目录存在
                try FileManager.default.createDirectory(at: audioURL.deletingLastPathComponent(), 
                                                       withIntermediateDirectories: true,
                                                       attributes: nil)
                
                // 如果文件已存在，先删除
                if FileManager.default.fileExists(atPath: audioURL.path) {
                    try FileManager.default.removeItem(at: audioURL)
                }
                
                self.audioRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
                
                guard let recorder = self.audioRecorder else {
                    print("Could not create audio recorder")
                    return
                }
                
                recorder.delegate = self
                recorder.isMeteringEnabled = true
                
                if recorder.prepareToRecord() && recorder.record() {
                    self.isRecording = true
                    
                    // 更新按钮状态
                    DispatchQueue.main.async {
                        self.recordButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
                        self.recordButton.tintColor = .red
                    }
                    
                    print("Started recording to: \(audioURL.path)")
                } else {
                    print("Failed to start recording")
                }
            } catch {
                print("Recording setup failed: \(error.localizedDescription)")
                self.isRecording = false
            }
        }
    }
    
    private func stopRecording() {
        guard let recorder = audioRecorder, isRecording else { 
            print("No active recording")
            return 
        }
        
        print("Stopping recording...")
        recorder.stop()
        isRecording = false
        
       
        // 更新按钮状态 - 这里不要立即更新按钮，因为马上会自动播放
        // 录音完成后会自动进入播放状态，由播放函数更新按钮
        
        // 使用延迟确保文件已完全保存
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            // 验证文件是否正确保存
            let audioURL = self.getAudioFileURL(for: self.currentAffirmation)
            if FileManager.default.fileExists(atPath: audioURL.path) {
                print("Recording file saved: \(audioURL.path)")
                
                // 检查文件大小
                do {
                    let attributes = try FileManager.default.attributesOfItem(atPath: audioURL.path)
                    if let fileSize = attributes[.size] as? NSNumber {
                        print("Recording file size: \(fileSize.intValue) bytes")
                        
                        // 如果文件大小小于一定值，可能是无效录音
                        if fileSize.intValue < 1000 {
                            print("Recording file too small, possibly invalid, deleting file")
                            try? FileManager.default.removeItem(at: audioURL)
                            self.updateRecordButtonState()
                        } else {
                            // 文件有效，自动播放一次
                            print("Recording complete, preparing to auto-play")
                            DispatchQueue.main.async {
                                self.playRecordedAudio()
                            }
                        }
                    }
                } catch {
                    print("Failed to get file attributes: \(error)")
                }
            } else {
                print("Recording file not found")
                self.updateRecordButtonState() // 确保按钮状态正确
            }
        }
    }
    
    private func playRecordedAudio() {
        // 停止背景音乐
        stopBackgroundMusicIfNeeded()
        
        let audioURL = getAudioFileURL(for: currentAffirmation)
        print("Attempting to play recording: \(audioURL.path)")
        
        if !FileManager.default.fileExists(atPath: audioURL.path) {
            print("File does not exist: \(audioURL.path)")
            updateRecordButtonState()
            return
        }
        
        // 确保录音路径保存到FavoriteManager
        if dataManager.getRecordingPath(for: currentAffirmation) == nil {
            print("录音文件存在但未记录在FavoriteManager中，现在添加记录")
            saveRecordingPath(audioURL)
        }
        
        // 录音完成，增加录音计数
        achievementVC.didReciteAffirmation()
        
        // 准备音频会话
        do {
            // 重置任何现有的音频会话
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
            
            let audioSession = AVAudioSession.sharedInstance()
            // 不要在playback类别中使用defaultToSpeaker选项，这是导致错误的原因
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
            
            // 创建播放器
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            
            guard let player = audioPlayer else {
                print("Could not create audio player")
                return
            }
            
            player.delegate = self
            player.volume = 1.0
            
            if player.prepareToPlay() && player.play() {
                print("Started playing recording")
                // 更新按钮状态为播放中
                DispatchQueue.main.async {
                    self.recordButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
                    self.recordButton.tintColor = .systemBlue // 使用蓝色表示播放中，区别于录音的红色
                }
            } else {
                print("Player failed to start")
                updateRecordButtonState()
            }
        } catch {
            print("Playback failed: \(error.localizedDescription)")
            // 尝试不同的播放方式
            tryAlternativePlayback(audioURL: audioURL)
        }
    }
    
    private func tryAlternativePlayback(audioURL: URL) {
        print("Trying alternative playback method")
        do {
            let audioSession = AVAudioSession.sharedInstance()
            // 尝试使用playAndRecord类别，因为它支持defaultToSpeaker选项
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try audioSession.setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            guard let player = audioPlayer else { return }
            
            player.delegate = self
            if player.prepareToPlay() && player.play() {
                print("Alternative method successful")
                DispatchQueue.main.async {
                    self.recordButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
                    self.recordButton.tintColor = .systemBlue // 使用蓝色表示播放中
                }
            } else {
                print("Alternative playback method failed")
                updateRecordButtonState()
                // 文件可能损坏，删除
                try? FileManager.default.removeItem(at: audioURL)
            }
        } catch {
            print("Alternative playback error: \(error)")
            updateRecordButtonState()
            // 文件可能损坏，删除
            try? FileManager.default.removeItem(at: audioURL)
        }
    }
    
    private func stopPlayback() {
        print("Stopping playback")
        audioPlayer?.stop()
        audioPlayer = nil
        
        // 更新按钮状态
        updateRecordButtonState() // 使用统一的方法更新按钮状态
        
        // 停用音频会话
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("Could not deactivate audio session: \(error)")
        }
    }
    
    private func checkAndPlayRecording() {
        // 检查是否有录音并自动播放
        let audioURL = getAudioFileURL(for: currentAffirmation)
        if FileManager.default.fileExists(atPath: audioURL.path) {
            playRecordedAudio()
        }
    }
    
    private func getAudioFileURL(for affirmation: Affirmation) -> URL {
        // 使用语录ID作为唯一标识符，避免哈希值不一致问题
        // 原来的方式使用内容哈希可能会导致相同内容在不同会话中产生不同哈希值
        let affirmationId = affirmation.id
        
        // 更改文件扩展名为.caf (Core Audio Format)，这是iOS原生支持的格式
        let fileName = "recording_\(affirmationId).caf"
        
        // 获取文档目录
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let recordingsDirectory = documentsDirectory.appendingPathComponent("Recordings", isDirectory: true)
        
        // 确保Recordings目录存在
        if !FileManager.default.fileExists(atPath: recordingsDirectory.path) {
            do {
                try FileManager.default.createDirectory(at: recordingsDirectory, 
                                                       withIntermediateDirectories: true,
                                                       attributes: nil)
                print("录音目录已创建: \(recordingsDirectory.path)")
            } catch {
                print("创建录音目录失败: \(error.localizedDescription)")
            }
        }
        
        return recordingsDirectory.appendingPathComponent(fileName)
    }
    
    private func requestMicrophonePermission(completion: @escaping (Bool) -> Void) {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                if !granted {
                    self.showMicrophoneAccessAlert()
                }
                completion(granted)
            }
        }
    }
    
    private func showMicrophoneAccessAlert() {
        let alert = UIAlertController(
            title: "Microphone Access Required",
            message: "Please allow microphone access in Settings to record audio",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        
        present(alert, animated: true)
    }
    
    // MARK: - ThemeSelectionDelegate
    func didSelectTheme(_ theme: ThemeType) {
        currentTheme = theme
        updateTheme()
    }
    
    // MARK: - Sharing
    private func generateShareImage() -> UIImage {
        // 图片尺寸 - 不包括底部工具栏
        let toolbarHeight: CGFloat = 80
        let imageSize = CGSize(width: view.bounds.width, height: view.bounds.height - toolbarHeight)
        
        // 使用ShareImageGenerator生成分享图片
        return ShareImageGenerator.generateImageWithTheme(
            text: currentAffirmation.content,
            theme: currentTheme,
            size: imageSize
        )
    }
    
    // MARK: - Helpers
    private func findCategoryIndex(for categoryName: String) -> Int? {
        return AffirmationCategory.allCases.firstIndex { $0.rawValue == categoryName }
    }
    
    // MARK: - 重新录制功能
    @objc private func recordButtonLongPressed(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            // 检查是否有录音文件
            let audioURL = getAudioFileURL(for: currentAffirmation)
            if FileManager.default.fileExists(atPath: audioURL.path) {
                // 弹出操作菜单
                let alertController = UIAlertController(
                    title: "Recording Options",
                    message: "What would you like to do with the existing recording?",
                    preferredStyle: .actionSheet
                )
                
                alertController.addAction(UIAlertAction(title: "Re-record", style: .default) { [weak self] _ in
                    guard let self = self else { return }
                    
                    // 如果正在播放，先停止播放
                    if self.audioPlayer?.isPlaying == true {
                        self.stopPlayback()
                    }
                    
                    // 删除现有录音
                    try? FileManager.default.removeItem(at: audioURL)
                    
                    // 更新FavoriteManager
                    self.dataManager.removeRecording(for: self.currentAffirmation)
                    
                    // 刷新收藏页面
                    self.notifyFavoritesViewControllerToRefresh()
                    
                    // 立即开始新录音
                    self.startRecording()
                })
                
                alertController.addAction(UIAlertAction(title: "Delete Recording", style: .destructive) { [weak self] _ in
                    guard let self = self else { return }
                    
                    // 如果正在播放，先停止播放
                    if self.audioPlayer?.isPlaying == true {
                        self.stopPlayback()
                    }
                    
                    // 删除录音
                    try? FileManager.default.removeItem(at: audioURL)
                    
                    // 更新FavoriteManager
                    self.dataManager.removeRecording(for: self.currentAffirmation)
                    
                    // 刷新收藏页面
                    self.notifyFavoritesViewControllerToRefresh()
                    
                    self.updateRecordButtonState()
                })
                
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                
                // 在iPad上需要设置弹出框的来源视图
                if let popoverController = alertController.popoverPresentationController {
                    popoverController.sourceView = self.recordButton
                    popoverController.sourceRect = self.recordButton.bounds
                }
                
                present(alertController, animated: true)
            }
        }
    }
    
    // MARK: - AVAudioRecorderDelegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        isRecording = false
        updateRecordButtonState()
        
        if flag {
            // 录音成功，保存路径到FavoriteManager
            saveRecordingPath(recorder.url)
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Recording error: \(error?.localizedDescription ?? "unknown error")")
        isRecording = false
        updateRecordButtonState()
    }
    
    // MARK: - AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updateRecordButtonState()
        
        // Show hint after first playback
        if !UserDefaults.standard.bool(forKey: "hasShownLongPressHint") {
            showLongPressHint()
            UserDefaults.standard.set(true, forKey: "hasShownLongPressHint")
        }
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Playback error: \(error?.localizedDescription ?? "unknown error")")
        updateRecordButtonState()
    }
    
    // MARK: - Helper Methods
    private func showLongPressHint() {
        let hintView = UIView()
        hintView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        hintView.layer.cornerRadius = 10
        
        let hintLabel = UILabel()
        hintLabel.text = "Tip: Long press to re-record"
        hintLabel.textColor = .white
        hintLabel.textAlignment = .center
        hintLabel.font = UIFont.systemFont(ofSize: 14)
        
        hintView.addSubview(hintLabel)
        view.addSubview(hintView)
        
        hintLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        // Make the hint view adaptive with better positioning
        hintView.snp.makeConstraints { make in
            // Center the hint to the record button
            make.centerX.equalTo(recordButton)
            make.bottom.equalTo(recordButton.snp.top).offset(-10)
            // Set minimum width but allow expansion based on content
            make.width.greaterThanOrEqualTo(120)
            // Ensure it stays within screen bounds with margins
            make.left.greaterThanOrEqualTo(view.safeAreaLayoutGuide.snp.left).offset(20)
            make.right.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.right).offset(-20)
        }
        
        // Auto-hide after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 0.5, animations: {
                hintView.alpha = 0
            }) { _ in
                hintView.removeFromSuperview()
            }
        }
    }
    
    private func hasRecordedAudio() -> Bool {
        return dataManager.hasRecording(for: currentAffirmation)
    }
    
    private func getRecordingPath() -> URL? {
        guard let recordingPath = dataManager.getRecordingPath(for: currentAffirmation) else {
            return nil
        }
        return URL(fileURLWithPath: recordingPath)
    }
    
    private func saveRecordingPath(_ url: URL) {
        dataManager.saveRecording(path: url.path, for: currentAffirmation)
        
        // 更新当前语录的录音路径
        currentAffirmation.recordedAudioPath = url.path
        
        // 录音完成，增加录音计数
        achievementVC.didReciteAffirmation()
        
        // Debug: Print stored data after recording save
        print("After recording save - Affirmation ID: \(currentAffirmation.id), Path: \(url.path)")
        favoriteManager.printStoredData()
        
        // Refresh Favorites view controller if it exists
        notifyFavoritesViewControllerToRefresh()
    }
    
    // Improved method to notify FavoritesViewController to refresh
    private func notifyFavoritesViewControllerToRefresh() {
        // Find the key window in a more modern way
        let keyWindow = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .filter { $0.isKeyWindow }.first
        
        // Find FavoritesViewController in the tab bar
        if let tabBarController = keyWindow?.rootViewController as? MainTabBarController,
           let viewControllers = tabBarController.viewControllers,
           viewControllers.count >= 3,
           let navController = viewControllers[2] as? UINavigationController,
           let favoritesVC = navController.viewControllers.first as? FavoritesViewController {
            
            favoritesVC.refreshData()
        }
    }
    
    // MARK: - Gesture Handlers
    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        // 获取点击位置
        let location = gesture.location(in: view)
        
        // 检查点击是否在底部工具栏区域
        let toolbarFrame = bottomToolbar.frame
        if toolbarFrame.contains(location) {
            return // 底部工具栏区域不响应双击操作
        }
        
        // 执行收藏操作
        let newStatus = dataManager.toggleFavorite(for: currentAffirmation)
        
        // 更新按钮状态
        if newStatus {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favoriteButton.tintColor = .systemRed
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            favoriteButton.tintColor = .white
        }
        
        // 更新当前语录的收藏状态
        currentAffirmation.isFavorite = newStatus
        
        // 提供震动反馈 - 使用不同强度的反馈，根据添加或移除收藏
        let generator = newStatus ? 
            UINotificationFeedbackGenerator() : 
            UIImpactFeedbackGenerator(style: .medium)
        
        if newStatus {
            // 收藏成功，使用成功类型的通知反馈
            (generator as? UINotificationFeedbackGenerator)?.notificationOccurred(.success)
        } else {
            // 取消收藏，使用普通的触觉反馈
            (generator as? UIImpactFeedbackGenerator)?.impactOccurred()
        }
        
        // 显示提示
        let message = newStatus ? "Added to favorites" : "Removed from favorites"
        ProgressHUD.succeed(message)
        
        // Debug: Print stored data after favorite change
        print("After favorite change (double tap) - Affirmation ID: \(currentAffirmation.id), Favorited: \(newStatus)")
        favoriteManager.printStoredData()
        
        // Refresh Favorites view controller if it exists
        notifyFavoritesViewControllerToRefresh()
    }
    
    // 检查并停止背景音乐
    private func stopBackgroundMusicIfNeeded() {
        // 获取音乐播放管理器实例
        let musicManager = MusicPlayerManager.shared
        
        // 检查是否有音乐正在播放
        if musicManager.isCurrentlyPlaying() {
            // 停止当前播放的音乐
            musicManager.stop()
            
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension AffirmationDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // Allow multiple gestures to be recognized simultaneously
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // Don't process gesture if touch is on bottom toolbar
        if let touchView = touch.view, touchView.isDescendant(of: bottomToolbar) {
            return false
        }
        return true
    }
} 
