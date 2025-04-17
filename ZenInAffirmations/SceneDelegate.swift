//
//  SceneDelegate.swift
//  ZenInAffirmations
//
//  Created by Tao Dong on 2025/4/10.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var musicPlayerWindow: MusicPlayerWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // 创建主窗口
        window = UIWindow(windowScene: windowScene)
        
        // 设置根视图控制器为TabBarController
        let mainTabBarController = MainTabBarController()
        
        // 设置导航栏外观
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.titleTextAttributes = [.foregroundColor: UIColor.darkGray]
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        
        window?.rootViewController = mainTabBarController
        window?.makeKeyAndVisible()
        
        // 创建音乐播放器窗口
        setupMusicPlayerWindow(in: windowScene)
        
        // Print debug information at app startup
        print("=== APP STARTED ===")
        let favoriteManager = FavoriteManager.shared
        favoriteManager.printStoredData()
        
        // Force cleanup if needed for troubleshooting
        // Uncomment this line to force clean legacy IDs:
        // favoriteManager.forceCleanupLegacyIDs()
    }
    
    // 设置音乐播放器窗口
    private func setupMusicPlayerWindow(in scene: UIWindowScene) {
        // 创建新的音乐播放器窗口
        musicPlayerWindow = MusicPlayerWindow(windowScene: scene)
        musicPlayerWindow?.isHidden = false
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        
        // 确保音乐播放器窗口显示
        musicPlayerWindow?.isHidden = false
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

