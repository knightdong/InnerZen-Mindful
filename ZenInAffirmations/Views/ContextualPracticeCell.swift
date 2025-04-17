import UIKit
import Kingfisher
import SnapKit

class ContextualPracticeCell: UICollectionViewCell {
    
    static let identifier = "ContextualPracticeCell"
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.masksToBounds = false
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    private let darkOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    private let gradientView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 2
        label.isHidden = true
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
    
    private let gradientLayer = CAGradientLayer()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupGradientLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupGradientLayer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    // MARK: - Setup
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        imageView.addSubview(darkOverlayView)
        imageView.addSubview(gradientView)
        
        gradientView.addSubview(titleLabel)
        containerView.addSubview(durationBadge)
        durationBadge.addSubview(durationLabel)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        darkOverlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        gradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        durationBadge.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.width.greaterThanOrEqualTo(60)
            make.height.equalTo(24)
        }
        
        durationLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
        }
    }
    
    private func setupGradientLayer() {
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.8).cgColor
        ]
        gradientLayer.locations = [0.3, 1.0]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - Configuration
    func configure(with practice: ContextualPractice) {
        titleLabel.text = practice.title
        descriptionLabel.text = practice.description
        
        let minutes = practice.duration / 60
        durationLabel.text = "\(minutes) min"
        durationBadge.isHidden = false
        
        loadImage(urlString: practice.context.imageURL, fileName: practice.context.rawValue)
    }
    
    // For category cells
    func configure(with context: PracticeContext) {
        titleLabel.text = context.displayName
        descriptionLabel.text = context.description
        
        durationBadge.isHidden = true
        
        loadImage(urlString: context.imageURL, fileName: context.rawValue)
    }
    
    // 加载图片的辅助方法
    private func loadImage(urlString: String, fileName: String) {
        ImageManager.shared.getImage(urlString: urlString, fileName: fileName) { [weak self] image in
            guard let self = self else { return }
            
            if let image = image {
                self.imageView.image = image
            } else {
                self.imageView.image = UIImage(systemName: "photo")
            }
        }
    }
} 