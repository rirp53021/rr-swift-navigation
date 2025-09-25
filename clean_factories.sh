#!/bin/bash

# Remove view implementations from factory files, keeping only the factory structs

# ProfileViewFactory
sed -i '' '/^\/\/ Demo ProfileView$/,$d' Demo/RRNavigationDemo/Factories/SwiftUI/ProfileViewFactory.swift
echo "// Note: ProfileView is defined in Demo/RRNavigationDemo/SwiftUI/ProfileView.swift" >> Demo/RRNavigationDemo/Factories/SwiftUI/ProfileViewFactory.swift

# SettingsViewFactory  
sed -i '' '/^\/\/ Demo SettingsView$/,$d' Demo/RRNavigationDemo/Factories/SwiftUI/SettingsViewFactory.swift
echo "// Note: SettingsView is defined in Demo/RRNavigationDemo/SwiftUI/SettingsView.swift" >> Demo/RRNavigationDemo/Factories/SwiftUI/SettingsViewFactory.swift

# AboutViewFactory
sed -i '' '/^\/\/ Demo AboutView$/,$d' Demo/RRNavigationDemo/Factories/SwiftUI/AboutViewFactory.swift
echo "// Note: AboutView is defined in Demo/RRNavigationDemo/SwiftUI/AboutView.swift" >> Demo/RRNavigationDemo/Factories/SwiftUI/AboutViewFactory.swift

# ProfileViewControllerFactory
sed -i '' '/^\/\/ Demo ProfileViewController$/,$d' Demo/RRNavigationDemo/Factories/UIKit/ProfileViewControllerFactory.swift
echo "// Note: ProfileViewController is defined in Demo/RRNavigationDemo/UIKit/ProfileViewController.swift" >> Demo/RRNavigationDemo/Factories/UIKit/ProfileViewControllerFactory.swift

# SettingsViewControllerFactory
sed -i '' '/^\/\/ Demo SettingsViewController$/,$d' Demo/RRNavigationDemo/Factories/UIKit/SettingsViewControllerFactory.swift
echo "// Note: SettingsViewController is defined in Demo/RRNavigationDemo/UIKit/SettingsViewController.swift" >> Demo/RRNavigationDemo/Factories/UIKit/SettingsViewControllerFactory.swift

echo "Cleaned factory files - removed duplicate view implementations"

