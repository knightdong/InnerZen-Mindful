import UIKit
import SnapKit
import JTAppleCalendar
import ProgressHUD
import Foundation

class AchievementViewController: BaseViewController {
    
    // MARK: - Properties
    private let checkInManager = CheckInManager.shared
    private var selectedDate: Date = Date()
    private var achievements: [Achievement] = []
    private var checkInRecordsForDate: [CheckInRecord] = []
    private let dailyActivityManager = DailyActivityManager.shared
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var calendarView: JTACMonthView = {
        let calendar = JTACMonthView()
        calendar.backgroundColor = .white
        calendar.layer.cornerRadius = 12
        calendar.calendarDelegate = self
        calendar.calendarDataSource = self
        
        calendar.register(DateCell.self, forCellWithReuseIdentifier: DateCell.reuseIdentifier)
        calendar.register(
            CalendarHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CalendarHeaderView.reuseIdentifier
        )
        calendar.minimumLineSpacing = 0
        calendar.minimumInteritemSpacing = 0
        calendar.showsVerticalScrollIndicator = false
        calendar.scrollingMode = .stopAtEachCalendarFrame
        calendar.scrollDirection = .horizontal
        calendar.allowsMultipleSelection = false
        calendar.allowsRangedSelection = false
        calendar.allowsDateCellStretching = true
        calendar.isUserInteractionEnabled = true
        return calendar
    }()
    
