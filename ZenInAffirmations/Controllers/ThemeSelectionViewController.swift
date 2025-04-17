import UIKit
import SnapKit

class ThemeSelectionViewController: BaseViewController {
    
    // MARK: - Properties
    private let closeButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let collectionView: UICollectionView
    private let segmentedControl = UISegmentedControl(items: ["Colors", "Images"])
    
    private var currentTheme: ThemeType
    weak var delegate: ThemeSelectionDelegate?
    
    private let themes: [ThemeType] = ThemeType.allCases
    private var colorThemes: [ThemeType] = []
    private var wallpaperThemes: [ThemeType] = []
    private var isShowingColorThemes: Bool = true
    
    // MARK: - Initialization
    init(currentTheme: ThemeType) {
        self.currentTheme = currentTheme
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(nibName: nil, bundle: nil)
        
        // Initialize color and image theme arrays
        filterThemes()
        
        // Set initial segment selection based on current theme
        isShowingColorThemes = !currentTheme.isWallpaper
        
        modalPresentationStyle = .pageSheet
        if #available(iOS 15.0, *) {
            if let sheet = sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func filterThemes() {
        // Filter theme arrays
        colorThemes = themes.filter { !$0.isWallpaper }
        wallpaperThemes = themes.filter { $0.isWallpaper }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Title
        titleLabel.text = "Theme Selection"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // Close button
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.tintColor = .gray
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        
        // Segmented Control
        segmentedControl.selectedSegmentIndex = isShowingColorThemes ? 0 : 1
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        // Collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        collectionView.register(ThemeCell.self, forCellWithReuseIdentifier: "ThemeCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            // Close button constraints
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            
            // Title constraints
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Segmented control constraints
            segmentedControl.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            segmentedControl.heightAnchor.constraint(equalToConstant: 36),
            
            // Collection view constraints
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        isShowingColorThemes = sender.selectedSegmentIndex == 0
        collectionView.reloadData()
    }
    
    // Get current displayed themes
    private func getCurrentThemes() -> [ThemeType] {
        return isShowingColorThemes ? colorThemes : wallpaperThemes
    }
}

// MARK: - UICollectionViewDataSource
extension ThemeSelectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getCurrentThemes().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let theme = getCurrentThemes()[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThemeCell", for: indexPath) as! ThemeCell
        cell.configure(with: theme, isSelected: theme == currentTheme)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ThemeSelectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedTheme = getCurrentThemes()[indexPath.item]
        currentTheme = selectedTheme
        
        // Notify delegate and save settings
        delegate?.didSelectTheme(selectedTheme)
        UserDefaults.standard.set(selectedTheme.rawValue, forKey: "selectedTheme")
        
        // Update selection state
        collectionView.reloadData()
        
        // Close controller
        dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ThemeSelectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 48) / 2
        return CGSize(width: width, height: width * 0.75)
    }
}

// MARK: - ThemeCell
class ThemeCell: UICollectionViewCell {
    private let themeImageView = UIImageView()
    private let themeNameLabel = UILabel()
    private let selectedIndicator = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Container setup
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        
        // Image view
        themeImageView.contentMode = .scaleAspectFill
        themeImageView.clipsToBounds = true
        themeImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(themeImageView)
        
        // Label
        themeNameLabel.textAlignment = .center
        themeNameLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        themeNameLabel.textColor = .white
        themeNameLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        themeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(themeNameLabel)
        
        // Selection indicator
        selectedIndicator.image = UIImage(systemName: "checkmark.circle.fill")
        selectedIndicator.tintColor = .white
        selectedIndicator.contentMode = .scaleAspectFit
        selectedIndicator.isHidden = true
        selectedIndicator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(selectedIndicator)
        
        NSLayoutConstraint.activate([
            // Image constraints
            themeImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            themeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            themeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            themeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Label constraints
            themeNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            themeNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            themeNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            themeNameLabel.heightAnchor.constraint(equalToConstant: 30),
            
            // Selection indicator constraints
            selectedIndicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            selectedIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            selectedIndicator.widthAnchor.constraint(equalToConstant: 24),
            selectedIndicator.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configure(with theme: ThemeType, isSelected: Bool) {
        themeNameLabel.text = theme.displayName
        
        // Set theme image
        if let imageName = theme.imageName {
            themeImageView.image = UIImage(named: imageName)
        } else {
            // If no image, use theme color
            themeImageView.image = nil
            themeImageView.backgroundColor = theme.backgroundColor
        }
        
        // Set selection state
        selectedIndicator.isHidden = !isSelected
        
        if isSelected {
            contentView.layer.borderWidth = 2
            contentView.layer.borderColor = UIColor.systemBlue.cgColor
        } else {
            contentView.layer.borderWidth = 0
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        themeImageView.image = nil
        themeNameLabel.text = nil
        selectedIndicator.isHidden = true
        contentView.layer.borderWidth = 0
    }
} 
