import UIKit
import SnapKit

// 音乐面板委托协议
protocol MusicPlayerPanelDelegate: AnyObject {
    func musicPanelDidDismiss()
}

class FloatingMusicPlayerView: UIView {
    // MARK: - Properties
    private let musicManager = MusicPlayerManager.shared
    private var initialPosition: CGPoint = .zero
    private var panGesture: UIPanGestureRecognizer!
    private var isPanelPresented = false
    private weak var currentPanelVC: MusicPlayerPanelViewController?
    private var rotationTimer: Timer?
    
    // MARK: - UI Elements
    private let containerView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let view = UIVisualEffectView(effect: blurEffect)
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        return view
    }()
    
    private let musicIconView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "music.note"))
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupGestures()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupGestures()
    }
    
    // MARK: - 配置视图
    private func setupView() {
        // 设置阴影
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 4
        
        // 添加容器视图
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 添加音乐图标
        containerView.contentView.addSubview(musicIconView)
        musicIconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        // 设置点击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        containerView.addGestureRecognizer(tapGesture)
        
        // 检查并更新图标旋转状态
        updateRotationStatus()
        
        // 添加音乐状态变化的监听
        NotificationCenter.default.addObserver(self, 
                                              selector: #selector(musicStatusChanged), 
                                              name: NSNotification.Name("MusicStatusChanged"), 
                                              object: nil)
    }
    
    deinit {
        stopRotation()
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupGestures() {
        // 添加拖动手势
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(panGesture)
    }
    
    // MARK: - 手势处理
    @objc private func handleTap() {
        // 如果面板已经显示，则关闭它
        if isPanelPresented {
            dismissCurrentPanel()
        } else {
            // 否则，打开面板
            openMusicPlayerPanel()
        }
    }
    
    private func dismissCurrentPanel() {
        currentPanelVC?.dismiss(animated: true)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        // 如果面板已显示，忽略拖动
        if isPanelPresented {
            return
        }
        
        let translation = gesture.translation(in: self.superview)
        
        switch gesture.state {
        case .began:
            initialPosition = self.center
        case .changed:
            self.center = CGPoint(x: initialPosition.x + translation.x,
                                 y: initialPosition.y + translation.y)
        case .ended, .cancelled:
            // 调整位置避免超出屏幕边界
            adjustPositionToScreenBoundaries()
        default:
            break
        }
    }
    
    private func adjustPositionToScreenBoundaries() {
        guard let superview = self.superview else { return }
        
        // 计算安全区域
        let safeAreaInsets: UIEdgeInsets
        if #available(iOS 11.0, *) {
            safeAreaInsets = UIApplication.shared.windows.first?.safeAreaInsets ?? .zero
        } else {
            safeAreaInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        }
        
        // 估计状态栏和TabBar的高度
        let statusBarHeight = safeAreaInsets.top
        let tabBarHeight: CGFloat = safeAreaInsets.bottom + 70.0
        
        // 顶部边界（导航栏已隐藏，只考虑状态栏）
        let topBoundary = statusBarHeight + self.frame.height / 2 + 10
        
        // 底部边界（考虑TabBar）
        let bottomBoundary = superview.frame.height - tabBarHeight - self.frame.height / 2 - 10
        
        // 左右边界（考虑屏幕边缘）
        let leftBoundary = self.frame.width / 2 + 10
        let rightBoundary = superview.frame.width - self.frame.width / 2 - 10
        
        var newCenter = self.center
        
        // 限制X坐标
        if newCenter.x < leftBoundary {
            newCenter.x = leftBoundary
        } else if newCenter.x > rightBoundary {
            newCenter.x = rightBoundary
        }
        
        // 限制Y坐标
        if newCenter.y < topBoundary {
            newCenter.y = topBoundary
        } else if newCenter.y > bottomBoundary {
            newCenter.y = bottomBoundary
        }
        
        // 使用动画移动到合法位置
        UIView.animate(withDuration: 0.3) {
            self.center = newCenter
        }
    }
    
    // MARK: - 打开音乐播放器面板
    private func openMusicPlayerPanel() {
        // 如果面板已经显示，不要再次打开
        if isPanelPresented {
            return
        }
        
        // 标记面板为已显示
        isPanelPresented = true
        
        // 隐藏浮动按钮
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0
        }
        
        let musicPanelVC = MusicPlayerPanelViewController()
        musicPanelVC.delegate = self
        currentPanelVC = musicPanelVC
        
        // 找到当前显示的视图控制器
        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            var currentViewController = rootViewController
            
            // 如果有呈现的控制器，使用最顶层的那个
            while let presentedViewController = currentViewController.presentedViewController {
                currentViewController = presentedViewController
            }
            
            // 以模态方式呈现音乐面板
            musicPanelVC.modalPresentationStyle = .pageSheet
            if #available(iOS 15.0, *) {
                if let sheet = musicPanelVC.sheetPresentationController {
                    sheet.detents = [.medium()]
                    sheet.prefersGrabberVisible = true
                }
            }
            currentViewController.present(musicPanelVC, animated: true)
        }
    }
    
    // 监听音乐状态变化
    @objc private func musicStatusChanged(_ notification: Notification) {
        updateRotationStatus()
    }
    
    // 更新旋转状态
    private func updateRotationStatus() {
        if musicManager.isCurrentlyPlaying() {
            startRotation()
        } else {
            stopRotation()
        }
    }
    
    // 开始旋转动画
    private func startRotation() {
        // 如果已经在旋转，不重复创建定时器
        if rotationTimer != nil {
            return
        }
        
        // 创建定时器执行旋转动画
        rotationTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.1) {
                self.musicIconView.transform = self.musicIconView.transform.rotated(by: .pi / 180)
            }
        }
    }
    
    // 停止旋转动画
    private func stopRotation() {
        rotationTimer?.invalidate()
        rotationTimer = nil
        // 重置旋转
        UIView.animate(withDuration: 0.3) {
            self.musicIconView.transform = .identity
        }
    }
}

