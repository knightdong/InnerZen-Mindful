import UIKit
import SnapKit
import ProgressHUD

class HomeViewController: BaseViewController {
    
    // MARK: - Properties
    private let dataManager = AffirmationDataManager.shared
    private var randomAffirmations: [Affirmation] = []
    private var categories: [AffirmationCategory] = []
    
    // 新增：成就视图控制器引用，用于记录每日统计
    private lazy var achievementVC = AchievementViewController()
    
    // 新增：状态栏毛玻璃效果视图
    private let statusBarBlurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let view = UIVisualEffectView(effect: blurEffect)
        return view
    }()
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var bannerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.identifier)
        return collectionView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Categories"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        return label
    }()
    
    private lazy var categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        // 禁用滚动，因为我们使用外部的scrollView
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadData()
        setupStatusBarBlurView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 获取状态栏高度
        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 44
        
        // 更新scrollView的顶部内边距，避免内容被状态栏遮挡
        scrollView.contentInset.top = statusBarHeight
        scrollView.scrollIndicatorInsets.top = statusBarHeight
        
        // 更新scrollView的底部内边距，避免内容被TabBar遮挡
        let tabBarHeight: CGFloat = 60 // 自定义TabBar的高度
        let bottomInset = tabBarHeight + view.safeAreaInsets.bottom
        scrollView.contentInset.bottom = bottomInset
        scrollView.scrollIndicatorInsets.bottom = bottomInset
        
        // 更新状态栏模糊视图的高度
        updateStatusBarBlurViewFrame()
    }
    
    // MARK: - Setup
    private func setupViews() {
        view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        title = "ZenAffirmations"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(bannerCollectionView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(categoriesCollectionView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view)
        }
        
        bannerCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(view.frame.width * 9 / 16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(bannerCollectionView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        categoriesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            // 设置固定高度，根据内容计算
            make.height.equalTo(self.calculateCategoriesHeight())
            make.bottom.equalToSuperview()
        }
    }
    
    // 计算分类集合视图的高度
    private func calculateCategoriesHeight() -> CGFloat {
        // 假设每行有2个项目
        let itemsPerRow: CGFloat = 2
        // 分类视图的宽度
        let totalWidth = UIScreen.main.bounds.width - 32 // 左右各减去16的边距
        // 每个项目之间的间距
        let spacing: CGFloat = 20
        // 每个项目的宽度
        let itemWidth = (totalWidth - spacing) / itemsPerRow
        // 每个项目的高度
        let itemHeight = itemWidth * 1.2
        // 行间距
        let lineSpacing: CGFloat = 20
        // 计算总高度
        let numberOfItems = CGFloat(AffirmationCategory.allCases.count)
        let numberOfRows = ceil(numberOfItems / itemsPerRow)
        return numberOfRows * itemHeight + (numberOfRows - 1) * lineSpacing
    }
    
    // MARK: - Data Loading
    private func loadData() {
        // Get all categories
        categories = dataManager.getAllCategories()
        print("加载了 \(categories.count) 个分类")
        
        // Get 5 random affirmations for the banner
        randomAffirmations = []
        for _ in 0..<5 {
            if let affirmation = dataManager.getRandomAffirmation() {
                randomAffirmations.append(affirmation)
            }
        }
        
        // 确保至少有一条语录可以显示
        if randomAffirmations.isEmpty {
            randomAffirmations = [
                Affirmation(content: "每一天都是新的开始", category: "general"),
                Affirmation(content: "今天会比昨天更好", category: "general"),
                Affirmation(content: "我充满力量和希望", category: "general")
            ]
        }
        
        // Reload collection views
        bannerCollectionView.reloadData()
        categoriesCollectionView.reloadData()
        
        print("首页数据加载完成: \(randomAffirmations.count) 条语录, \(categories.count) 个分类")
    }
    
    // 新增：设置状态栏毛玻璃效果视图
    private func setupStatusBarBlurView() {
        view.addSubview(statusBarBlurView)
        updateStatusBarBlurViewFrame()
        
        // 确保毛玻璃视图始终在最前面
        view.bringSubviewToFront(statusBarBlurView)
    }
    
    // 新增：更新状态栏毛玻璃视图的尺寸
    private func updateStatusBarBlurViewFrame() {
        // 获取状态栏的高度（包括刘海和灵动岛）
        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 44
        
        // 设置模糊视图的大小和位置
        statusBarBlurView.frame = CGRect(
            x: 0,
            y: 0,
            width: view.bounds.width,
            height: statusBarHeight
        )
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bannerCollectionView {
            return randomAffirmations.count
        } else {
            return categories.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == bannerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.identifier, for: indexPath) as! BannerCell
            cell.configure(with: randomAffirmations[indexPath.item])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
            cell.configure(with: categories[indexPath.item])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == bannerCollectionView {
            // 点击banner时，打开详情页
            let affirmation = randomAffirmations[indexPath.item]
            let detailVC = AffirmationDetailViewController(affirmation: affirmation)
            present(detailVC, animated: true)
            
            // 记录阅读统计
            achievementVC.didReadAffirmation()
        } else if collectionView == categoriesCollectionView {
            let category = categories[indexPath.item]
            
            // 从该分类获取随机语录
            if let randomAffirmation = dataManager.getRandomAffirmation(for: category) {
                // 创建详情页面并传入分类信息
                let detailVC = AffirmationDetailViewController(affirmation: randomAffirmation, category: category)
                present(detailVC, animated: true)
                
                // 记录阅读统计
                achievementVC.didReadAffirmation()
            } else {
                // 如果分类中没有语录，显示错误信息
                ProgressHUD.failed("No affirmations in this category")
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == bannerCollectionView {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else {
            let width = (collectionView.frame.width - 20) / 2
            return CGSize(width: width, height: width * 1.2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView == bannerCollectionView ? 0 : 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView == bannerCollectionView ? 0 : 20
    }
}

// MARK: - Banner Cell
class BannerCell: UICollectionViewCell {
    static let identifier = "BannerCell"
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    private let affirmationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 1, height: 1)
        label.layer.shadowRadius = 3
        label.layer.shadowOpacity = 0.3
        label.layer.masksToBounds = false
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.layer.cornerRadius = 15
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(backgroundImageView)
        containerView.addSubview(overlayView)
        containerView.addSubview(affirmationLabel)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        affirmationLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
    
    func configure(with affirmation: Affirmation) {
        affirmationLabel.text = affirmation.content
        
        // 获取语录所属分类
        let categoryName = affirmation.category
        
        // 查找分类索引
        if let categoryIndex = findCategoryIndex(for: categoryName) {
            // 使用对应的背景图片
            let bannerImageName = "banner_cover\(categoryIndex)"
            if let bannerImage = UIImage(named: bannerImageName) {
                backgroundImageView.image = bannerImage
            } else {
                // 如果找不到图片，设置为默认颜色背景
                backgroundImageView.image = nil
                backgroundImageView.backgroundColor = getCategoryColor(for: categoryName)
            }
        } else {
            // 默认颜色背景
            backgroundImageView.image = nil
            backgroundImageView.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 0.9, alpha: 1.0)
        }
    }
    
    // 根据分类名查找对应的索引
    private func findCategoryIndex(for categoryName: String) -> Int? {
        return AffirmationCategory.allCases.firstIndex { $0.rawValue == categoryName }
    }
    
    // 根据分类名获取对应的颜色
    private func getCategoryColor(for categoryName: String) -> UIColor {
        guard let category = AffirmationCategory.allCases.first(where: { $0.rawValue == categoryName }) else {
            return UIColor(red: 0.2, green: 0.6, blue: 0.9, alpha: 1.0) // 默认蓝色
        }
        
        switch category {
        case .blessing:
            return UIColor(red: 0.2, green: 0.6, blue: 0.9, alpha: 1.0)
        case .beauty:
            return UIColor(red: 0.9, green: 0.3, blue: 0.5, alpha: 1.0)
        case .sleep:
            return UIColor(red: 0.4, green: 0.4, blue: 0.7, alpha: 1.0)
        case .gratitude:
            return UIColor(red: 0.3, green: 0.7, blue: 0.3, alpha: 1.0)
        case .spiritual:
            return UIColor(red: 0.6, green: 0.4, blue: 0.8, alpha: 1.0)
        case .love:
            return UIColor(red: 0.9, green: 0.2, blue: 0.3, alpha: 1.0)
        case .money:
            return UIColor(red: 0.1, green: 0.6, blue: 0.5, alpha: 1.0)
        case .happiness:
            return UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0)
        case .health:
            return UIColor(red: 0.0, green: 0.8, blue: 0.6, alpha: 1.0)
        case .success:
            return UIColor(red: 0.2, green: 0.8, blue: 0.2, alpha: 1.0)
        case .courage:
            return UIColor(red: 0.8, green: 0.4, blue: 0.2, alpha: 1.0)
        case .confidence:
            return UIColor(red: 0.2, green: 0.6, blue: 0.8, alpha: 1.0)
        case .peace:
            return UIColor(red: 0.7, green: 0.8, blue: 1.0, alpha: 1.0)
        case .wisdom:
            return UIColor(red: 0.6, green: 0.3, blue: 0.7, alpha: 1.0)
        case .creativity:
            return UIColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0)
        case .relationships:
            return UIColor(red: 0.9, green: 0.4, blue: 0.7, alpha: 1.0)
        case .forgiveness:
            return UIColor(red: 0.5, green: 0.7, blue: 0.9, alpha: 1.0)
        case .abundance:
            return UIColor(red: 0.8, green: 0.7, blue: 0.1, alpha: 1.0)
        case .resilience:
            return UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        case .mindfulness:
            return UIColor(red: 0.4, green: 0.8, blue: 0.8, alpha: 1.0)
        }
    }
}

// MARK: - Category Cell
class CategoryCell: UICollectionViewCell {
    static let identifier = "CategoryCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        //imageView.clipsToBounds = true
        //imageView.layer.cornerRadius = 10
        imageView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .darkGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
//        contentView.layer.shadowColor = UIColor.black.cgColor
//        contentView.layer.shadowOpacity = 0.1
//        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
//        contentView.layer.shadowRadius = 4
        
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(contentView.snp.width)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
    func configure(with category: AffirmationCategory) {
        nameLabel.text = category.displayName
        
        // 获取分类在allCases中的索引
        if let index = AffirmationCategory.allCases.firstIndex(of: category) {
            // 使用封面图片 (cover0 - cover18)
            let coverImageName = "cover\(index)"
            if let image = UIImage(named: coverImageName) {
                imageView.image = image
                imageView.backgroundColor = .clear
            } else {
                // 如果找不到图片，使用默认的颜色背景
                setDefaultBackgroundColor(for: category)
            }
        } else {
            // 使用默认颜色
            setDefaultBackgroundColor(for: category)
        }
    }
    
    private func setDefaultBackgroundColor(for category: AffirmationCategory) {
        switch category {
        case .blessing:
            imageView.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 0.9, alpha: 1.0)
        case .beauty:
            imageView.backgroundColor = UIColor(red: 0.9, green: 0.3, blue: 0.5, alpha: 1.0)
        case .sleep:
            imageView.backgroundColor = UIColor(red: 0.4, green: 0.4, blue: 0.7, alpha: 1.0)
        case .gratitude:
            imageView.backgroundColor = UIColor(red: 0.3, green: 0.7, blue: 0.3, alpha: 1.0)
        case .spiritual:
            imageView.backgroundColor = UIColor(red: 0.6, green: 0.4, blue: 0.8, alpha: 1.0)
        case .love:
            imageView.backgroundColor = UIColor(red: 0.9, green: 0.2, blue: 0.3, alpha: 1.0)
        case .money:
            imageView.backgroundColor = UIColor(red: 0.1, green: 0.6, blue: 0.5, alpha: 1.0)
        case .happiness:
            imageView.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0)
        case .health:
            imageView.backgroundColor = UIColor(red: 0.0, green: 0.8, blue: 0.6, alpha: 1.0)
        case .success:
            imageView.backgroundColor = UIColor(red: 0.2, green: 0.8, blue: 0.2, alpha: 1.0)
        case .courage:
            imageView.backgroundColor = UIColor(red: 0.8, green: 0.4, blue: 0.2, alpha: 1.0)
        case .confidence:
            imageView.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 0.8, alpha: 1.0)
        case .peace:
            imageView.backgroundColor = UIColor(red: 0.7, green: 0.8, blue: 1.0, alpha: 1.0)
        case .wisdom:
            imageView.backgroundColor = UIColor(red: 0.6, green: 0.3, blue: 0.7, alpha: 1.0)
        case .creativity:
            imageView.backgroundColor = UIColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0)
        case .relationships:
            imageView.backgroundColor = UIColor(red: 0.9, green: 0.4, blue: 0.7, alpha: 1.0)
        case .forgiveness:
            imageView.backgroundColor = UIColor(red: 0.5, green: 0.7, blue: 0.9, alpha: 1.0)
        case .abundance:
            imageView.backgroundColor = UIColor(red: 0.8, green: 0.7, blue: 0.1, alpha: 1.0)
        case .resilience:
            imageView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        case .mindfulness:
            imageView.backgroundColor = UIColor(red: 0.4, green: 0.8, blue: 0.8, alpha: 1.0)
        }
    }
} 
