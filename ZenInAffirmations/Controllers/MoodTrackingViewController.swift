import UIKit
import SnapKit
import Charts

class MoodEmoji {
    let name: String
    let emoji: String
    let color: UIColor
    let isSelected: Bool
    
    init(name: String, emoji: String, color: UIColor, isSelected: Bool = false) {
        self.name = name
        self.emoji = emoji
        self.color = color
        self.isSelected = isSelected
    }
}

// MARK: - MoodEntry Model
struct MoodEntry: Codable {
    let mood: EmotionType
    let note: String?
    let date: Date
    
    var weekday: Int {
        // 返回星期几，1代表星期日，2代表星期一，以此类推
        return Calendar.current.component(.weekday, from: date)
    }
}

// 统计视图
class MoodSummaryView: UIView {
    // MARK: - Properties
    private var weekMoodData: [Int: MoodEntry?] = [:] // 键为星期几，值为对应的心情记录
    private var isShowingCurrentWeek = true // 是否显示当前周
    
    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Weekly Mood Statistics"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let weekSwitchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Last Week", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.4, green: 0.4, blue: 0.8, alpha: 0.8)
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        // 圆角会在layoutSubviews中设置为高度的一半
        return button
    }()
    
    private let chartView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // 底部填充视图 - 白色
    var bottomFillView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    // 用于存放每天柱状图的容器视图
    private var dayContainers: [UIView] = []
    
    // MARK: - Initialization
    init(frame: CGRect, moodEntries: [MoodEntry]) {
        super.init(frame: frame)
        setupUI()
        processMoodData(moodEntries)
        setupChartView()
        
        // 添加按钮事件
        weekSwitchButton.addTarget(self, action: #selector(weekSwitchTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 20
        
        // Add shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: -3)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.1
        
        // 添加底部填充视图
        addSubview(bottomFillView)
        bottomFillView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0) // 高度会在showMoodSummaryView方法中动态调整
        }
        
        // Add title label
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25) // 保持顶部间距
            make.leading.equalToSuperview().offset(20) // 左对齐
        }
        
        // Add week switch button
        addSubview(weekSwitchButton)
        weekSwitchButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel) // 确保与标题在同一水平线上
            make.trailing.equalToSuperview().offset(-20) // 右对齐
        }
        
        // Add chart view
        addSubview(chartView)
        chartView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20) // 调整与标题的间距
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(260) // 保持图表高度
            make.bottom.equalTo(bottomFillView.snp.top).offset(-30) // 与底部填充视图保持间距
        }
        
        // 创建等宽分布的每日容器
        createDayContainers()
    }
    
    // 创建等宽分布的每日容器视图
    private func createDayContainers() {
        // Days of the week - 从周一开始
        let weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        
        // 清除现有容器
        dayContainers.forEach { $0.removeFromSuperview() }
        dayContainers.removeAll()
        
        // 创建7个等宽分布的容器
        for (index, day) in weekdays.enumerated() {
            let containerView = UIView()
            containerView.backgroundColor = .clear
            containerView.tag = index
            dayContainers.append(containerView)
            chartView.addSubview(containerView)
            
            // 创建日期标签
            let dayLabel = UILabel()
            dayLabel.text = day
            dayLabel.font = UIFont.systemFont(ofSize: 14)
            dayLabel.textColor = .darkGray
            dayLabel.textAlignment = .center
            
            containerView.addSubview(dayLabel)
            dayLabel.snp.makeConstraints { make in
                make.bottom.equalToSuperview()
                make.centerX.equalToSuperview()
                make.height.equalTo(20)
            }
            
            // 设置容器约束 - 等宽分布
            containerView.snp.makeConstraints { make in
                if index == 0 {
                    make.leading.equalToSuperview()
                } else {
                    make.leading.equalTo(dayContainers[index-1].snp.trailing)
                    make.width.equalTo(dayContainers[0])
                }
                
                if index == weekdays.count - 1 {
                    make.trailing.equalToSuperview()
                }
                
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
            }
        }
    }
    
    // MARK: - Actions
    @objc private func weekSwitchTapped() {
        // 切换周次
        isShowingCurrentWeek.toggle()
        
        // 更新按钮文本
        weekSwitchButton.setTitle(isShowingCurrentWeek ? "Last Week" : "This Week", for: .normal)
        
        // 更新图表数据
        if let entries = lastUsedEntries {
            processMoodData(entries)
            setupChartView()
        }
    }
    
    // 记录最后使用的数据集
    private var lastUsedEntries: [MoodEntry]?
    
    // MARK: - Process Mood Data
    private func processMoodData(_ entries: [MoodEntry]) {
        // 保存数据集以便切换
        lastUsedEntries = entries
        
        // 初始化所有星期几为nil
        for i in 1...7 {
            weekMoodData[i] = nil
        }
        
        // 计算日期范围
        var calendar = Calendar.current
        // 设置周一为每周的第一天
        calendar.firstWeekday = 2
        let today = Date()
        
        // 计算本周的周一日期
        let todayComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)
        guard let thisWeekStart = calendar.date(from: todayComponents) else { return }
        
        // 计算上周的周一日期
        guard let lastWeekStart = calendar.date(byAdding: .weekOfYear, value: -1, to: thisWeekStart) else { return }
        
        // 计算本周和上周的结束日期（周日）
        guard let thisWeekEnd = calendar.date(byAdding: .day, value: 6, to: thisWeekStart) else { return }
        guard let lastWeekEnd = calendar.date(byAdding: .day, value: 6, to: lastWeekStart) else { return }
        
        // 根据选择的周次设置日期范围
        let startDate: Date
        let endDate: Date
        
        if isShowingCurrentWeek {
            // 当前周：周一到周日
            startDate = thisWeekStart
            endDate = thisWeekEnd
        } else {
            // 上一周：上周一到上周日
            startDate = lastWeekStart
            endDate = lastWeekEnd
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        print("日期范围：\(dateFormatter.string(from: startDate)) 到 \(dateFormatter.string(from: endDate))")
        
        // 将每个心情记录映射到对应的星期几
        for entry in entries {
            // 检查记录是否在所选周次内
            if entry.date >= startDate && entry.date <= endDate {
                let weekday = entry.weekday
                // 如果该星期几已存在记录，只保留最新的
                if let existingEntry = weekMoodData[weekday], let unwrappedEntry = existingEntry {
                    if entry.date > unwrappedEntry.date {
                        weekMoodData[weekday] = entry
                    }
                } else {
                    weekMoodData[weekday] = entry
                }
            }
        }
    }
    
    // MARK: - Setup Chart
    private func setupChartView() {
        // 清除除了容器以外的视图
        for subview in chartView.subviews {
            if !dayContainers.contains(subview) {
                subview.removeFromSuperview()
            }
        }
        
        // 清除容器中除了日期标签以外的视图
        for container in dayContainers {
            for subview in container.subviews {
                if !(subview is UILabel && subview.frame.maxY == container.bounds.maxY) {
                    subview.removeFromSuperview()
                }
            }
        }
        
        // 映射Calendar的weekday到数组索引
        let weekdayMapping = [2, 3, 4, 5, 6, 7, 1] // 2=周一，3=周二..., 1=周日
        
        // 为每个容器添加柱状图和表情（如果有数据）
        for (index, container) in dayContainers.enumerated() {
            let calendarWeekday = weekdayMapping[index]
            
            // 检查是否有该日期的心情记录
            if let entry = weekMoodData[calendarWeekday], let unwrappedEntry = entry {
                // 根据心情获取颜色
                let color = getColorForEmotion(unwrappedEntry.mood)
                
                // 基于情绪强度的柱高（越快乐柱越高）
                let intensity = getEmotionIntensity(unwrappedEntry.mood)
                let maxHeight: CGFloat = 180
                let height = maxHeight * CGFloat(intensity) / 5.0
                
                // 创建柱状图视图
                let barView = UIView()
                barView.backgroundColor = color
                barView.layer.cornerRadius = 8
                
                container.addSubview(barView)
                barView.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.bottom.equalToSuperview().offset(-30) // 留出底部日期标签的空间
                    make.width.equalTo(16) // 固定宽度为16
                    make.height.equalTo(height)
                }
                
                // 在柱顶添加表情
                let emojiLabel = UILabel()
                emojiLabel.text = unwrappedEntry.mood.emoji
                emojiLabel.font = UIFont.systemFont(ofSize: 16)
                emojiLabel.textAlignment = .center
                
                container.addSubview(emojiLabel)
                emojiLabel.snp.makeConstraints { make in
                    make.bottom.equalTo(barView.snp.top).offset(-5)
                    make.centerX.equalTo(barView)
                }
            }
        }
    }
    
    // 根据情绪获取颜色
    private func getColorForEmotion(_ emotion: EmotionType) -> UIColor {
        // 根据情绪映射到MoodTrackingViewController中的moodOptions中的对应颜色
        switch emotion {
        case .happy, .excited:
            return UIColor(red: 1.0, green: 0.9, blue: 0.1, alpha: 1.0) // Happy 黄色
        case .calm:
            return UIColor(red: 0.6, green: 0.9, blue: 0.4, alpha: 1.0) // Good 绿色
        case .neutral:
            return UIColor(red: 0.7, green: 0.5, blue: 0.9, alpha: 1.0) // Normal 紫色
        case .sad, .anxious:
            return UIColor(red: 0.4, green: 0.6, blue: 0.9, alpha: 1.0) // Sad 蓝色
        case .angry, .stressed:
            return UIColor(red: 1.0, green: 0.4, blue: 0.4, alpha: 1.0) // Unhappy 红色
        }
    }
    
    // 根据情绪获取强度值（1-5）
    private func getEmotionIntensity(_ emotion: EmotionType) -> Int {
        // 越开心柱状图越高
        switch emotion {
        case .happy, .excited: return 5 // 最高
        case .calm: return 4
        case .neutral: return 3
        case .sad, .anxious: return 2
        case .angry, .stressed: return 1 // 最低
        }
    }
    
    // 更新心情数据
    func updateWithMoodEntries(_ entries: [MoodEntry]) {
        processMoodData(entries)
        setupChartView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 设置按钮圆角为高度的一半
        weekSwitchButton.layer.cornerRadius = weekSwitchButton.bounds.height / 2
        
        if chartView.bounds.width > 0 && dayContainers.isEmpty {
            createDayContainers()
            setupChartView()
        }
    }
}

