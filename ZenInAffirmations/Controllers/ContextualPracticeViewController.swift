import UIKit
import SnapKit
import MJRefresh

class ContextualPracticeViewController: BaseViewController {
    
    // MARK: - Properties
    private let dataManager = ContextualPracticeManager.shared
    private var featuredPractices: [ContextualPractice] = []
    private var allContexts: [PracticeContext] = []
    
    private enum Section: Int, CaseIterable {
        case featured
        case categories
    }
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Mindful Moments"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let headerSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Practices for every situation"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    private let featuredLabel: UILabel = {
        let label = UILabel()
        label.text = "Featured Practices"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private lazy var featuredCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ContextualPracticeCell.self, forCellWithReuseIdentifier: ContextualPracticeCell.identifier)
        return collectionView
    }()
    
    private let categoriesLabel: UILabel = {
        let label = UILabel()
        label.text = "Explore by Context"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private lazy var categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ContextualPracticeCell.self, forCellWithReuseIdentifier: ContextualPracticeCell.identifier)
        // 禁用滚动，因为我们使用外部的scrollView
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    // 新增：状态栏毛玻璃效果视图
    private let statusBarBlurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let view = UIVisualEffectView(effect: blurEffect)
        return view
    }()
    
    private var mainTabBarController: MainTabBarController? {
        return UIApplication.shared.windows.first?.rootViewController as? MainTabBarController
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadData()
        setupStatusBarBlurView()
        setupRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        mainTabBarController?.showCustomTabBar(animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        mainTabBarController?.showCustomTabBar(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCategoriesCollectionViewHeight()
        
        // 获取状态栏高度
        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 44
        
        // 更新scrollView的顶部内边距，避免内容被状态栏遮挡
        scrollView.contentInset.top = statusBarHeight
        scrollView.scrollIndicatorInsets.top = statusBarHeight
        
        // 为scrollView添加底部内边距，防止内容被TabBar遮挡
        let tabBarHeight: CGFloat = 80 // 自定义TabBar的高度加上安全区域
        scrollView.contentInset.bottom = tabBarHeight
        scrollView.scrollIndicatorInsets.bottom = tabBarHeight
        
        // 更新状态栏模糊视图的高度
        updateStatusBarBlurViewFrame()
    }
    
    // MARK: - Setup
    private func setupViews() {
        view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerLabel)
        contentView.addSubview(headerSubtitleLabel)
        contentView.addSubview(featuredLabel)
        contentView.addSubview(featuredCollectionView)
        contentView.addSubview(categoriesLabel)
        contentView.addSubview(categoriesCollectionView)
        
        // 设置约束
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        headerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        headerSubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(8)
            make.leading.equalTo(headerLabel)
            make.trailing.equalTo(headerLabel)
        }
        
        featuredLabel.snp.makeConstraints { make in
            make.top.equalTo(headerSubtitleLabel.snp.bottom).offset(24)
            make.leading.equalTo(headerLabel)
            make.trailing.equalTo(headerLabel)
        }
        
        featuredCollectionView.snp.makeConstraints { make in
            make.top.equalTo(featuredLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        
        categoriesLabel.snp.makeConstraints { make in
            make.top.equalTo(featuredCollectionView.snp.bottom).offset(24)
            make.leading.equalTo(headerLabel)
            make.trailing.equalTo(headerLabel)
        }
        
        categoriesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(categoriesLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.height.equalTo(500) // 初始高度，之后会更新
            make.bottom.equalToSuperview().offset(-90) // 增加底部间距，避免被TabBar遮挡
        }
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
    
    // MARK: - 设置下拉刷新
    private func setupRefreshControl() {
        // 添加下拉刷新控件
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            // 重新加载数据
            self.refreshData()
        })
        
        // 自定义下拉刷新外观
        header.setTitle("下拉刷新", for: .idle)
        header.setTitle("松开刷新", for: .pulling)
        header.setTitle("刷新中...", for: .refreshing)
        header.lastUpdatedTimeLabel?.isHidden = true
        header.stateLabel?.textColor = .darkGray
        
        // 设置默认是隐藏的
        header.isHidden = true
        
        // 监听刷新状态变化
        header.beginRefreshingCompletionBlock = { [weak header] in
            // 开始刷新时显示
            header?.isHidden = false
        }
        
        header.endRefreshingCompletionBlock = { [weak header] in
            // 结束刷新时隐藏
            header?.isHidden = true
        }
        
        scrollView.mj_header = header
    }
    
    // 刷新数据
    private func refreshData() {
        // 重新加载精选练习
        featuredPractices = dataManager.getRandomPractices(count: 5)
        
        // 刷新集合视图
        featuredCollectionView.reloadData()
        categoriesCollectionView.reloadData()
        
        // 结束刷新状态
        scrollView.mj_header?.endRefreshing()
    }
    
    // MARK: - Data
    private func loadData() {
        // 加载精选练习
        featuredPractices = dataManager.getRandomPractices(count: 5)
        
        // 加载所有场景类别
        allContexts = PracticeContext.allCases
        
        // 刷新集合视图
        featuredCollectionView.reloadData()
        categoriesCollectionView.reloadData()
        
        // 更新类别集合视图高度
        updateCategoriesCollectionViewHeight()
    }
    
    // MARK: - Layout
    private func updateCategoriesCollectionViewHeight() {
        // 计算类别集合视图的高度
        let itemsPerRow: CGFloat = 2
        let spacing: CGFloat = 12
        let availableWidth = view.frame.width - 24 // 左右各减去12的边距
        let itemWidth = (availableWidth - spacing) / itemsPerRow
        let itemHeight = itemWidth * 1.1
        
        let numberOfItems = CGFloat(allContexts.count)
        let numberOfRows = ceil(numberOfItems / itemsPerRow)
        let totalHeight = numberOfRows * itemHeight + (numberOfRows - 1) * spacing
        
        // 更新集合视图高度
        categoriesCollectionView.snp.updateConstraints { make in
            make.height.equalTo(totalHeight)
        }
        
        // 强制布局更新
        view.layoutIfNeeded()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension ContextualPracticeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == featuredCollectionView {
            return featuredPractices.count
        } else {
            return allContexts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContextualPracticeCell.identifier, for: indexPath) as! ContextualPracticeCell
        
        if collectionView == featuredCollectionView {
            let practice = featuredPractices[indexPath.item]
            cell.configure(with: practice)
        } else {
            let context = allContexts[indexPath.item]
            cell.configure(with: context)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == featuredCollectionView {
            let practice = featuredPractices[indexPath.item]
            showPracticeDetail(practice)
        } else {
            let context = allContexts[indexPath.item]
            showContextPractices(context)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ContextualPracticeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == featuredCollectionView {
            return CGSize(width: 260, height: 200)
        } else {
            // 计算更大的cell尺寸
            let spacing: CGFloat = 12  // cell间距
            let itemsPerRow: CGFloat = 2
            let availableWidth = view.frame.width - (12 * 2) - (spacing * (itemsPerRow - 1)) // 左右边距各12
            let itemWidth = availableWidth / itemsPerRow
            return CGSize(width: itemWidth, height: itemWidth * 1.1) // 放大高度
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == featuredCollectionView {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView == featuredCollectionView ? 16 : 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView == featuredCollectionView ? 16 : 12
    }
}

// MARK: - Navigation
extension ContextualPracticeViewController {
    
    private func showPracticeDetail(_ practice: ContextualPractice) {
        let detailVC = ContextualPracticeDetailViewController(practice: practice)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private func showContextPractices(_ context: PracticeContext) {
        // 获取该情境下的第一个练习
        let practices = dataManager.getPractices(for: context)
        if let firstPractice = practices.first {
            // 直接跳转到详情页面
            let detailVC = ContextualPracticeDetailViewController(practice: firstPractice)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
} 
