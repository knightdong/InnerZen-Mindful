import UIKit
import SnapKit

class FavoritesViewController: BaseViewController {
    
    // MARK: - Properties
    private let dataManager = AffirmationDataManager.shared
    private let favoriteManager = FavoriteManager.shared
    private var favoriteAffirmations: [Affirmation] = []
    private var recordedAffirmations: [Affirmation] = []
    private var isShowingFavorites = true // Flag to track current view mode
    
    // MARK: - UI Components
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Favorites", "Recordings"])
        control.selectedSegmentIndex = 0
        let font = UIFont.systemFont(ofSize: 15, weight: .medium) // 你可以调整这个大小和粗细
        if #available(iOS 13.0, *) {
            control.selectedSegmentTintColor = UIColor(red: 0.2, green: 0.6, blue: 0.9, alpha: 1.0)
            control.setTitleTextAttributes([
                .foregroundColor: UIColor.white,
                .font: font
            ], for: .selected)
            control.setTitleTextAttributes([
                .foregroundColor: UIColor.darkGray,
                .font: font
            ], for: .normal)
        } else {
            control.tintColor = UIColor(red: 0.2, green: 0.6, blue: 0.9, alpha: 1.0)
            control.setTitleTextAttributes([
                .font: font
            ], for: .normal)
        }
        return control
    }()

    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        return tableView
    }()
    
    private let emptyStateView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    private let emptyStateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.lightGray.withAlphaComponent(0.5)
        return imageView
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let favoriteIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart.fill")
        imageView.tintColor = .systemRed
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0
        return imageView
    }()
    
    private let recordingIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "mic.fill")
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0
        return imageView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 更新tableView的内容边距，确保底部内容不被TabBar遮挡
        updateTableViewInsets()
    }
    
    // 更新tableView的内容边距
    private func updateTableViewInsets() {
        let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 0
        
        // 只有在tabBarHeight > 0时才设置边距，以避免在TabBar隐藏的情况下添加多余的边距
        if tabBarHeight > 0 {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tabBarHeight, right: 0)
            tableView.scrollIndicatorInsets = tableView.contentInset
        }
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        title = "Favorites"
        
        // Add UI components
        view.addSubview(segmentedControl)
        view.addSubview(tableView)
        view.addSubview(emptyStateView)
        
        // Add empty state components
        emptyStateView.addSubview(emptyStateImageView)
        emptyStateView.addSubview(emptyStateLabel)
        emptyStateView.addSubview(favoriteIconImageView)
        emptyStateView.addSubview(recordingIconImageView)
        
        // Setup constraints
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        emptyStateView.snp.makeConstraints { make in
            make.center.equalTo(tableView)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        emptyStateImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        emptyStateLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyStateImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
        }
        
        favoriteIconImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emptyStateLabel.snp.bottom).offset(15)
            make.width.height.equalTo(30)
            make.bottom.equalToSuperview()
        }
        
        recordingIconImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emptyStateLabel.snp.bottom).offset(15)
            make.width.height.equalTo(30)
            make.bottom.equalToSuperview()
        }
        
        // Setup segmented control action
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AffirmationCell.self, forCellReuseIdentifier: AffirmationCell.reuseIdentifier)
    }
    
    // MARK: - Data Loading
    private func loadData() {
        // Get current data
        favoriteAffirmations = dataManager.getFavoritedAffirmations()
        recordedAffirmations = dataManager.getRecordedAffirmations()
        
        // Debug information
        print("=== LOADING FAVORITE VIEW DATA ===")
        print("Favorite IDs in UserDefaults: \(favoriteManager.getFavoriteAffirmationIds())")
        print("Loaded favorite affirmations: \(favoriteAffirmations.count)")
        if !favoriteAffirmations.isEmpty {
            print("Sample favorite IDs: \(favoriteAffirmations.prefix(3).map { $0.id })")
        }
        
        print("Loaded recorded affirmations: \(recordedAffirmations.count)")
        if !recordedAffirmations.isEmpty {
            print("Sample recording IDs: \(recordedAffirmations.prefix(3).map { $0.id })")
        }
        
        updateUI()
    }
    
    private func updateUI() {
        let currentAffirmations = isShowingFavorites ? favoriteAffirmations : recordedAffirmations
        
        if currentAffirmations.isEmpty {
            showEmptyState()
        } else {
            hideEmptyState()
        }
        
        tableView.reloadData()
    }
    
    private func showEmptyState() {
        emptyStateView.isHidden = false
        
        if isShowingFavorites {
            emptyStateImageView.image = UIImage(systemName: "heart.slash")
            emptyStateLabel.text = "You haven't favorited any affirmations yet.\nTap the heart icon while browsing to add to favorites."
            favoriteIconImageView.isHidden = false
            recordingIconImageView.isHidden = true
        } else {
            emptyStateImageView.image = UIImage(systemName: "mic.slash")
            emptyStateLabel.text = "You haven't recorded any affirmations yet.\nTap the microphone icon while browsing to record your voice."
            favoriteIconImageView.isHidden = true
            recordingIconImageView.isHidden = false
        }
    }
    
    private func hideEmptyState() {
        emptyStateView.isHidden = true
    }
    
    // MARK: - Actions
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        isShowingFavorites = sender.selectedSegmentIndex == 0
        title = isShowingFavorites ? "Favorites" : "Recordings"
        updateUI()
    }
    
    // MARK: - Public Methods
    func refreshData() {
        loadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isShowingFavorites ? favoriteAffirmations.count : recordedAffirmations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AffirmationCell.reuseIdentifier, for: indexPath) as! AffirmationCell
        
        let affirmation = isShowingFavorites ? favoriteAffirmations[indexPath.row] : recordedAffirmations[indexPath.row]
        
        // Set badge to indicate favorite or recording
        let badge = isShowingFavorites ? "heart.fill" : "mic.fill"
        let badgeColor: UIColor = isShowingFavorites ? .systemRed : .systemBlue
        
        cell.configure(with: affirmation, badgeIcon: badge, badgeColor: badgeColor)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let affirmation = isShowingFavorites ? favoriteAffirmations[indexPath.row] : recordedAffirmations[indexPath.row]
        
        // Create detail view controller as full screen modal
        let detailVC = AffirmationDetailViewController(affirmation: affirmation)
        detailVC.modalPresentationStyle = .fullScreen
        
        // Present the detail view controller modally
        present(detailVC, animated: true)
    }
    
    // 添加左滑删除功能
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completion) in
            guard let self = self else {
                completion(false)
                return
            }
            
            let affirmation = self.isShowingFavorites ? self.favoriteAffirmations[indexPath.row] : self.recordedAffirmations[indexPath.row]
            
            if self.isShowingFavorites {
                // 从收藏中移除
                self.favoriteManager.removeFromFavorites(affirmation.id)
                self.favoriteAffirmations.remove(at: indexPath.row)
            } else {
                // 从录音中移除（同时删除录音文件）
                self.dataManager.removeRecording(for: affirmation)
                self.recordedAffirmations.remove(at: indexPath.row)
            }
            
            // 删除表格行
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // 检查是否需要显示空状态视图
            if (self.isShowingFavorites && self.favoriteAffirmations.isEmpty) ||
               (!self.isShowingFavorites && self.recordedAffirmations.isEmpty) {
                self.showEmptyState()
            }
            
            completion(true)
        }
        
        // 设置删除按钮的图标和颜色
        deleteAction.image = UIImage(systemName: "trash.fill")
        deleteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - PaddingLabel