    private let statsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private let statsGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.3, green: 0.7, blue: 0.9, alpha: 0.8).cgColor,
            UIColor(red: 0.2, green: 0.5, blue: 0.8, alpha: 0.8).cgColor
        ]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        return gradient
    }()
    
    private let statsBlurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.alpha = 0.3
        return view
    }()
    
    private let dailyStatsDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }()
    
    private let readStatsIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "book.fill")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let readCountLabel: UILabel = {
        let label = UILabel()
        label.text = "Read: 0"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let reciteStatsIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "mic.fill")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let reciteCountLabel: UILabel = {
        let label = UILabel()
        label.text = "Recited: 0"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let streakContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let currentStreakView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private let currentStreakGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.4, green: 0.3, blue: 0.6, alpha: 0.3).cgColor,
            UIColor(red: 0.3, green: 0.2, blue: 0.5, alpha: 0.9).cgColor
        ]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        return gradient
    }()
    
    private let currentStreakBlurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.alpha = 0.8
        return view
    }()
    
    private let currentStreakIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private let currentStreakTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Current Streak"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let currentStreakDaysLabel: UILabel = {
        let label = UILabel()
        label.text = "3 Days"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let longestStreakView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private let longestStreakGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.95, green: 0.8, blue: 0.4, alpha: 0.8).cgColor,
            UIColor(red: 0.9, green: 0.7, blue: 0.3, alpha: 0.8).cgColor
        ]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        return gradient
    }()
    
    private let longestStreakBlurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.alpha = 0.3
        return view
    }()
    
    private let longestStreakIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "trophy")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private let longestStreakTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Longest Streak"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let longestStreakDaysLabel: UILabel = {
        let label = UILabel()
        label.text = "14 Days"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let achievementLabel: UILabel = {
        let label = UILabel()
        label.text = "Achievements"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var achievementCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 15
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        collectionView.register(AchievementCell.self, forCellWithReuseIdentifier: AchievementCell.reuseIdentifier)
        return collectionView
    }()
    
    private let checkInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Check In Today", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 4
        button.layer.masksToBounds = false
        if CheckInManager.shared.isDateCheckedIn(Date()) {
            button.setTitle("Already Checked In", for: .normal)
            button.alpha = 0.85
        }
        return button
    }()
    
    private let checkInRecordsLabel: UILabel = {
        let label = UILabel()
        label.text = "Check-in Records"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .darkGray
        return label
    }()
    
    private let checkInRecordsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false // We'll use the main scrollView for scrolling
        tableView.register(CheckInRecordCell.self, forCellReuseIdentifier: CheckInRecordCell.reuseIdentifier)
        return tableView
    }()
    
    // MARK: - Custom Components
    private lazy var checkInView: CheckInView = {
        let view = CheckInView()
        view.delegate = self
        view.isHidden = true
        view.alpha = 0
        return view
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.alpha = 0
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadData()
        
        // Print to verify delegate is set correctly
        print("Is delegate set: \(calendarView.calendarDelegate != nil)")
        print("Is dataSource set: \(calendarView.calendarDataSource != nil)")
        
        // Pre-select today's date
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }
            self.calendarView.selectDates(from: self.selectedDate, to: self.selectedDate)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateStreakLabels()
        updateDailyStats(for: Date())
        
        // Scroll to current month
        calendarView.scrollToDate(Date())
        
        // Check and update achievements
        achievements = checkInManager.getAllAchievements()
        achievementCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Force select current date when returning to this tab
        if selectedDate != Date() {
            calendarView.deselectAllDates()
            calendarView.selectDates(from: selectedDate, to: selectedDate)
        }
        
        // Update stats and calendar
        updateDailyStats(for: selectedDate)
        calendarView.reloadData(withAnchor: selectedDate)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 更新scrollView的底部内边距，避免内容被TabBar遮挡
        let tabBarHeight: CGFloat = 60 // 自定义TabBar的高度
        let bottomInset = tabBarHeight + view.safeAreaInsets.bottom
        scrollView.contentInset.bottom = bottomInset
        scrollView.scrollIndicatorInsets.bottom = bottomInset
        
        // Select today if no date is selected
        if calendarView.selectedDates.isEmpty {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                // First deselect all dates to be sure
                self.calendarView.deselectAllDates()
                // Then select today's date
                self.calendarView.selectDates(from: self.selectedDate, to: self.selectedDate)
                self.updateDailyStats(for: self.selectedDate)
            }
        }
        
        // 更新梯度图层的frame
        currentStreakGradient.frame = currentStreakView.bounds
        longestStreakGradient.frame = longestStreakView.bounds
        statsGradient.frame = statsContainerView.bounds
    }
    
    // MARK: - Setup
    private func setupViews() {
        view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        title = "Streak & Achievements"
        
        // Add scrollView
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Add views to contentView
        contentView.addSubview(calendarView)
        contentView.addSubview(statsContainerView)
        contentView.addSubview(streakContainerView)
        contentView.addSubview(checkInButton)
        
        // Setup stats container view
        statsContainerView.layer.addSublayer(statsGradient)
        statsContainerView.addSubview(statsBlurView)
        statsContainerView.addSubview(dailyStatsDateLabel)
        statsContainerView.addSubview(readStatsIcon)
        statsContainerView.addSubview(readCountLabel)
        statsContainerView.addSubview(reciteStatsIcon)
        statsContainerView.addSubview(reciteCountLabel)
        
        // 添加当前streak卡片
        streakContainerView.addSubview(currentStreakView)
        currentStreakView.layer.addSublayer(currentStreakGradient)
        currentStreakView.addSubview(currentStreakBlurView)
        currentStreakView.addSubview(currentStreakIcon)
        currentStreakView.addSubview(currentStreakTitleLabel)
        currentStreakView.addSubview(currentStreakDaysLabel)
        
        // 添加最长streak卡片
        streakContainerView.addSubview(longestStreakView)
        longestStreakView.layer.addSublayer(longestStreakGradient)
        longestStreakView.addSubview(longestStreakBlurView)
        longestStreakView.addSubview(longestStreakIcon)
        longestStreakView.addSubview(longestStreakTitleLabel)
        longestStreakView.addSubview(longestStreakDaysLabel)
        
        contentView.addSubview(achievementLabel)
        contentView.addSubview(achievementCollectionView)
        
        // Add check-in records
        contentView.addSubview(checkInRecordsLabel)
        contentView.addSubview(checkInRecordsTableView)
        
        // Add custom check-in view
        view.addSubview(overlayView)
        view.addSubview(checkInView)
        
        // Make sure calendar view is interactive
        calendarView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        contentView.isUserInteractionEnabled = true
        
        setupConstraints()
        
        // Setup button action
        checkInButton.addTarget(self, action: #selector(checkInButtonTapped), for: .touchUpInside)
        
        // Setup table view delegates
        checkInRecordsTableView.delegate = self
        checkInRecordsTableView.dataSource = self
        
        // Setup overlay constraints
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        checkInView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(400)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(400) // 初始时在屏幕外
        }
        
        // Add tap gesture to dismiss
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissCheckInView))
        overlayView.addGestureRecognizer(tapGesture)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
            // Height will be determined by content
        }
        
        calendarView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(300)
        }
        
        statsContainerView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(140)
        }
        
        statsBlurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        dailyStatsDateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(30)
        }
        
        readStatsIcon.snp.makeConstraints { make in
            make.top.equalTo(dailyStatsDateLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(25)
            make.width.height.equalTo(24)
        }
        
        readCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(readStatsIcon)
            make.leading.equalTo(readStatsIcon.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        reciteStatsIcon.snp.makeConstraints { make in
            make.top.equalTo(readStatsIcon.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(25)
            make.width.height.equalTo(24)
        }
        
        reciteCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(reciteStatsIcon)
            make.leading.equalTo(reciteStatsIcon.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        // 修改streakContainerView的位置约束，现在直接连接到statsContainerView下方
        streakContainerView.snp.makeConstraints { make in
            make.top.equalTo(statsContainerView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(150)
        }
        
        // 修改checkInButton的约束，位置在streakContainerView下方
        checkInButton.snp.makeConstraints { make in
            make.top.equalTo(streakContainerView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(60)
        }
        
        currentStreakView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(longestStreakView)
        }
        
        currentStreakBlurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        currentStreakIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(25)
        }
        
        currentStreakTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(45)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        currentStreakDaysLabel.snp.makeConstraints { make in
            make.top.equalTo(currentStreakTitleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        longestStreakView.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.leading.equalTo(currentStreakView.snp.trailing).offset(15)
        }
        
        longestStreakBlurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        longestStreakIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(25)
        }
        
        longestStreakTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(45)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        longestStreakDaysLabel.snp.makeConstraints { make in
            make.top.equalTo(longestStreakTitleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        // 修改achievementLabel的约束，使其连接到checkInButton
        achievementLabel.snp.makeConstraints { make in
            make.top.equalTo(checkInButton.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        achievementCollectionView.snp.makeConstraints { make in
            make.top.equalTo(achievementLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(0)
            make.height.equalTo(180)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        checkInRecordsLabel.snp.makeConstraints { make in
            make.top.equalTo(achievementCollectionView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        checkInRecordsTableView.snp.makeConstraints { make in
            make.top.equalTo(checkInRecordsLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(200) // Fixed height, will show a few records
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    // MARK: - Data Loading
    private func loadData() {
        // Load achievements
        achievements = checkInManager.getAllAchievements()
        achievementCollectionView.reloadData()
        
        // Update streak information
        updateStreakLabels()
        
        // Configure calendar
        calendarView.reloadData()
        
        // Update daily stats for today
        updateDailyStats(for: Date())
    }
    
    private func updateStreakLabels() {
        let currentStreak = checkInManager.getCurrentStreakDays()
        let longestStreak = checkInManager.getLongestStreakDays()
        
        currentStreakDaysLabel.text = "\(currentStreak) Days"
        longestStreakDaysLabel.text = "\(longestStreak) Days"
    }
    
    private func updateDailyStats(for date: Date) {
        // 格式化日期
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        dailyStatsDateLabel.text = dateFormatter.string(from: date)
        
        // 获取当天的实际阅读和录音数据
        var readCount = 0
        var recitedCount = 0
        
        // If checking today, use current counts
        if Calendar.current.isDateInToday(date) {
            readCount = dailyActivityManager.getDailyReadCount()
            recitedCount = dailyActivityManager.getDailyReciteCount()
        } 
        // For past days, first check CheckInRecord
        else if let record = checkInManager.getCheckInRecord(for: date) {
            readCount = record.readCount
            recitedCount = record.recitedCount
        } 
        // If no CheckInRecord, check history stats as fallback
        else if let historyStat = dailyActivityManager.getHistoryStats(for: date) {
            readCount = historyStat.readCount
            recitedCount = historyStat.reciteCount
        }
        
        // 更新统计标签
        readCountLabel.text = "Read: \(readCount) affirmations"
        reciteCountLabel.text = "Recited: \(recitedCount) affirmations"
        
        // 高亮显示当前选中日期
        if Calendar.current.isDateInToday(date) {
            dailyStatsDateLabel.font = UIFont.boldSystemFont(ofSize: 20)
        } else {
            dailyStatsDateLabel.font = UIFont.boldSystemFont(ofSize: 18)
        }
        
        // 更新打卡按钮状态，但不隐藏
        let isCheckedIn = checkInManager.isDateCheckedIn(Date())
        checkInButton.backgroundColor = .white  // 始终保持白色背景
        checkInButton.isEnabled = !isCheckedIn && Calendar.current.isDateInToday(date)
        checkInButton.setTitle(isCheckedIn ? "Already Checked In" : "Check In Today", for: .normal)
        
        // Load check-in records for the selected date's month
        loadCheckInRecords(for: date)
    }
    
    // MARK: - Actions
    private func handleDateSelection(date: Date) {
        selectedDate = date
        updateDailyStats(for: date)
        loadCheckInRecords(for: date)
    }
    
    private func loadCheckInRecords(for date: Date) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        
        guard let year = components.year, let month = components.month else { return }
        
        // Get records for the selected month
        let monthRecords = checkInManager.getCheckInsForMonth(year: year, month: month)
        
        // Sort by date (newest first)
        checkInRecordsForDate = monthRecords.sorted { $0.date > $1.date }
        
        // Reload table view
        checkInRecordsTableView.reloadData()
    }
    
    @objc private func checkInButtonTapped() {
        showCustomCheckInView(for: Date())
    }
    
    private func showCustomCheckInView(for date: Date) {
        // Update view with current date
        checkInView.configure(with: date)
        
        // Show overlay and check-in view
        overlayView.alpha = 0
        overlayView.isHidden = false
        checkInView.isHidden = false
        
        // Animate check-in view from bottom
        UIView.animate(withDuration: 0.3, animations: {
            self.overlayView.alpha = 1
            self.checkInView.alpha = 1
            self.checkInView.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            }
            self.view.layoutIfNeeded()
        })
    }
    
    @objc private func dismissCheckInView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.overlayView.alpha = 0
            self.checkInView.alpha = 0
            self.checkInView.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(400)
            }
            self.view.layoutIfNeeded()
        }) { _ in
            self.overlayView.isHidden = true
            self.checkInView.isHidden = true
        }
    }
}

// MARK: - JTACMonthViewDataSource, JTACMonthViewDelegate
extension AchievementViewController: JTACMonthViewDataSource, JTACMonthViewDelegate {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        // Set calendar range: from 6 months ago to 6 months ahead
        let startDate = Calendar.current.date(byAdding: .month, value: -6, to: Date())!
        let endDate = Calendar.current.date(byAdding: .month, value: 6, to: Date())!
        
        return ConfigurationParameters(
            startDate: startDate,
            endDate: endDate,
            generateInDates: .forAllMonths,
            generateOutDates: .tillEndOfRow,
            firstDayOfWeek: .sunday
        )
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableCell(withReuseIdentifier: DateCell.reuseIdentifier, for: indexPath) as! DateCell
        configureCell(cell, cellState: cellState, date: date)
        return cell
    }
   
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        // Update selected date
        selectedDate = date
        
        // Clear previous selection (be sure only one date is selected)
        calendar.selectedDates.forEach { selectedDate in
            if selectedDate != date {
                calendar.deselectDates(from: selectedDate, to: selectedDate)
            }
        }
        
        // Force update cell appearance immediately
        guard let cell = cell as? DateCell else { return }
        cell.selectedView.isHidden = false
        
        // Update stats immediately with animation
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            self.updateDailyStats(for: date)
            self.dailyStatsDateLabel.transform = CGAffineTransform(scaleX: 1.03, y: 1.03)
        } completion: { [weak self] _ in
            UIView.animate(withDuration: 0.1) {
                self?.dailyStatsDateLabel.transform = CGAffineTransform.identity
            }
        }
        
        // Provide haptic feedback
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.impactOccurred()
        
        // Force update all cells
        DispatchQueue.main.async {
            calendar.reloadData(withAnchor: date)
        }
        
        print("Date selected: \(date)")
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState) {
        guard let cell = cell as? DateCell else { return }
        cell.selectedView.isHidden = true
        configureCell(cell, cellState: cellState, date: date)
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! DateCell
        configureCell(cell, cellState: cellState, date: date)
    }
    
    func calendarDidScroll(_ calendar: JTACMonthView) {
        // Handle calendar scroll events here
    }
    
    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        let header = calendar.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CalendarHeaderView.reuseIdentifier,
            for: indexPath
        ) as! CalendarHeaderView
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        header.monthLabel.text = dateFormatter.string(from: range.start)
        
        return header
    }
    
    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return MonthSize(defaultSize: 50)
    }
    
    private func configureCell(_ cell: DateCell, cellState: CellState, date: Date) {
        // Configure date text
        cell.dateLabel.text = cellState.text
        
        // Set appearance based on date status
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = .black
        } else {
            cell.dateLabel.textColor = .lightGray
        }
        
        // Selected state
        if cellState.isSelected {
            cell.selectedView.isHidden = false
        } else {
            cell.selectedView.isHidden = true
        }
        
        // Check-in status
        if checkInManager.isDateCheckedIn(date) {
            cell.checkedInView.isHidden = false
            
            // Set color based on activity level
            if let record = checkInManager.getCheckInRecord(for: date) {
                let totalActivity = record.readCount + record.recitedCount
                if totalActivity > 10 {
                    cell.checkedInView.backgroundColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0) // High activity
                } else if totalActivity > 5 {
                    cell.checkedInView.backgroundColor = UIColor(red: 0.4, green: 0.7, blue: 0.3, alpha: 1.0) // Medium activity
                } else if totalActivity > 0 {
                    cell.checkedInView.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.2, alpha: 1.0) // Low activity
                } else {
                    cell.checkedInView.backgroundColor = UIColor.systemOrange
                }
            }
        } else {
            cell.checkedInView.isHidden = true
        }
        
        // Highlight today
        if Calendar.current.isDateInToday(date) {
            cell.dateLabel.textColor = UIColor(red: 0.2, green: 0.6, blue: 0.9, alpha: 1.0)
            cell.dateLabel.font = UIFont.boldSystemFont(ofSize: 16)
        } else {
            cell.dateLabel.font = UIFont.systemFont(ofSize: 14)
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension AchievementViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return achievements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AchievementCell.reuseIdentifier, for: indexPath) as! AchievementCell
        let achievement = achievements[indexPath.item]
        cell.configure(with: achievement)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let achievement = achievements[indexPath.item]
        
        let alert = UIAlertController(
            title: achievement.name,
            message: achievement.description + (achievement.unlockDate != nil ? "\n\nUnlocked" : "\n\nLocked"),
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension AchievementViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkInRecordsForDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < checkInRecordsForDate.count else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CheckInRecordCell.reuseIdentifier, for: indexPath) as! CheckInRecordCell
        let record = checkInRecordsForDate[indexPath.row]
        cell.configure(with: record)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let record = checkInRecordsForDate[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        let alert = UIAlertController(
            title: "Check-in Details - \(dateFormatter.string(from: record.date))",
            message: "Read: \(record.readCount) affirmations\nRecited: \(record.recitedCount) affirmations\nNote: \(record.note ?? "None")",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Close", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Date Cell
class DateCell: JTACDayCell {
    static let reuseIdentifier = "DateCell"
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let selectedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 0.9, alpha: 0.3)
        view.layer.cornerRadius = 16
        view.isHidden = true
        return view
    }()
    
    let checkedInView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0)
        view.layer.cornerRadius = 4
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(selectedView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(checkedInView)
        
        selectedView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        checkedInView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
            make.width.equalTo(8)
            make.height.equalTo(8)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Calendar Header View
class CalendarHeaderView: JTACMonthReusableView {
    static let reuseIdentifier = "CalendarHeaderView"
    
    let monthLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .darkGray
        return label
    }()
    
    let weekdayStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        for day in weekdays {
            let label = UILabel()
            label.text = day
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = .gray
            stackView.addArrangedSubview(label)
        }
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(monthLabel)
        addSubview(weekdayStackView)
        
        monthLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(20)
        }
        
        weekdayStackView.snp.makeConstraints { make in
            make.top.equalTo(monthLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-4)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Achievement Cell
class AchievementCell: UICollectionViewCell {
    static let reuseIdentifier = "AchievementCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
//        view.layer.shadowColor = UIColor.black.cgColor
//        view.layer.shadowOpacity = 0.1
//        view.layer.shadowOffset = CGSize(width: 0, height: 1)
//        view.layer.shadowRadius = 3
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let lockImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "lock.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(lockImageView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        lockImageView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(20)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with achievement: Achievement) {
        nameLabel.text = achievement.name
        descriptionLabel.text = achievement.description
        
        // Set unique icon based on achievement ID
        switch achievement.id {
        case "achievement_3days":
            iconImageView.image = UIImage(systemName: "1.circle.fill")
        case "achievement_7days":
            iconImageView.image = UIImage(systemName: "7.circle.fill")
        case "achievement_14days":
            iconImageView.image = UIImage(systemName: "14.circle.fill")
        case "achievement_21days":
            iconImageView.image = UIImage(systemName: "waveform.path")
        case "achievement_30days":
            iconImageView.image = UIImage(systemName: "calendar.badge.clock")
        case "achievement_60days":
            iconImageView.image = UIImage(systemName: "flame.fill")
        case "achievement_100days":
            iconImageView.image = UIImage(systemName: "crown.fill")
        case "achievement_365days":
            iconImageView.image = UIImage(systemName: "trophy.fill")
        default:
            iconImageView.image = UIImage(systemName: "star.fill")
        }
        
        // Set appearance based on unlock status
        if achievement.unlockDate != nil {
            lockImageView.isHidden = true
            iconImageView.tintColor = UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0)
            containerView.backgroundColor = UIColor(red: 1.0, green: 0.98, blue: 0.9, alpha: 1.0)
        } else {
            lockImageView.isHidden = false
            iconImageView.tintColor = .lightGray
            containerView.backgroundColor = .white
        }
    }
}

