// Copyright © 2024 Flipp. All rights reserved.

import dvm_sdk
import UIKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  // This is the key that will be used to initialize the SDK, please replace the value with the key provided by Flipp.
  private let SDKKey = "super-duper-secret-flipp-client-testing-integration-key-abc123"

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    if SDKKey.isEmpty {
      fatalError("The SDK Key has not been set")
    }
    DVMSDK.initialize(clientToken: SDKKey, userId: nil)
    let navBarAppearance = UINavigationBarAppearance()
    navBarAppearance.configureWithOpaqueBackground()
    navBarAppearance.backgroundColor = .appBackground
    UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    UINavigationBar.appearance().backgroundColor = .appBackground
    UINavigationBar.appearance().tintColor = .default5

    return true
  }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }
}