// 自定义UILabel子类，支持内边距
class PaddingLabel: UILabel {
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(
            top: -textInsets.top,
            left: -textInsets.left,
            bottom: -textInsets.bottom,
            right: -textInsets.right
        )
        return textRect.inset(by: invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
}

// MARK: - AffirmationCell
class AffirmationCell: UITableViewCell {
    static let reuseIdentifier = "AffirmationCell"
    
    // Cell UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    private let categoryLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = 12
        label.layer.borderWidth = 1.0
        label.layer.borderColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0).cgColor
        label.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        label.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
        label.textInsets = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
        return label
    }()
    
    private let badgeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Setup
    private func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(contentLabel)
        containerView.addSubview(categoryLabel)
        containerView.addSubview(badgeImageView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12))
        }
        
        badgeImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.width.height.equalTo(24)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalTo(badgeImageView.snp.leading).offset(-10)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
            make.height.equalTo(32)
        }
    }
    
    // Configure
    func configure(with affirmation: Affirmation, badgeIcon: String, badgeColor: UIColor) {
        contentLabel.text = affirmation.content
        
        // 获取分类名称，去掉"Category:"前缀
        let categoryName = AffirmationCategory(rawValue: affirmation.category)?.displayName ?? affirmation.category
        categoryLabel.text = categoryName
        
        badgeImageView.image = UIImage(systemName: badgeIcon)
        badgeImageView.tintColor = badgeColor
    }
}

// 为UIColor添加darker方法以获取更深的颜色
extension UIColor {
    func darker(by percentage: CGFloat = 0.2) -> UIColor {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return UIColor(
            red: max(red - percentage, 0),
            green: max(green - percentage, 0),
            blue: max(blue - percentage, 0),
            alpha: alpha
        )
    }
} 