// MARK: - MusicPlayerPanelDelegate
extension FloatingMusicPlayerView: MusicPlayerPanelDelegate {
    func musicPanelDidDismiss() {
        // 面板关闭时重置状态
        isPanelPresented = false
        currentPanelVC = nil
        
        // 显示浮动按钮
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
}

// MARK: - 音乐播放器面板视图控制器
class MusicPlayerPanelViewController: UIViewController {
    // MARK: - Properties
    private let musicManager = MusicPlayerManager.shared
    private var musicList: [String] = []
    weak var delegate: MusicPlayerPanelDelegate?
    private var currentPlayingCell: MusicCell?
    private var isShowingNowPlaying = false
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sound"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .secondaryLabel
        return button
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 15
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 30, left: 20, bottom: 0, right: 20)
        return collectionView
    }()
    
    private let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.value = 0.5
        slider.minimumTrackTintColor = .systemOrange
        return slider
    }()
    
    private let volumeMinIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "speaker.fill"))
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let volumeMaxIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "speaker.wave.3.fill"))
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nowPlayingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.secondarySystemBackground.withAlphaComponent(0.8)
        view.layer.cornerRadius = 20
        view.isHidden = true
        return view
    }()
    
    private let nowPlayingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    private let playPauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "forward.fill"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupActions()
        loadMusicList()
        updatePlayerStatus()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }
    
    // MARK: - 配置视图
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        // 添加标题和关闭按钮
        view.addSubview(titleLabel)
        view.addSubview(closeButton)
        
        // 添加集合视图
        view.addSubview(collectionView)
        collectionView.register(MusicCell.self, forCellWithReuseIdentifier: "MusicCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // 添加音量控制
        view.addSubview(volumeSlider)
        view.addSubview(volumeMinIcon)
        view.addSubview(volumeMaxIcon)
        
        // 添加正在播放视图
        view.addSubview(nowPlayingView)
        nowPlayingView.addSubview(nowPlayingLabel)
        nowPlayingView.addSubview(playPauseButton)
        nowPlayingView.addSubview(nextButton)
    }
    
    private func setupConstraints() {
        // 标题约束
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(closeButton.snp.left).offset(-10)
        }
        
        // 关闭按钮约束
        closeButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.right.equalToSuperview().offset(-20)
            make.width.height.equalTo(30)
        }
        
        // 集合视图约束
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(200)
        }
        
        // 音量图标约束
        volumeMinIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(25)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
            make.width.height.equalTo(20)
        }
        
        volumeMaxIcon.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-25)
            make.centerY.equalTo(volumeMinIcon)
            make.width.height.equalTo(20)
        }
        
        // 音量滑块约束
        volumeSlider.snp.makeConstraints { make in
            make.left.equalTo(volumeMinIcon.snp.right).offset(10)
            make.right.equalTo(volumeMaxIcon.snp.left).offset(-10)
            make.centerY.equalTo(volumeMinIcon)
            make.height.equalTo(20)
        }
        
        // 正在播放视图约束
        nowPlayingView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(volumeSlider.snp.top).offset(-30)
            make.height.equalTo(60)
        }
        
        // 正在播放标签约束
        nowPlayingLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.right.equalTo(playPauseButton.snp.left).offset(-10)
        }
        
        // 播放/暂停按钮约束
        playPauseButton.snp.makeConstraints { make in
            make.right.equalTo(nextButton.snp.left).offset(-15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        // 下一首按钮约束
        nextButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
    }
    
    private func setupActions() {
        // 设置关闭按钮动作
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        // 设置播放/暂停按钮动作
        playPauseButton.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        
        // 设置下一首按钮动作
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        // 设置音量滑块动作
        volumeSlider.addTarget(self, action: #selector(volumeChanged(_:)), for: .valueChanged)
    }
    
    private func loadMusicList() {
        musicList = ["None"] + musicManager.getAllMusicNames()
        collectionView.reloadData()
    }
    
    // 更新播放器状态
    private func updatePlayerStatus() {
        let (isPlaying, currentMusic) = musicManager.getPlayingStatus()
        
        // 更新播放按钮状态
        if isPlaying {
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
        
        // 更新正在播放视图
        if let music = currentMusic, isPlaying {
            nowPlayingView.isHidden = false
            isShowingNowPlaying = true
            nowPlayingLabel.text = "Playing: \(music)"
        } else {
            nowPlayingView.isHidden = true
            isShowingNowPlaying = false
        }
        
        // 设置音量滑块值
        volumeSlider.value = musicManager.volume
    }
    
    // MARK: - 按钮动作
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func playPauseButtonTapped() {
        let isPlaying = musicManager.togglePlayPause()
        
        // 更新按钮图标
        if isPlaying {
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
        
        updatePlayerStatus()
        collectionView.reloadData()
    }
    
    @objc private func nextButtonTapped() {
        musicManager.playNext()
        updatePlayerStatus()
        collectionView.reloadData()
    }
    
    @objc private func volumeChanged(_ slider: UISlider) {
        musicManager.volume = slider.value
    }
    
    // 在视图完全消失后通知委托
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.musicPanelDidDismiss()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MusicPlayerPanelViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MusicCell", for: indexPath) as? MusicCell else {
            return UICollectionViewCell()
        }
        
        let musicName = musicList[indexPath.item]
        var isSelected = false
        
        if indexPath.item == 0 {
            // "无"选项
            isSelected = !musicManager.isCurrentlyPlaying()
            cell.configure(title: "None", imageName: nil, isSelected: isSelected)
        } else {
            // 音乐选项
            let isCurrentlyPlaying = musicManager.currentMusicName == musicName && musicManager.isCurrentlyPlaying()
            isSelected = isCurrentlyPlaying
            
            // 根据索引选择不同的背景图片
            let imageIndex = (indexPath.item - 1) % 10 // 假设有10张背景图，循环使用
            let imageName = "zen_wall\(imageIndex)"
            
            cell.configure(title: musicName, imageName: imageName, isSelected: isSelected)
        }
        
        // 保存当前播放的单元格引用
        if isSelected && indexPath.item > 0 {
            currentPlayingCell = cell
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            // 选择"无"，停止播放
            musicManager.stop()
        } else {
            // 播放选中的音乐
            musicManager.playMusic(at: indexPath.item - 1)
        }
        
        // 更新UI
        updatePlayerStatus()
        collectionView.reloadData()
    }
}

// MARK: - 音乐单元格
class MusicCell: UICollectionViewCell {
    // MARK: - UI Elements
    private let containerView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let view = UIVisualEffectView(effect: blurEffect)
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.backgroundColor = UIColor.systemGray.withAlphaComponent(0.3)
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    // MARK: - 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - 配置视图
    private func setupView() {
        contentView.addSubview(containerView)
        containerView.contentView.addSubview(iconImageView)
        containerView.contentView.addSubview(titleLabel)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(5)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        titleLabel.text = nil
    }
    
    // MARK: - 配置单元格
    func configure(title: String, imageName: String?, isSelected: Bool) {
        titleLabel.text = title
        
        // 设置图片
        if let imageName = imageName, let image = UIImage(named: imageName) {
            iconImageView.image = image
            iconImageView.tintColor = .clear
        } else {
            // 默认图标
            iconImageView.image = UIImage(systemName: "")
            iconImageView.tintColor = isSelected ? .systemBlue : .label
        }
        
        if isSelected {
            containerView.effect = UIBlurEffect(style: .systemMaterial)
            containerView.layer.borderWidth = 2
            containerView.layer.borderColor = UIColor.systemBlue.cgColor
            titleLabel.textColor = .systemBlue
        } else {
            containerView.effect = UIBlurEffect(style: .systemUltraThinMaterial)
            containerView.layer.borderWidth = 0
            titleLabel.textColor = .label
        }
    }
} 
