import UIKit
import SnapKit

class BubbleView: UIView {
    private var animators: [UIViewPropertyAnimator] = []
    private var bubbleLayers: [CAShapeLayer] = []
    private var bubbleColors: [UIColor] = [
        UIColor(red: 0.7, green: 0.85, blue: 0.95, alpha: 0.3),
        UIColor(red: 0.75, green: 0.85, blue: 0.95, alpha: 0.2),
        UIColor(red: 0.8, green: 0.9, blue: 1.0, alpha: 0.15)
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // 创建圆形气泡
    func createBubbles() {
        clearBubbles()
        
        let count = 10 + Int.random(in: 0...3)
        for _ in 0..<count {
            let bubbleLayer = CAShapeLayer()
            let size = CGFloat.random(in: 50...120)
            
            // 创建圆形路径
            let path = UIBezierPath(
                arcCenter: CGPoint(x: size/2, y: size/2),
                radius: size/2,
                startAngle: 0,
                endAngle: 2 * CGFloat.pi,
                clockwise: true
            )
            
            bubbleLayer.path = path.cgPath
            bubbleLayer.fillColor = bubbleColors.randomElement()?.cgColor
            bubbleLayer.position = CGPoint(
                x: CGFloat.random(in: 0...frame.width),
                y: CGFloat.random(in: 0...frame.height)
            )
            
            layer.addSublayer(bubbleLayer)
            bubbleLayers.append(bubbleLayer)
            
            // 为每个气泡添加动画
            animateBubble(bubbleLayer)
        }
    }
    
    // 保留原有animateBubble方法
    private func animateBubble(_ bubbleLayer: CAShapeLayer) {
        // 位置动画
        let positionAnimation = CABasicAnimation(keyPath: "position")
        positionAnimation.fromValue = bubbleLayer.position
        positionAnimation.toValue = CGPoint(
            x: CGFloat.random(in: 0...frame.width),
            y: CGFloat.random(in: 0...frame.height)
        )
        
        // 缩放动画
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = CGFloat.random(in: 0.8...1.2)
        scaleAnimation.toValue = CGFloat.random(in: 0.8...1.2)
        
        // 透明度动画
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = CGFloat.random(in: 0.3...0.7)
        opacityAnimation.toValue = CGFloat.random(in: 0.3...0.7)
        
        // 组动画
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [positionAnimation, scaleAnimation, opacityAnimation]
        groupAnimation.duration = Double.random(in: 8...15)
        groupAnimation.repeatCount = .infinity
        groupAnimation.autoreverses = true
        groupAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        bubbleLayer.add(groupAnimation, forKey: "floatAnimation")
    }
    
    // 清除现有气泡
    func clearBubbles() {
        for animator in animators {
            animator.stopAnimation(true)
        }
        animators.removeAll()
        
        for layer in bubbleLayers {
            layer.removeFromSuperlayer()
        }
        bubbleLayers.removeAll()
    }
}

class CircleRingView: UIView {
    private var circleRings: [CAShapeLayer] = []
    private var currentPhase: BreathingPhase = .inhale
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupCircleRings()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCircleRings()
    }
    
    private func setupCircleRings() {
        // 清除现有圆环
        for ring in circleRings {
            ring.removeFromSuperlayer()
        }
        circleRings.removeAll()
        
        // 创建多层圆环 - 使用较粗的线条，环形之间不留间隙
        let ringCount = 4
        let maxRadius = min(bounds.width, bounds.height) / 2
        
        // 计算每个环的粗细，使环形之间不留间隙
        let ringThickness = maxRadius / CGFloat(ringCount)
        
        // 吸气颜色渐变 - 从外向内淡色到白色
        let inhaleColors = [
            UIColor(red: 1.0, green: 0.85, blue: 0.7, alpha: 0.7),
            UIColor(red: 1.0, green: 0.9, blue: 0.8, alpha: 0.6),
            UIColor(red: 1.0, green: 0.95, blue: 0.9, alpha: 0.5),
            UIColor.white.withAlphaComponent(0.4)
        ]
        
        for i in 0..<ringCount {
            // 计算环的半径，使环形之间不留间隙
            let radius = maxRadius - (ringThickness * CGFloat(i)) - (ringThickness / 2)
            
            let ringLayer = CAShapeLayer()
            ringLayer.path = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                                         radius: radius,
                                         startAngle: 0,
                                         endAngle: 2 * .pi,
                                         clockwise: true).cgPath
            ringLayer.fillColor = nil
            ringLayer.strokeColor = inhaleColors[i].cgColor
            ringLayer.lineWidth = ringThickness // 环形粗细等于间距，确保无间隙
            
            layer.addSublayer(ringLayer)
            circleRings.append(ringLayer)
        }
        
