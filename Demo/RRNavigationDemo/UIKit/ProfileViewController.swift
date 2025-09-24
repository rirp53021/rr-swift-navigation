import UIKit
import RRNavigation

class ProfileViewController: UIViewController {
    private let navigationManager: any NavigationManagerProtocol
    private let userId: String
    private let name: String
    
    // UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let userIdLabel = UILabel()
    private let stackView = UIStackView()
    
    init(userId: String = "unknown", name: String = "Unknown User", navigationManager: any NavigationManagerProtocol) {
        self.userId = userId
        self.name = name
        self.navigationManager = navigationManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Profile"
        
        // Setup navigation bar
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeButtonTapped)
        )
        
        // Setup scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup profile image
        profileImageView.image = UIImage(systemName: "person.circle.fill")
        profileImageView.tintColor = .systemBlue
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup labels
        nameLabel.text = name
        nameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        userIdLabel.text = "User ID: \(userId)"
        userIdLabel.font = .systemFont(ofSize: 16)
        userIdLabel.textColor = .secondaryLabel
        userIdLabel.textAlignment = .center
        userIdLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup stack view
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add buttons
        let editButton = createButton(title: "Edit Profile", color: .systemBlue) { [weak self] in
            self?.editProfileTapped()
        }
        
        let settingsButton = createButton(title: "View Settings", color: .systemGreen) { [weak self] in
            self?.settingsTapped()
        }
        
        let backButton = createButton(title: "Go Back", color: .systemOrange) { [weak self] in
            self?.backTapped()
        }
        
        stackView.addArrangedSubview(editButton)
        stackView.addArrangedSubview(settingsButton)
        stackView.addArrangedSubview(backButton)
        
        // Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(userIdLabel)
        contentView.addSubview(stackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Scroll view
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content view
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Profile image
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            // Name label
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // User ID label
            userIdLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            userIdLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            userIdLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Stack view
            stackView.topAnchor.constraint(equalTo: userIdLabel.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func createButton(title: String, color: UIColor, action: @escaping () -> Void) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = color
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 8
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        button.addAction(UIAction { _ in action() }, for: .touchUpInside)
        
        return button
    }
    
    @objc private func closeButtonTapped() {
        navigationManager.navigateBack()
    }
    
    private func editProfileTapped() {
        navigationManager.navigate(
            to: "settings",
            parameters: RouteParameters(data: ["section": "profile", "userId": userId, "source": "uikit"]),
            in: nil
        )
    }
    
    private func settingsTapped() {
        navigationManager.navigate(
            to: "settingsVC",
            parameters: RouteParameters(data: ["userId": userId, "source": "uikit"]),
            in: nil,
            type: .sheet
        )
    }
    
    private func backTapped() {
        navigationManager.navigateBack()
    }
}
