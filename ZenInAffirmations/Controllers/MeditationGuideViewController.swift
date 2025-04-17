import UIKit
import SnapKit
import AVFoundation

class MeditationGuideViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Enums
    enum MeditationStage: Int, CaseIterable {
        case preparation = 0
        case breathing = 1
        case bodyScan = 4
        case thoughtObservation = 7
        case closing = 10
        
        var title: String {
            switch self {
            case .preparation: return "Preparation"
            case .breathing: return "Focus on Breathing"
            case .bodyScan: return "Body Scan"
            case .thoughtObservation: return "Observe Thoughts"
            case .closing: return "Closing"
            }
        }
        
        var instruction: String {
            switch self {
            case .preparation:
                return "Find a quiet place. Sit or lie down comfortably. Close your eyes, relax your shoulders, facial muscles, and jaw. Take a moment to settle in."
            case .breathing:
                return "Focus your attention on your breath. As you inhale, mentally note 'breathing in'. As you exhale, note 'breathing out'. Just observe your natural breathing pattern without changing it. If your mind wanders, gently bring your attention back to your breath."
            case .bodyScan:
                return "Now bring your awareness to your body. Starting from your toes, gradually move your attention upward. Notice any sensations in your feet, legs, back, abdomen, chest, arms, hands, neck, face, and head. Spend a few seconds on each area, simply observing without judgment."
            case .thoughtObservation:
                return "Now allow your thoughts to come and go. Watch them like clouds passing across the sky. Don't engage with them or judge them. Just observe them arise and fade away. You are the observer, not the thinker."
            case .closing:
                return "Gradually bring your attention back to your breath. Take three deep breaths. Gently move your fingers and toes. When you're ready, slowly open your eyes. Thank yourself for taking this time for inner peace."
            }
        }
        
        var emoji: String {
            switch self {
            case .preparation: return "🧘‍♂️"
            case .breathing: return "🌿"
            case .bodyScan: return "🌀"
            case .thoughtObservation: return "💭"
            case .closing: return "🌈"
            }
        }
        
        var minuteRange: String {
            switch self {
            case .preparation: return "Minute 0-1"
            case .breathing: return "Minutes 1-3"
            case .bodyScan: return "Minutes 4-6"
            case .thoughtObservation: return "Minutes 7-9"
            case .closing: return "Minute 10"
            }
        }
        
        static func stageForMinute(_ minute: Int) -> MeditationStage {
            return MeditationStage.allCases.last { $0.rawValue <= minute } ?? .preparation
        }
    }
    
    // MARK: - Model
    struct MeditationStep {
        let stage: MeditationStage
        let title: String
        let minuteRange: String
        let emoji: String
        let instruction: String
    }
    
    // MARK: - Properties
    private var timer: Timer?
    private var elapsedSeconds: Int = 0
    private var totalDuration: Int = 10 * 60 // 10 minutes in seconds
    private var currentStage: MeditationStage = .preparation
    private var isSessionActive = false
    private var speechSynthesizer = AVSpeechSynthesizer()
    private let musicManager = MusicPlayerManager.shared
    private var previousMusicVolume: Float = 1.0
    
    private var meditationSteps: [MeditationStep] = []
    
    // MARK: - UI Components
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 1.0) // Deep blue background
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "10-Minute Meditation"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let centerTimerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.1)
        view.layer.cornerRadius = 60
        view.alpha = 0 // 初始时隐藏
        return view
    }()
    
    private let centerTimerLabel: UILabel = {
        let label = UILabel()
        label.text = "10:00"
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 64, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let centerStageLabel: UILabel = {
        let label = UILabel()
        label.text = "Preparation"
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let stepsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = true
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        tableView.register(MeditationStepCell.self, forCellReuseIdentifier: "StepCell")
        return tableView
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Begin Meditation", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.8, alpha: 1.0) // Calming blue
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.trackTintColor = UIColor(white: 1, alpha: 0.2)
        progressView.progressTintColor = UIColor(red: 0.4, green: 0.8, blue: 0.9, alpha: 1.0)
        progressView.layer.cornerRadius = 2
        progressView.clipsToBounds = true
        progressView.progress = 0
        return progressView
    }()
    
    // MARK: - Initialization
    init() {
        super.init(nibName: nil, bundle: nil)
        // 设置为全屏模态呈现
        modalPresentationStyle = .fullScreen
        
        // 初始化冥想步骤数据
        setupMeditationSteps()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // 设置为全屏模态呈现
        modalPresentationStyle = .fullScreen
        
        // 初始化冥想步骤数据
        setupMeditationSteps()
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureAudioSession()
        updateTimerLabel()
        
        // 自动播放背景音乐
        playBackgroundMusic()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isSessionActive {
            stopSession()
        }
        
        // 恢复原来的音乐播放状态
        restoreMusicSettings()
    }
    
    // MARK: - Setup
    private func setupMeditationSteps() {
        for stage in MeditationStage.allCases {
            let step = MeditationStep(
                stage: stage,
                title: stage.title,
                minuteRange: stage.minuteRange,
                emoji: stage.emoji,
                instruction: stage.instruction
            )
            meditationSteps.append(step)
        }
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .black
        
        // Add background view
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Add center timer view
        view.addSubview(centerTimerContainer)
        centerTimerContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(220)
        }
        
        centerTimerContainer.addSubview(centerTimerLabel)
        centerTimerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-15)
        }
        
        centerTimerContainer.addSubview(centerStageLabel)
        centerStageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(centerTimerLabel.snp.bottom).offset(10)
        }
        
        // Add close button
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(40)
        }
        
        // Add title label
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(26)
            make.centerX.equalToSuperview()
        }
        
        // Add progress view
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(4)
        }
        
        // Add table view
        view.addSubview(stepsTableView)
        stepsTableView.delegate = self
        stepsTableView.dataSource = self
        stepsTableView.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        // Add start button (fixed at bottom)
        view.addSubview(startButton)
        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(50)
        }
        
        // Bring button to front to ensure it's above the table view
        view.bringSubviewToFront(startButton)
    }
    
    // MARK: - TableView Delegate & DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meditationSteps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StepCell", for: indexPath) as! MeditationStepCell
        let step = meditationSteps[indexPath.row]
        cell.configure(with: step)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = MeditationHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 120))
        headerView.timerLabel.text = String(format: "%02d:%02d", totalDuration / 60, totalDuration % 60)
        headerView.stageLabel.text = currentStage.title
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 140
    }
    
    // MARK: - Music Control
    private func playBackgroundMusic() {
        // 保存原来的音量
        previousMusicVolume = musicManager.volume
        
        // 如果已经在播放音乐，将音量设为50%
        if musicManager.isCurrentlyPlaying() {
            musicManager.volume = 0.5
            return
        }
        
        // 如果没有播放音乐，播放第一首并设置音量为50%
        musicManager.playMusic(at: 0)
        musicManager.volume = 0.5
    }
    
    private func restoreMusicSettings() {
        // 恢复原来的音量
        musicManager.volume = previousMusicVolume
    }
    
    // MARK: - Audio Setup
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .duckOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    private func speak(_ text: String, rate: Float = 0.5) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = rate
        utterance.pitchMultiplier = 1.0
        utterance.volume = 1.0
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        speechSynthesizer.speak(utterance)
    }
    
    // MARK: - Meditation Session Control
    private func startSession() {
        isSessionActive = true
        elapsedSeconds = 0
        currentStage = .preparation
        
        // Update UI
        startButton.setTitle("End Meditation", for: .normal)
        startButton.backgroundColor = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0) // Red for stop
        
        // Speak initial instructions
        speak(MeditationStage.preparation.instruction)
        
        // Start timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateSession()
        }
        
        // Hide table view and show center timer when session starts
        UIView.animate(withDuration: 0.5) {
            self.stepsTableView.alpha = 0
            self.centerTimerContainer.alpha = 1
            
            // Update center timer
            self.centerTimerLabel.text = String(format: "%02d:%02d", self.totalDuration / 60, self.totalDuration % 60)
            self.centerStageLabel.text = self.currentStage.title
        }
    }
    
    private func stopSession() {
        isSessionActive = false
        
        // Stop timer
        timer?.invalidate()
        timer = nil
        
        // Stop speech
        speechSynthesizer.stopSpeaking(at: .immediate)
        
        // Update UI
        startButton.setTitle("Begin Meditation", for: .normal)
        startButton.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.8, alpha: 1.0) // Back to blue
        progressView.progress = 0
        elapsedSeconds = 0
        updateTimerLabel()
        
        // Reload header view to update stage label
        stepsTableView.reloadSections(IndexSet(integer: 0), with: .none)
        
        // Hide center timer and show table view
        UIView.animate(withDuration: 0.5) {
            self.centerTimerContainer.alpha = 0
            self.stepsTableView.alpha = 1
        }
    }
    
    private func updateSession() {
        elapsedSeconds += 1
        
        // Check if session is complete
        if elapsedSeconds >= totalDuration {
            sessionCompleted()
            return
        }
        
        // Update timer label and progress
        updateTimerLabel()
        progressView.progress = Float(elapsedSeconds) / Float(totalDuration)
        
        // Check for stage transitions
        let currentMinute = elapsedSeconds / 60
        let newStage = MeditationStage.stageForMinute(currentMinute)
        
        // If we've entered a new stage, update UI and speak instructions
        if newStage != currentStage {
            stageTransition(to: newStage)
        }
    }
    
    private func stageTransition(to newStage: MeditationStage) {
        // Update current stage
        currentStage = newStage
        
        // Update center stage label
        centerStageLabel.text = newStage.title
        
        // Provide haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        // Speak the new stage instructions
        speak(newStage.instruction)
    }
    
    private func sessionCompleted() {
        // Stop the timer
        timer?.invalidate()
        timer = nil
        
        // Play completion sound or speech
        speak("Your meditation session is complete. Thank you for taking this time for yourself today.")
        
        // Return to session setup state
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.stopSession()
            
            // Show completion alert
            let alert = UIAlertController(
                title: "Meditation Complete",
                message: "Well done! You've completed your 10-minute meditation session.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Thank You", style: .default))
            self?.present(alert, animated: true)
        }
    }
    
    private func updateTimerLabel() {
        let remainingSeconds = totalDuration - elapsedSeconds
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        
        // Update center timer
        centerTimerLabel.text = String(format: "%02d:%02d", minutes, seconds)
        
        // Find header view and update timer label
        if let headerView = stepsTableView.headerView(forSection: 0) as? MeditationHeaderView {
            headerView.timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
            headerView.stageLabel.text = currentStage.title
        }
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        if isSessionActive {
            // Ask for confirmation if session is active
            let alert = UIAlertController(
                title: "End Meditation?",
                message: "Are you sure you want to end your meditation session?",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "End Session", style: .destructive) { [weak self] _ in
                self?.stopSession()
                self?.dismiss(animated: true)
            })
            
            present(alert, animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    @objc private func startButtonTapped() {
        if isSessionActive {
            // Confirm before ending
            let alert = UIAlertController(
                title: "End Meditation?",
                message: "Are you sure you want to end your meditation session?",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "End Session", style: .destructive) { [weak self] _ in
                self?.stopSession()
            })
            
            present(alert, animated: true)
        } else {
            startSession()
        }
    }
}

// MARK: - Custom Header View
class MeditationHeaderView: UIView {
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "10:00"
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 72, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let stageLabel: UILabel = {
        let label = UILabel()
        label.text = "Preparation"
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(timerLabel)
        addSubview(stageLabel)
        
        timerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        
        stageLabel.snp.makeConstraints { make in
            make.top.equalTo(timerLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
    }
}

// MARK: - Custom Cell
class MeditationStepCell: UITableViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.1)
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 36)
        label.textAlignment = .center
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let minuteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(white: 0.9, alpha: 0.8)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(emojiLabel)
        containerView.addSubview(titleLabel)
        containerView.addSubview(minuteLabel)
        containerView.addSubview(descriptionLabel)
        
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        emojiLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalTo(emojiLabel.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        minuteLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(emojiLabel.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(minuteLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    func configure(with step: MeditationGuideViewController.MeditationStep) {
        emojiLabel.text = step.emoji
        titleLabel.text = step.title
        minuteLabel.text = step.minuteRange
        descriptionLabel.text = step.instruction
    }
} 