// MARK: - CheckInRecordCell
class CheckInRecordCell: UITableViewCell {
    static let reuseIdentifier = "CheckInRecordCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()
    
    private let statsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    private let noteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .darkGray
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(dateLabel)
        containerView.addSubview(statsLabel)
        containerView.addSubview(noteLabel)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            
        }
        
        statsLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        noteLabel.snp.makeConstraints { make in
            make.top.equalTo(statsLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func configure(with record: CheckInRecord) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        dateLabel.text = dateFormatter.string(from: record.date)
        
        statsLabel.text = "Read: \(record.readCount) | Recited: \(record.recitedCount)"
        noteLabel.text = record.note != nil ? "Note: \(record.note!)" : "No notes"
    }
}

// MARK: - CheckInViewDelegate
protocol CheckInViewDelegate: AnyObject {
    func addCheckInRecord(record: CheckInRecord)
    func reloadCalendarData()
    func updateStreaks()
    func updateStats(for date: Date)
    func getAllAchievements() -> [Achievement]
    func updateAchievements(achievements: [Achievement])
    func dismiss()
}

// 在AchievementViewController中实现协议
extension AchievementViewController: CheckInViewDelegate {
    func addCheckInRecord(record: CheckInRecord) {
        checkInManager.addCheckInRecord(date: record.date, note: record.note, affirmationIds: record.affirmationIds, voiceRecordingPaths: record.voiceRecordingPaths, readCount: record.readCount, recitedCount: record.recitedCount)
    }
    
