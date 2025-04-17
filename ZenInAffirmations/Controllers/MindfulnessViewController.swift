import UIKit
import SnapKit

class MindfulnessViewController: BaseViewController {
    
    // MARK: - Properties
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // MARK: - UI Components
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Mindfulness"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let subHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Focus on your mental wellness"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var breathingCard: PracticeCardView = {
        let card = PracticeCardView()
        card.configure(with: "Breathing Exercise", 
                      description: "Calm your mind with breathing techniques",
                      iconName: "wind")
        card.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(breathingCardTapped)))
        card.setImage(UIImage(named: "breathe"))
        return card
    }()
    
    private lazy var meditationCard: PracticeCardView = {
        let card = PracticeCardView()
        card.configure(with: "Meditation Guide", 
                      description: "Guided sessions for inner peace",
                      iconName: "figure.mind.and.body")
        card.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(meditationCardTapped)))
        card.setImage(UIImage(named: "meditation"))
        return card
    }()
    
    private lazy var moodTrackingCard: PracticeCardView = {
        let card = PracticeCardView()
        card.configure(with: "Mood Tracking", 
                      description: "Monitor and improve your emotional well-being",
                      iconName: "chart.bar.fill")
        card.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moodTrackingCardTapped)))
        card.setImage(UIImage(named: "enmotion"))
        return card
    }()
    
    private let dailyQuoteView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0)
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let quoteLabel: UILabel = {
        let label = UILabel()
        label.text = "\"The present moment is the only moment where life exists.\""
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let quoteAuthorLabel: UILabel = {
        let label = UILabel()
        label.text = "- Thich Nhat Hanh"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray2
        label.textAlignment = .right
        return label
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadRandomQuote()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Setup scroll view
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalTo(view.frame.width)
            make.bottom.equalToSuperview() // This will allow the content to expand vertically
        }
        
        // Add and configure header
        contentView.addSubview(headerLabel)
        contentView.addSubview(subHeaderLabel)
        
        headerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        subHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(headerLabel)
        }
        
        // Add practice cards
        contentView.addSubview(breathingCard)
        contentView.addSubview(meditationCard)
        contentView.addSubview(moodTrackingCard)
        
        breathingCard.snp.makeConstraints { make in
            make.top.equalTo(subHeaderLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(160)
        }
        
        meditationCard.snp.makeConstraints { make in
            make.top.equalTo(breathingCard.snp.bottom).offset(20)
            make.leading.trailing.height.equalTo(breathingCard)
        }
        
        moodTrackingCard.snp.makeConstraints { make in
            make.top.equalTo(meditationCard.snp.bottom).offset(20)
            make.leading.trailing.height.equalTo(breathingCard)
        }
        
        // Add daily quote view
        contentView.addSubview(dailyQuoteView)
        dailyQuoteView.addSubview(quoteLabel)
        dailyQuoteView.addSubview(quoteAuthorLabel)
        
        dailyQuoteView.snp.makeConstraints { make in
            make.top.equalTo(moodTrackingCard.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-60) // This creates space at the bottom
        }
        
        quoteLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        quoteAuthorLabel.snp.makeConstraints { make in
            make.top.equalTo(quoteLabel.snp.bottom).offset(12)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    // MARK: - Actions
    @objc private func breathingCardTapped() {
        let breathingVC = BreathingExerciseViewController()
        breathingVC.modalPresentationStyle = .fullScreen
        present(breathingVC, animated: true)
    }
    
    @objc private func meditationCardTapped() {
        let meditationVC = MeditationGuideViewController()
        meditationVC.modalPresentationStyle = .fullScreen
        present(meditationVC, animated: true)
    }
    
    @objc private func moodTrackingCardTapped() {
        let moodVC = MoodTrackingViewController()
        moodVC.modalPresentationStyle = .fullScreen
        present(moodVC, animated: true)
    }
    
    // MARK: - Helper Methods
    private func loadRandomQuote() {
        // In a real app, this would come from a quotes database or API
        let quotes = [
            ("The present moment is the only moment where life exists.", "Thich Nhat Hanh"),
            ("Breathing in, I calm body and mind. Breathing out, I smile.", "Thich Nhat Hanh"),
            ("You are the sky. Everything else is just the weather.", "Pema Chödrön"),
            ("The best way to capture moments is to pay attention.", "Jon Kabat-Zinn"),
            ("Mindfulness isn't difficult, we just need to remember to do it.", "Sharon Salzberg")
        ]
        
        let randomQuote = quotes.randomElement()!
        quoteLabel.text = "\"\(randomQuote.0)\""
        quoteAuthorLabel.text = "- \(randomQuote.1)"
    }
}

// MARK: - Practice Card View
class PracticeCardView: UIView {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemOrange
        return imageView
    }()
    
    private let placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .tertiarySystemBackground
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray
        imageView.alpha = 0
        return imageView
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    private func setupView() {
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(iconView)
        containerView.addSubview(placeholderImageView)
        containerView.addSubview(arrowImageView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(20)
            make.width.height.equalTo(32)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(iconView.snp.bottom).offset(12)
            make.trailing.equalToSuperview().offset(-110)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.trailing.equalTo(titleLabel)
        }
        
        placeholderImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(placeholderImageView.snp.leading).offset(-10)
            make.width.height.equalTo(20)
        }
        
        // Add shadow to the container
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.1
        layer.masksToBounds = false
    }
    
    // MARK: - Configuration
    func configure(with title: String, description: String, iconName: String) {
        titleLabel.text = title
        descriptionLabel.text = description
        iconView.image = UIImage(systemName: iconName)
    }
    
    // For setting actual image later
    func setImage(_ image: UIImage?) {
        placeholderImageView.image = image
    }
} 
