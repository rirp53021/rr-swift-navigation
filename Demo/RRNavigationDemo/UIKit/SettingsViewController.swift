import UIKit
import RRNavigation

class SettingsViewController: UIViewController {
    private let navigationManager: any NavigationManagerProtocol
    private let userId: String
    
    // UI Elements
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var settingsData: [SettingsSection] = []
    
    init(userId: String = "unknown", navigationManager: any NavigationManagerProtocol) {
        self.userId = userId
        self.navigationManager = navigationManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        title = "Settings"
        
        // Setup navigation bar
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeButtonTapped)
        )
        
        // Setup table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupData() {
        settingsData = [
            SettingsSection(
                title: "Profile",
                items: [
                    SettingsItem(title: "User ID", detail: userId, icon: "person.circle"),
                    SettingsItem(title: "Edit Profile", icon: "pencil.circle", action: editProfile),
                    SettingsItem(title: "View Profile", icon: "person.circle.fill", action: viewProfile)
                ]
            ),
            SettingsSection(
                title: "Appearance",
                items: [
                    SettingsItem(title: "Theme", detail: "Light", icon: "paintbrush"),
                    SettingsItem(title: "Font Size", detail: "Medium", icon: "textformat.size")
                ]
            ),
            SettingsSection(
                title: "Navigation",
                items: [
                    SettingsItem(title: "Framework", detail: "UIKit", icon: "iphone"),
                    SettingsItem(title: "Navigation", detail: "RRNavigation", icon: "arrow.right.circle"),
                    SettingsItem(title: "Source", detail: "UIKit Demo", icon: "swift")
                ]
            ),
            SettingsSection(
                title: "Actions",
                items: [
                    SettingsItem(title: "Go Back", icon: "arrow.left.circle", action: goBack),
                    SettingsItem(title: "Go to Home", icon: "house.circle", action: goHome),
                    SettingsItem(title: "Reset Navigation", icon: "arrow.clockwise.circle", action: resetNavigation)
                ]
            )
        ]
    }
    
    @objc private func closeButtonTapped() {
        navigationManager.navigateBack()
    }
    
    private func editProfile() {
        navigationManager.navigate(
            to: RouteID.profile,
            parameters: RouteParameters(data: ["userId": userId, "edit": "true", "source": "uikit"]),
            in: nil
        )
    }
    
    private func viewProfile() {
        navigationManager.navigate(
            to: RouteID.profileVC,
            parameters: RouteParameters(data: ["userId": userId, "source": "uikit"]),
            in: nil
        )
    }
    
    private func goBack() {
        navigationManager.navigateBack()
    }
    
    private func goHome() {
        navigationManager.navigate(
            to: RouteID.home,
            parameters: RouteParameters(),
            in: nil
        )
    }
    
    private func resetNavigation() {
        navigationManager.navigateToRoot(in: nil)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsData[section].items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingsData[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = settingsData[indexPath.section].items[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.detail
        cell.imageView?.image = UIImage(systemName: item.icon)
        cell.imageView?.tintColor = .systemBlue
        
        if item.action != nil {
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = settingsData[indexPath.section].items[indexPath.row]
        item.action?()
    }
}

// MARK: - Data Models

struct SettingsSection {
    let title: String
    let items: [SettingsItem]
}

struct SettingsItem {
    let title: String
    let detail: String?
    let icon: String
    let action: (() -> Void)?
    
    init(title: String, detail: String? = nil, icon: String, action: (() -> Void)? = nil) {
        self.title = title
        self.detail = detail
        self.icon = icon
        self.action = action
    }
}
