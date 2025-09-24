// MARK: - Settings View Controller Factory

import Foundation

#if canImport(UIKit)
import UIKit

public struct SettingsViewControllerFactory: UIKitViewControllerFactory {
    public typealias Output = UIViewController
    
    public init() {}
    
    public func present(_ component: UIViewController, with context: RouteContext) {
        print("📱 SettingsViewControllerFactory: Creating SettingsViewController")
    }
    
    public func presentViewController(_ viewController: UIViewController, with context: RouteContext) {
        present(viewController, with: context)
    }
    
    public func createViewController(with context: RouteContext) -> UIViewController {
        let theme = context.parameters.data["theme"] ?? "light"
        let notifications = context.parameters.data["notifications"] == "true"
        
        return SettingsViewController(theme: theme, notifications: notifications)
    }
}

// Demo SettingsViewController
public class SettingsViewController: UIViewController {
    let theme: String
    let notifications: Bool
    
    private var tableView: UITableView!
    private var darkModeSwitch: UISwitch!
    private var notificationsSwitch: UISwitch!
    
    public init(theme: String, notifications: Bool) {
        self.theme = theme
        self.notifications = notifications
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
        navigationItem.title = "Settings"
        
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // Create switches
        darkModeSwitch = UISwitch()
        darkModeSwitch.isOn = theme == "dark"
        darkModeSwitch.addTarget(self, action: #selector(darkModeSwitchChanged), for: .valueChanged)
        
        notificationsSwitch = UISwitch()
        notificationsSwitch.isOn = notifications
        notificationsSwitch.addTarget(self, action: #selector(notificationsSwitchChanged), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func darkModeSwitchChanged() {
        print("Dark mode switched to: \(darkModeSwitch.isOn)")
    }
    
    @objc private func notificationsSwitchChanged() {
        print("Notifications switched to: \(notificationsSwitch.isOn)")
        tableView.reloadSections(IndexSet(integer: 1), with: .none)
    }
}

// MARK: - TableView DataSource & Delegate
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2 // Appearance
        case 1: return notificationsSwitch.isOn ? 2 : 1 // Notifications
        case 2: return 2 // General
        case 3: return 2 // Support
        default: return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Appearance"
        case 1: return "Notifications"
        case 2: return "General"
        case 3: return "Support"
        default: return nil
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        
        switch indexPath.section {
        case 0: // Appearance
            if indexPath.row == 0 {
                cell.imageView?.image = UIImage(systemName: "paintbrush.fill")
                cell.imageView?.tintColor = .systemBlue
                cell.textLabel?.text = "Theme"
                cell.detailTextLabel?.text = theme.capitalized
                cell.accessoryType = .disclosureIndicator
            } else {
                cell.imageView?.image = UIImage(systemName: darkModeSwitch.isOn ? "moon.fill" : "sun.max.fill")
                cell.imageView?.tintColor = darkModeSwitch.isOn ? .systemPurple : .systemOrange
                cell.textLabel?.text = "Dark Mode"
                cell.accessoryView = darkModeSwitch
                cell.selectionStyle = .none
            }
            
        case 1: // Notifications
            if indexPath.row == 0 {
                cell.imageView?.image = UIImage(systemName: "bell.fill")
                cell.imageView?.tintColor = .systemRed
                cell.textLabel?.text = "Push Notifications"
                cell.accessoryView = notificationsSwitch
                cell.selectionStyle = .none
            } else {
                cell.imageView?.image = UIImage(systemName: "speaker.wave.2.fill")
                cell.imageView?.tintColor = .systemGreen
                cell.textLabel?.text = "Sound"
                cell.detailTextLabel?.text = "Default"
                cell.accessoryType = .disclosureIndicator
            }
            
        case 2: // General
            if indexPath.row == 0 {
                cell.imageView?.image = UIImage(systemName: "globe")
                cell.imageView?.tintColor = .systemBlue
                cell.textLabel?.text = "Language"
                cell.detailTextLabel?.text = "English"
                cell.accessoryType = .disclosureIndicator
            } else {
                cell.imageView?.image = UIImage(systemName: "info.circle.fill")
                cell.imageView?.tintColor = .systemGray
                cell.textLabel?.text = "Version"
                cell.detailTextLabel?.text = "1.0.0"
                cell.selectionStyle = .none
            }
            
        case 3: // Support
            if indexPath.row == 0 {
                cell.imageView?.image = UIImage(systemName: "questionmark.circle.fill")
                cell.imageView?.tintColor = .systemOrange
                cell.textLabel?.text = "Help & Support"
                cell.accessoryType = .disclosureIndicator
            } else {
                cell.imageView?.image = UIImage(systemName: "envelope.fill")
                cell.imageView?.tintColor = .systemBlue
                cell.textLabel?.text = "Contact Us"
                cell.accessoryType = .disclosureIndicator
            }
            
        default:
            break
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Handle row selection
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                print("Theme selection tapped")
            }
        case 1:
            if indexPath.row == 1 && notificationsSwitch.isOn {
                print("Sound selection tapped")
            }
        case 2:
            if indexPath.row == 0 {
                print("Language selection tapped")
            }
        case 3:
            if indexPath.row == 0 {
                print("Help & Support tapped")
            } else {
                print("Contact Us tapped")
            }
        default:
            break
        }
    }
}

#endif