    func reloadCalendarData() {
        calendarView.reloadData()
    }
    
    func updateStreaks() {
        updateStreakLabels()
    }
    
    func updateStats(for date: Date) {
        updateDailyStats(for: date)
    }
    
    func getAllAchievements() -> [Achievement] {
        return checkInManager.getAllAchievements()
    }
    
    func updateAchievements(achievements: [Achievement]) {
        self.achievements = achievements
        achievementCollectionView.reloadData()
    }
    
    func dismiss() {
        dismissCheckInView()
    }
}

// MARK: - CheckInView
class CheckInView: UIView {
    
    weak var delegate: CheckInViewDelegate?
    private var date: Date = Date()
    private let affirmationManager = AffirmationDataManager.shared
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    private let affirmationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Confirm Check-In", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 0.9, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = .clear
        addSubview(containerView)
        
        containerView.addSubview(dateLabel)
        containerView.addSubview(affirmationLabel)
        containerView.addSubview(confirmButton)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
        }
        
        affirmationLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(affirmationLabel.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
//            make.bottom.equalToSuperview().offset(-60)
        }
        
        confirmButton.addTarget(self, action: #selector(confirmCheckIn), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func confirmCheckIn() {
        // 获取当天的实际阅读和录音数据
        let readCount = DailyActivityManager.shared.getDailyReadCount()
        let recitedCount = DailyActivityManager.shared.getDailyReciteCount()
        
        let newRecord = CheckInRecord(
            date: date,
            note: nil,
            affirmationIds: nil,
            voiceRecordingPaths: nil,
            readCount: readCount,
            recitedCount: recitedCount
        )
        
        // 添加打卡记录
        delegate?.addCheckInRecord(record: newRecord)
        delegate?.reloadCalendarData()
        delegate?.updateStreaks()
        delegate?.updateStats(for: date)
        
        // 显示成功消息
        ProgressHUD.succeed("Check-in successful!")
        
        // 检查并更新成就
        if let achievements = delegate?.getAllAchievements() {
            delegate?.updateAchievements(achievements: achievements)
        }
        
        // 关闭打卡视图
        delegate?.dismiss()
    }
    
    // MARK: - Configuration
    func configure(with date: Date) {
        self.date = date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        dateLabel.text = dateFormatter.string(from: date)
        
        // 显示随机的肯定语
        if let randomAffirmation = affirmationManager.getRandomAffirmation() {
            affirmationLabel.text = "\"" + randomAffirmation.content + "\""
        } else {
            affirmationLabel.text = "Today is a great day to be mindful and present."
        }
    }
}

// MARK: - UITextFieldDelegate
extension AchievementViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - AchievementViewController
extension AchievementViewController {
    // 这个方法应该在用户完成阅读时调用
    func didReadAffirmation() {
        dailyActivityManager.incrementReadCount()
        // 如果当前显示的是今天，立即更新UI
        if Calendar.current.isDateInToday(selectedDate) {
            updateDailyStats(for: Date())
        }
    }
    
    // 这个方法应该在用户完成录音时调用
    func didReciteAffirmation() {
        dailyActivityManager.incrementReciteCount()
        // 如果当前显示的是今天，立即更新UI
        if Calendar.current.isDateInToday(selectedDate) {
            updateDailyStats(for: Date())
        }
    }
} 