        // 中心圆
        let centerCircle = CAShapeLayer()
        centerCircle.path = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                                       radius: maxRadius / 5,
                                       startAngle: 0,
                                       endAngle: 2 * .pi,
                                       clockwise: true).cgPath
        centerCircle.fillColor = UIColor.white.cgColor
        layer.addSublayer(centerCircle)
        circleRings.append(centerCircle)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupCircleRings()
    }
    
    func animateForPhase(_ phase: BreathingPhase) {
        currentPhase = phase
        
        switch phase {
        case .inhale:
            animateInhale()
        case .hold:
            animateHold()
        case .exhale:
            animateExhale()
        }
    }
    
    private func animateInhale() {
        // 从小到大，橘色渐变
        UIView.animate(withDuration: 4.0, delay: 0, options: [.curveEaseInOut], animations: {
            self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.alpha = 1.0
            
            // 更新渐变色为吸气颜色
            let inhaleColors = [
                UIColor(red: 1.0, green: 0.85, blue: 0.7, alpha: 0.7),
                UIColor(red: 1.0, green: 0.9, blue: 0.8, alpha: 0.6),
                UIColor(red: 1.0, green: 0.95, blue: 0.9, alpha: 0.5),
                UIColor.white.withAlphaComponent(0.4)
            ]
            
            for (i, ring) in self.circleRings.dropLast().enumerated() {
                ring.strokeColor = inhaleColors[i].cgColor
            }
        })
    }
    
    private func animateHold() {
        // 保持大小，可能轻微脉动
        UIView.animate(withDuration: 1.0, delay: 0, options: [.autoreverse, .repeat], animations: {
            self.transform = CGAffineTransform(scaleX: 1.32, y: 1.32)
        })
    }
    
    private func animateExhale() {
        // 从大到小，粉色渐变
        CATransaction.begin()
        CATransaction.setAnimationDuration(8.0)
        
        UIView.animate(withDuration: 8.0, delay: 0, options: [.curveEaseInOut], animations: {
            self.transform = .identity
            
            // 更新渐变色为呼气颜色
            let exhaleColors = [
                UIColor(red: 0.9, green: 0.9, blue: 0.95, alpha: 0.7),
                UIColor(red: 0.85, green: 0.85, blue: 0.9, alpha: 0.6),
                UIColor(red: 0.8, green: 0.8, blue: 0.85, alpha: 0.5),
                UIColor.white.withAlphaComponent(0.4)
            ]
            
            for (i, ring) in self.circleRings.dropLast().enumerated() {
                ring.strokeColor = exhaleColors[i].cgColor
            }
        })
        
        CATransaction.commit()
    }
}

class BreathingExerciseViewController: BaseViewController {
    
    // MARK: - Properties
    private var timer: Timer?
    private var progressUpdateTimer: Timer? // 用于平滑更新进度条的定时器
    private var breathingPhase: BreathingPhase = .inhale
    private var secondsRemaining: Int = 0
    private var totalSeconds: Int = 0
    private var currentCycle: Int = 0
    private var totalCycles: Int = 5
    private var breathAnimationDisplayLink: CADisplayLink?
    private var phaseStartTime: CFTimeInterval = 0
    private var isExerciseRunning: Bool = false
    private var currentPhaseFullDuration: Int = 4 // 默认为吸气阶段时长
    private var progressValue: CGFloat = 1.0 // 进度条当前值，1.0表示满格
    