class MoodTrackingViewController: BaseViewController {
    
    // MARK: - Properties
    private var selectedMoodIndex: Int = 4 // Default to Happy
    private var moodEntries: [MoodEntry] = []
    private let dataManager = AffirmationDataManager.shared
    private let userDefaults = UserDefaults.standard
    
    private let moodOptions: [MoodEmoji] = [
        MoodEmoji(name: "Unhappy", emoji: "😠", color: UIColor(red: 1.0, green: 0.4, blue: 0.4, alpha: 1.0)),
        MoodEmoji(name: "Sad", emoji: "😢", color: UIColor(red: 0.4, green: 0.6, blue: 0.9, alpha: 1.0)),
        MoodEmoji(name: "Normal", emoji: "😐", color: UIColor(red: 0.7, green: 0.5, blue: 0.9, alpha: 1.0)),
        MoodEmoji(name: "Good", emoji: "🙂", color: UIColor(red: 0.6, green: 0.9, blue: 0.4, alpha: 1.0)),
        MoodEmoji(name: "Happy", emoji: "😊", color: UIColor(red: 1.0, green: 0.9, blue: 0.1, alpha: 1.0)),
    ]
    
    // MARK: - UI Components
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.25, green: 0.22, blue: 0.4, alpha: 1.0) // Deep purple background
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "How Do You Feel\nToday?"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let mainEmojiCircleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.4, green: 0.35, blue: 0.45, alpha: 0.4) // Outer circle color
        view.layer.cornerRadius = 125
        return view
    }()
    
    private let innerCircleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.45, green: 0.4, blue: 0.5, alpha: 0.5) // Inner circle color
        view.layer.cornerRadius = 90
        return view
    }()
    
    private let mainEmojiView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.1, alpha: 1.0) // Yellow emoji background
        view.layer.cornerRadius = 65
        return view
    }()
    
    private let mainEmojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 70)
        label.textAlignment = .center
        label.text = "😊"
        return label
    }()
    
    private let moodSelectorView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // 使用UIView数组替代按钮数组
    private var moodButtonViews: [UIView] = []
    
    private let commitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Commit", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.7, green: 0.5, blue: 0.9, alpha: 1.0) // Purple button
        button.layer.cornerRadius = 25
        return button
    }()
    
    private let statisticsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chart.bar.fill"), for: .normal)
        button.tintColor = .white
        // 移除背景色和圆角
        button.backgroundColor = .clear
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // 添加心情统计视图
    private lazy var moodSummaryView: MoodSummaryView = {
        let height: CGFloat = 380 // 增加高度
        let summaryView = MoodSummaryView(
            frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: height),
            moodEntries: moodEntries
        )
        return summaryView
    }()
    
    private let dimBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.alpha = 0
        return view
    }()
    
    // MARK: - Initialization
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        modalPresentationStyle = .overFullScreen
        hidesBottomBarWhenPushed = true
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMoodEntries()
        setupUI()
        updateMainEmoji()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 确保隐藏TabBar
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.tabBarController?.tabBar.isHidden = true
        if let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
            tabBarController.tabBar.isHidden = true
        }
        
        // 设置完全覆盖的模态样式
        self.modalPresentationStyle = .overFullScreen
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 退出页面时恢复TabBar
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.tabBarController?.tabBar.isHidden = false
        if let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
            tabBarController.tabBar.isHidden = false
        }
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        
        // Add background
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Add close button
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(30)
        }
        
        // Add title
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // Add main emoji circle
        view.addSubview(mainEmojiCircleView)
        mainEmojiCircleView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(50)
            make.width.height.equalTo(250)
        }
        
        mainEmojiCircleView.addSubview(innerCircleView)
        innerCircleView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(180)
        }
        
        innerCircleView.addSubview(mainEmojiView)
        mainEmojiView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(130)
        }
        
        mainEmojiView.addSubview(mainEmojiLabel)
        mainEmojiLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        // Add mood selector
        view.addSubview(moodSelectorView)
        moodSelectorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-150)
            make.height.equalTo(100)
        }
        
        // Setup mood buttons
        setupMoodButtons()
        
        // Add bottom buttons
        view.addSubview(statisticsButton)
        statisticsButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
            make.width.height.equalTo(40)
        }
        statisticsButton.addTarget(self, action: #selector(statisticsButtonTapped), for: .touchUpInside)
        
        view.addSubview(commitButton)
        commitButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-50)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
            make.height.equalTo(50)
            make.leading.equalTo(statisticsButton.snp.trailing).offset(30) // 与统计按钮间距30
        }
        commitButton.addTarget(self, action: #selector(commitButtonTapped), for: .touchUpInside)
        
        // Add dim background view
        view.addSubview(dimBackgroundView)
        dimBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Add mood summary view
        view.addSubview(moodSummaryView)
        
        // Setup tap gesture to dismiss summary view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSummaryView))
        dimBackgroundView.addGestureRecognizer(tapGesture)
        
        // Set initial selection
        updateMoodSelection()
    }
    
    private func setupMoodButtons() {
        // Clear any existing buttons
        moodSelectorView.subviews.forEach { $0.removeFromSuperview() }
        moodButtonViews.removeAll()
        
        // Calculate button width
        let buttonWidth: CGFloat = 60
        let spacing: CGFloat = (UIScreen.main.bounds.width - 60 - buttonWidth * 5) / 4
        
        for (index, option) in moodOptions.enumerated() {
            // 创建可点击区域容器
            let buttonView = UIView()
            buttonView.tag = index
            buttonView.backgroundColor = .clear // 确保背景透明
            moodButtonViews.append(buttonView)
            moodSelectorView.addSubview(buttonView)
            
            // 创建表情容器
            let emojiContainer = UIView()
            emojiContainer.backgroundColor = option.color
            emojiContainer.layer.cornerRadius = 20
            
            // 创建表情标签
            let emojiLabel = UILabel()
            emojiLabel.text = option.emoji
            emojiLabel.font = UIFont.systemFont(ofSize: 20)
            emojiLabel.textAlignment = .center
            
            // 创建名称标签
            let nameLabel = UILabel()
            nameLabel.text = option.name
            nameLabel.font = UIFont.systemFont(ofSize: 12)
            nameLabel.textColor = .white
            nameLabel.textAlignment = .center
            
            // 添加点击手势
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(moodButtonTapped(_:)))
            buttonView.addGestureRecognizer(tapGesture)
            buttonView.isUserInteractionEnabled = true // 确保启用交互
            
            // 添加子视图
            emojiContainer.addSubview(emojiLabel)
            buttonView.addSubview(emojiContainer)
            buttonView.addSubview(nameLabel)
            
            // 布局子视图
            emojiLabel.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            
            emojiContainer.snp.makeConstraints { make in
                make.top.centerX.equalToSuperview()
                make.width.height.equalTo(40)
            }
            
            nameLabel.snp.makeConstraints { make in
                make.top.equalTo(emojiContainer.snp.bottom).offset(8)
                make.centerX.equalToSuperview()
                make.width.lessThanOrEqualTo(80)
            }
            
            // 布局按钮容器
            buttonView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.width.equalTo(buttonWidth)
                make.height.equalTo(70)
                make.leading.equalToSuperview().offset(CGFloat(index) * (buttonWidth + spacing))
            }
        }
    }
    
    // MARK: - Actions
    @objc private func moodButtonTapped(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        let index = view.tag
        print("点击了情绪按钮: \(index)") // 调试输出
        selectedMoodIndex = index
        updateMoodSelection()
        updateMainEmoji()
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func commitButtonTapped() {
        // 创建和保存心情记录
        createMoodEntry()
        
        // 显示成功消息
        showSuccessMessage()
    }
    
    @objc private func statisticsButtonTapped() {
        // 显示心情统计视图
        showMoodSummaryView()
    }
    
    @objc private func dismissSummaryView() {
        // 隐藏心情统计视图
        UIView.animate(withDuration: 0.3, animations: {
            self.dimBackgroundView.alpha = 0
            self.moodSummaryView.frame.origin.y = UIScreen.main.bounds.height
        })
    }
    
    // MARK: - Helper Methods
    private func updateMoodSelection() {
        for (index, buttonView) in moodButtonViews.enumerated() {
            // 获取每个按钮视图的表情容器视图
            if let emojiContainer = buttonView.subviews.first as? UIView {
                if index == selectedMoodIndex {
                    // 高亮选中的按钮
                    emojiContainer.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                    emojiContainer.layer.borderWidth = 2
                    emojiContainer.layer.borderColor = UIColor.white.cgColor
                    
                    // 添加发光效果
                    emojiContainer.layer.shadowColor = moodOptions[index].color.cgColor
                    emojiContainer.layer.shadowOffset = .zero
                    emojiContainer.layer.shadowRadius = 10
                    emojiContainer.layer.shadowOpacity = 0.8
                } else {
                    // 重置未选中的按钮
                    emojiContainer.transform = .identity
                    emojiContainer.layer.borderWidth = 0
                    emojiContainer.layer.shadowOpacity = 0
                }
            }
        }
    }
    
    private func updateMainEmoji() {
        // Update main emoji color and emoji
        mainEmojiView.backgroundColor = moodOptions[selectedMoodIndex].color
        mainEmojiLabel.text = moodOptions[selectedMoodIndex].emoji
    }
    
    private func loadMoodEntries() {
        // 从UserDefaults加载保存的心情记录
        if let savedData = userDefaults.data(forKey: "moodEntries"),
           let entries = try? JSONDecoder().decode([MoodEntry].self, from: savedData) {
            moodEntries = entries
            print("加载了\(entries.count)条心情记录")
        } else {
            moodEntries = []
            print("没有找到保存的心情记录")
        }
    }
    
    private func saveMoodEntries() {
        // 保存心情记录到UserDefaults
        if let encodedData = try? JSONEncoder().encode(moodEntries) {
            userDefaults.set(encodedData, forKey: "moodEntries")
            print("保存了\(moodEntries.count)条心情记录")
        }
    }
    
    private func showMoodSummaryView() {
        // 更新视图数据
        moodSummaryView.updateWithMoodEntries(moodEntries)
        
        // 计算视图高度和底部安全区域
        let height: CGFloat = 380 // 基本高度
        let window = UIApplication.shared.windows.first
        let bottomSafeAreaInset = window?.safeAreaInsets.bottom ?? 0
        
        // 设置底部填充视图高度
        moodSummaryView.bottomFillView.snp.updateConstraints { make in
            make.height.equalTo(bottomSafeAreaInset)
        }
        
        // 重置视图位置
        moodSummaryView.frame = CGRect(
            x: 0, 
            y: UIScreen.main.bounds.height, 
            width: UIScreen.main.bounds.width, 
            height: height + bottomSafeAreaInset
        )
        
        // 动画显示，考虑安全区域
        UIView.animate(withDuration: 0.3, animations: {
            self.dimBackgroundView.alpha = 1
            self.moodSummaryView.frame.origin.y = UIScreen.main.bounds.height - height - bottomSafeAreaInset
        })
    }
    
    private func createMoodEntry() {
        // 创建心情记录
        // 将selectedMoodIndex映射到对应的EmotionType
        let selectedMood: EmotionType
        switch selectedMoodIndex {
        case 0: // Unhappy
            selectedMood = .angry
        case 1: // Sad
            selectedMood = .sad
        case 2: // Normal
            selectedMood = .neutral
        case 3: // Good
            selectedMood = .calm
        case 4: // Happy
            selectedMood = .happy
        default:
            selectedMood = .neutral
        }
        
        let newEntry = MoodEntry(
            mood: selectedMood,
            note: nil,
            date: Date()
        )
        
        // 添加到记录列表
        moodEntries.append(newEntry)
        
        // 保存记录
        saveMoodEntries()
        
        print("创建心情记录: \(selectedMood.displayName)，星期\(newEntry.weekday)")
    }
    
    private func showSuccessMessage() {
        // 创建一个临时视图显示成功消息
        let messageView = UIView()
        messageView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        messageView.layer.cornerRadius = 10
        
        let messageLabel = UILabel()
        messageLabel.text = "Mood Recorded"
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        
        messageView.addSubview(messageLabel)
        view.addSubview(messageView)
        
        messageLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
        
        messageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.greaterThanOrEqualTo(150)
        }
        
        // 添加震动反馈
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        // 2秒后自动消失
        UIView.animate(withDuration: 0.3, delay: 1.5, options: [], animations: {
            messageView.alpha = 0
        }) { _ in
            messageView.removeFromSuperview()
        }
    }
}

// MARK: - EmotionType Enum
enum EmotionType: String, CaseIterable, Codable {
    case happy = "happy"
    case excited = "excited"
    case calm = "calm"
    case neutral = "neutral"
    case sad = "sad"
    case angry = "angry"
    case anxious = "anxious"
    case stressed = "stressed"
    
    var emoji: String {
        switch self {
        case .happy: return "😊"
        case .excited: return "😃"
        case .calm: return "😌"
        case .neutral: return "😐"
        case .sad: return "😢"
        case .angry: return "😠"
        case .anxious: return "😰"
        case .stressed: return "😫"
        }
    }
    
    var displayName: String {
        switch self {
        case .happy: return "Happy"
        case .excited: return "Excited"
        case .calm: return "Calm"
        case .neutral: return "Neutral"
        case .sad: return "Sad"
        case .angry: return "Angry"
        case .anxious: return "Anxious"
        case .stressed: return "Stressed"
        }
    }
} 