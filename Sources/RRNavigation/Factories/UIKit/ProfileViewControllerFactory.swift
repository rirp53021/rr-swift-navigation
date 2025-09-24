// MARK: - Profile View Controller Factory

import Foundation

#if canImport(UIKit)
import UIKit

public struct ProfileViewControllerFactory: UIKitViewControllerFactory {
    public typealias Output = UIViewController
    
    public init() {}
    
    public func present(_ component: UIViewController, with context: RouteContext) {
        print("📱 ProfileViewControllerFactory: Creating ProfileViewController")
    }
    
    public func presentViewController(_ viewController: UIViewController, with context: RouteContext) {
        present(viewController, with: context)
    }
    
    public func createViewController(with context: RouteContext) -> UIViewController {
        let userId = context.parameters.data["userId"] ?? "unknown"
        let userName = context.parameters.data["userName"] ?? "Unknown User"
        
        return ProfileViewController(userId: userId, userName: userName)
    }
}

// Demo ProfileViewController
public class ProfileViewController: UIViewController {
    let userId: String
    let userName: String
    
    public init(userId: String, userName: String) {
        self.userId = userId
        self.userName = userName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Profile"
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Profile Image
        let profileImageView = UIView()
        profileImageView.backgroundColor = .systemBlue
        profileImageView.layer.cornerRadius = 50
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let initialsLabel = UILabel()
        initialsLabel.text = String(userName.prefix(2)).uppercased()
        initialsLabel.font = .systemFont(ofSize: 24, weight: .bold)
        initialsLabel.textColor = .white
        initialsLabel.textAlignment = .center
        initialsLabel.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.addSubview(initialsLabel)
        
        // Name Label
        let nameLabel = UILabel()
        nameLabel.text = userName
        nameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // User ID Label
        let userIdLabel = UILabel()
        userIdLabel.text = "ID: \(userId)"
        userIdLabel.font = .systemFont(ofSize: 16)
        userIdLabel.textColor = .secondaryLabel
        userIdLabel.textAlignment = .center
        userIdLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Info Container
        let infoContainer = UIView()
        infoContainer.backgroundColor = .systemGray6
        infoContainer.layer.cornerRadius = 12
        infoContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let infoStackView = UIStackView()
        infoStackView.axis = .vertical
        infoStackView.spacing = 16
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        infoContainer.addSubview(infoStackView)
        
        // Info Rows
        let nameRow = createInfoRow(icon: "person.fill", title: "Name", value: userName)
        let idRow = createInfoRow(icon: "number", title: "User ID", value: userId)
        let joinedRow = createInfoRow(icon: "calendar", title: "Joined", value: "January 2024")
        let typeRow = createInfoRow(icon: "star.fill", title: "Type", value: "Premium")
        
        infoStackView.addArrangedSubview(nameRow)
        infoStackView.addArrangedSubview(idRow)
        infoStackView.addArrangedSubview(joinedRow)
        infoStackView.addArrangedSubview(typeRow)
        
        // Add all views to content view
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(userIdLabel)
        contentView.addSubview(infoContainer)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Profile Image
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            // Initials
            initialsLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
            initialsLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            
            // Name
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // User ID
            userIdLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            userIdLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            userIdLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Info Container
            infoContainer.topAnchor.constraint(equalTo: userIdLabel.bottomAnchor, constant: 30),
            infoContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            infoContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            infoContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            
            // Info Stack View
            infoStackView.topAnchor.constraint(equalTo: infoContainer.topAnchor, constant: 16),
            infoStackView.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor, constant: 16),
            infoStackView.trailingAnchor.constraint(equalTo: infoContainer.trailingAnchor, constant: -16),
            infoStackView.bottomAnchor.constraint(equalTo: infoContainer.bottomAnchor, constant: -16)
        ])
    }
    
    private func createInfoRow(icon: String, title: String, value: String) -> UIView {
        let container = UIView()
        
        let iconImageView = UIImageView(image: UIImage(systemName: icon))
        iconImageView.tintColor = .systemBlue
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 16)
        valueLabel.textColor = .secondaryLabel
        valueLabel.textAlignment = .right
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(iconImageView)
        container.addSubview(titleLabel)
        container.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            valueLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 12),
            
            container.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        return container
    }
}

#endif


