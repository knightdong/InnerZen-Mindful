import UIKit
import Kingfisher
import SnapKit

class ContextualPracticeDetailViewController: BaseViewController {
    
    // MARK: - Properties
    private let practice: ContextualPractice
    private let musicManager = MusicPlayerManager.shared
    private var isPlaying = false
    private var mainTabBarController: MainTabBarController? {
        return UIApplication.shared.windows.first?.rootViewController as? MainTabBarController
    }
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let gradientOverlayView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private let durationBadge: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let durationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    private let stepsHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Practice Steps"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let stepsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    private let affirmationsHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Affirmations to Repeat"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let affirmationsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var startBreathingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start Breathing Exercise", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 0.9, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(startBreathingExercise), for: .touchUpInside)
        return button
    }()
    
    private lazy var playMusicButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        button.tintColor = UIColor(red: 0.2, green: 0.6, blue: 0.9, alpha: 1.0)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.addTarget(self, action: #selector(toggleMusic), for: .touchUpInside)
        return button
    }()
    
    private let musicNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        label.text = "Background Music"
        return label
    }()
    
    // MARK: - Initialization
    init(practice: ContextualPractice) {
        self.practice = practice
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configureWithPractice()
        self.title = self.practice.title
        
        // 添加音乐状态变化通知监听
        NotificationCenter.default.addObserver(self, 
                                              selector: #selector(musicStatusChanged), 
                                              name: NSNotification.Name("MusicStatusChanged"), 
                                              object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        mainTabBarController?.hideCustomTabBar(animated: false)
        
        // 更新音乐播放按钮状态
        updateMusicPlayButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 如果离开页面，停止音乐
        if isPlaying {
            musicManager.pause()
            isPlaying = false
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // 处理音乐状态变化通知
    @objc private func musicStatusChanged(_ notification: Notification) {
        updateMusicPlayButton()
    }
    
    // 更新音乐播放按钮UI
    private func updateMusicPlayButton() {
        // 从音乐管理器获取当前播放状态
        let (playerIsPlaying, currentMusic) = musicManager.getPlayingStatus()
        isPlaying = playerIsPlaying
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if self.isPlaying {
                self.playMusicButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
                if let musicName = currentMusic {
                    self.musicNameLabel.text = "Now playing: \(musicName)"
                }
            } else {
                self.playMusicButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
                self.musicNameLabel.text = "Background Music"
            }
        }
    }
    
    // MARK: - Setup
    private func setupViews() {
        view.backgroundColor = .white
        
        // 添加返回按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        
        // 设置导航栏透明
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        // 添加滚动视图
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // 添加头部图片
        contentView.addSubview(headerImageView)
        headerImageView.addSubview(gradientOverlayView)
        gradientOverlayView.addSubview(titleLabel)
        gradientOverlayView.addSubview(durationBadge)
        durationBadge.addSubview(durationLabel)
        
        // 添加内容组件
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(stepsHeaderLabel)
        contentView.addSubview(stepsStackView)
        contentView.addSubview(affirmationsHeaderLabel)
        contentView.addSubview(affirmationsStackView)
        
        // 添加音乐控制
        let musicControlView = UIView()
        musicControlView.backgroundColor = UIColor.systemGray6
        musicControlView.layer.cornerRadius = 10
        contentView.addSubview(musicControlView)
        
        musicControlView.addSubview(playMusicButton)
        musicControlView.addSubview(musicNameLabel)
        
        // 添加呼吸练习按钮
        contentView.addSubview(startBreathingButton)
        
        // 设置约束
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        headerImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(220)
        }
        
        gradientOverlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        durationBadge.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.width.greaterThanOrEqualTo(60)
            make.height.equalTo(24)
        }
        
        durationLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(headerImageView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        musicControlView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }
        
        playMusicButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        musicNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(playMusicButton.snp.trailing).offset(15)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview().offset(-15)
        }
        
        stepsHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(musicControlView.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        stepsStackView.snp.makeConstraints { make in
            make.top.equalTo(stepsHeaderLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        affirmationsHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(stepsStackView.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        affirmationsStackView.snp.makeConstraints { make in
            make.top.equalTo(affirmationsHeaderLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        startBreathingButton.snp.makeConstraints { make in
            make.top.equalTo(affirmationsStackView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.frame.width - 60)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-30)
        }
        
        // 设置渐变层
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.7).cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientOverlayView.layer.insertSublayer(gradientLayer, at: 0)
        
        // 确保渐变层与视图相同大小
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 220)
    }
    
    private func configureWithPractice() {
        // 设置标题和描述
        titleLabel.text = practice.title
        descriptionLabel.text = practice.description
        
        // 设置持续时间
        let minutes = practice.duration / 60
        durationLabel.text = "\(minutes) min"
        
        // 加载图片
        if let url = URL(string: practice.context.imageURL) {
            headerImageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "photo"),
                options: [
                    .transition(.fade(0.3)),
                    .cacheOriginalImage
                ]
            )
        }
        
        // 如果没有呼吸练习，隐藏按钮
        startBreathingButton.isHidden = !practice.breathingExercise
        
        // 添加步骤视图
        for (index, step) in practice.steps.enumerated() {
            let stepView = createStepView(number: index + 1, text: step)
            stepsStackView.addArrangedSubview(stepView)
        }
        
        // 添加肯定语视图
        for affirmation in practice.affirmations {
            let affirmationView = createAffirmationView(text: affirmation)
            affirmationsStackView.addArrangedSubview(affirmationView)
        }
    }
    
    private func createStepView(number: Int, text: String) -> UIView {
        let container = UIView()
        
        let numberLabel = UILabel()
        numberLabel.text = "\(number)"
        numberLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        numberLabel.textColor = .white
        numberLabel.textAlignment = .center
        numberLabel.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 0.9, alpha: 1.0)
        numberLabel.layer.cornerRadius = 12
        numberLabel.clipsToBounds = true
        
        let textLabel = UILabel()
        textLabel.text = text
        textLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textLabel.textColor = .darkGray
        textLabel.numberOfLines = 0
        
        container.addSubview(numberLabel)
        container.addSubview(textLabel)
        
        numberLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        textLabel.snp.makeConstraints { make in
            make.leading.equalTo(numberLabel.snp.trailing).offset(12)
            make.top.equalToSuperview()
            make.trailing.bottom.equalToSuperview()
        }
        
        return container
    }
    
    private func createAffirmationView(text: String) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.98, alpha: 1.0)
        container.layer.cornerRadius = 8
        
        let textLabel = UILabel()
        textLabel.text = "\"" + text + "\""
        textLabel.font = UIFont.italicSystemFont(ofSize: 16)
        textLabel.textColor = .darkGray
        textLabel.numberOfLines = 0
        
        container.addSubview(textLabel)
        
        textLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16))
        }
        
        return container
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func toggleMusic() {
        isPlaying = musicManager.togglePlayPause()
        updateMusicPlayButton()
    }
    
    @objc private func startBreathingExercise() {
      
        // 显示导航栏供新页面使用
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        let breathingVC = BreathingExerciseViewController()
        breathingVC.modalPresentationStyle = .fullScreen
        present(breathingVC, animated: true)
    }
}

// 扩展MainTabBarController，添加显示和隐藏自定义TabBar的方法
extension MainTabBarController {
    func showCustomTabBar(animated: Bool) {
        guard let customTabBar = self.view.subviews.first(where: { $0 is CustomTabBar }) else { return }
        
        if animated {
            customTabBar.alpha = 0
            customTabBar.isHidden = false
            UIView.animate(withDuration: 0.3) {
                customTabBar.alpha = 1
            }
        } else {
            customTabBar.isHidden = false
        }
    }
    
    func hideCustomTabBar(animated: Bool) {
        guard let customTabBar = self.view.subviews.first(where: { $0 is CustomTabBar }) else { return }
        
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                customTabBar.alpha = 0
            }) { _ in
                customTabBar.isHidden = true
            }
        } else {
            customTabBar.isHidden = true
        }
    }
} 