    // MARK: - UI Components
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Enjoy 5 deep breaths"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let circleRingView: CircleRingView = {
        let view = CircleRingView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let phaseLabel: UILabel = {
        let label = UILabel()
        label.text = "Breath In"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.text = "00:04"
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let bubbleAnimationView: BubbleView = {
        let view = BubbleView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var startStopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(startStopButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let progressContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        view.layer.cornerRadius = 2
        view.clipsToBounds = true
        return view
    }()
    
    private let progressBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.layer.cornerRadius = 2
        return view
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置为全屏模态展示
        modalPresentationStyle = .fullScreen
        setupUI()
        
        // 立即创建气泡，解决首次加载无动画问题
        DispatchQueue.main.async {
            self.bubbleAnimationView.createBubbles()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 再次确认气泡被创建
        if bubbleAnimationView.layer.sublayers?.count ?? 0 <= 0 {
            bubbleAnimationView.createBubbles()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopBreathingExercise()
        breathAnimationDisplayLink?.invalidate()
        breathAnimationDisplayLink = nil
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // 设置背景渐变色
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(red: 0.85, green: 0.9, blue: 0.95, alpha: 1.0).cgColor,
            UIColor(red: 0.8, green: 0.85, blue: 0.95, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // 添加UI组件 (不使用滚动视图，也不添加statusBarView)
        view.addSubview(headerView)
        view.addSubview(bubbleAnimationView)
        view.addSubview(circleRingView)
        view.addSubview(phaseLabel)
        view.addSubview(countLabel)
        view.addSubview(progressContainerView)
        progressContainerView.addSubview(progressBarView)
        view.addSubview(startStopButton)
        
        // 添加返回按钮和标题到顶部
        headerView.addSubview(backButton)
        headerView.addSubview(titleLabel)
        
        // 获取屏幕高度，用于自适应布局
        let screenHeight = UIScreen.main.bounds.height
        
        // 根据屏幕高度调整环形大小
        let circleSize: CGFloat = screenHeight < 700 ? 200 : 250
        
        // 顶部视图约束 - 直接从安全区域顶部开始
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        // 返回按钮约束
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        // 标题约束
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        // 气泡动画视图约束
        bubbleAnimationView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        // 环形视图约束 - 居中但向上移动
        circleRingView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            // 向上移动一定距离
            make.centerY.equalToSuperview().offset(screenHeight < 700 ? -40 : -60)
            make.width.height.equalTo(circleSize)
        }
        
        // 呼吸提示文字与环形的间距根据屏幕高度调整
        let topOffset = screenHeight < 700 ? 60 : 70
        phaseLabel.snp.makeConstraints { make in
            make.top.equalTo(circleRingView.snp.bottom).offset(topOffset)
            make.centerX.equalToSuperview()
        }
        
        // 倒计时文字与提示文字的间距也调整
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(phaseLabel.snp.bottom).offset(screenHeight < 700 ? 5 : 10)
            make.centerX.equalToSuperview()
        }
        
        // 进度条容器视图约束
        progressContainerView.snp.makeConstraints { make in
            make.top.equalTo(countLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(4)
        }
        
        // 进度条视图初始状态
        progressBarView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalToSuperview() // 初始状态为满格
        }
        
        // Start/Stop按钮在底部，距离也根据屏幕高度调整
        startStopButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(screenHeight < 700 ? -20 : -40)
            make.width.equalTo(screenHeight < 700 ? 180 : 200)
            make.height.equalTo(screenHeight < 700 ? 45 : 50)
        }
    }
    
    // MARK: - Actions
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func startStopButtonTapped() {
        if isExerciseRunning {
            stopBreathingExercise()
            startStopButton.setTitle("Start", for: .normal)
        } else {
            startBreathingExercise()
            startStopButton.setTitle("Stop", for: .normal)
        }
        isExerciseRunning = !isExerciseRunning
    }
    
    // MARK: - Breathing Exercise
    private func startBreathingExercise() {
        // 重置值
        currentCycle = 0
        totalSeconds = 0
        breathingPhase = .inhale
        
        // 启动呼吸动画显示链接
        setupBreathAnimationDisplayLink()
        
        // 开始计时器
        startNextBreathingPhase()
    }
    
    private func stopBreathingExercise() {
        // 停止计时器
        timer?.invalidate()
        timer = nil
        
        // 停止进度条更新计时器
        progressUpdateTimer?.invalidate()
        progressUpdateTimer = nil
        
        // 停止动画显示链接
        breathAnimationDisplayLink?.invalidate()
        breathAnimationDisplayLink = nil
        
        // 重置UI
        phaseLabel.text = "Breath In"
        countLabel.text = "00:04"
        
        // 重置圆形大小
        UIView.animate(withDuration: 0.3) {
            self.circleRingView.transform = .identity
        }
        
        // 重置进度条
        progressValue = 1.0
        updateProgressBarWithValue(progressValue)
    }
    
    private func setupBreathAnimationDisplayLink() {
        breathAnimationDisplayLink?.invalidate()
        
        breathAnimationDisplayLink = CADisplayLink(target: self, selector: #selector(updateBreathAnimation))
        breathAnimationDisplayLink?.add(to: .main, forMode: .common)
        phaseStartTime = CACurrentMediaTime()
    }
    
    @objc private func updateBreathAnimation() {
        // 在DisplayLink回调中更新时间
        updateRemainingTimeLabel()
    }
    
    private func startNextBreathingPhase() {
        // 检查是否完成了所有循环
        if currentCycle >= totalCycles {
            stopBreathingExercise()
            showCompletionAlert()
            isExerciseRunning = false
            startStopButton.setTitle("Start", for: .normal)
            return
        }
        
        // 设置下一阶段
        phaseStartTime = CACurrentMediaTime()
        
        // 振动反馈提醒状态转换
        provideFeedback()
        
        switch breathingPhase {
        case .inhale:
            secondsRemaining = 4
            currentPhaseFullDuration = 4
            phaseLabel.text = "Breath In"
            circleRingView.animateForPhase(.inhale)
            breathingPhase = .hold
        case .hold:
            secondsRemaining = 7
            currentPhaseFullDuration = 7
            phaseLabel.text = "Hold"
            circleRingView.animateForPhase(.hold)
            breathingPhase = .exhale
        case .exhale:
            secondsRemaining = 8
            currentPhaseFullDuration = 8
            phaseLabel.text = "Breath Out"
            circleRingView.animateForPhase(.exhale)
            breathingPhase = .inhale
            currentCycle += 1
        }
        
        // 重置进度值和进度条
        progressValue = 1.0
        updateProgressBarWithValue(progressValue)
        
        // 更新计时器标签
        updateRemainingTimeLabel()
        
        // 启动倒计时
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            self.secondsRemaining -= 1
            self.updateRemainingTimeLabel()
            
            if self.secondsRemaining <= 0 {
                timer.invalidate()
                self.progressUpdateTimer?.invalidate()
                self.startNextBreathingPhase()
            }
        }
        
        // 启动进度条平滑更新计时器
        setupProgressUpdateTimer()
    }
    
    private func setupProgressUpdateTimer() {
        // 停止现有计时器
        progressUpdateTimer?.invalidate()
        
        // 计算每次更新的减少量
        let decrementPerInterval = 1.0 / (CGFloat(currentPhaseFullDuration) * 100.0) // 10 = 1秒/0.1秒
        
        // 创建新计时器，每0.1秒更新一次
        progressUpdateTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            // 计算新的进度值
            self.progressValue = max(0, self.progressValue - decrementPerInterval)
            
            // 更新进度条
            self.updateProgressBarWithValue(self.progressValue)
        }
        
        // 确保计时器在滚动时也能运行
        RunLoop.current.add(progressUpdateTimer!, forMode: .common)
    }
    
    private func updateProgressBarWithValue(_ value: CGFloat) {
        // 直接更新进度条宽度，无动画以避免卡顿
        progressBarView.snp.remakeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(value)
        }
        
        // 使用layoutIfNeeded()实时更新但不使用动画
        UIView.performWithoutAnimation {
            self.view.layoutIfNeeded()
        }
    }
    
    private func provideFeedback() {
        // 触觉反馈
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
    
    private func updateRemainingTimeLabel() {
        let minutes = secondsRemaining / 60
        let seconds = secondsRemaining % 60
        countLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func showCompletionAlert() {
        let alert = UIAlertController(
            title: "Exercise Complete",
            message: "Great job! You've completed the breathing exercise. How do you feel?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Relaxed", style: .default) { _ in
            self.dismiss(animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "Try Again", style: .default) { _ in
            self.startBreathingExercise()
            self.isExerciseRunning = true
            self.startStopButton.setTitle("Stop", for: .normal)
        })
        
        present(alert, animated: true)
    }
}

// MARK: - Breathing Phase Enum
enum BreathingPhase {
    case inhale
    case hold
    case exhale
} 
