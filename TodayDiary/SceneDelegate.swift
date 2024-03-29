//
//  SceneDelegate.swift
//  RxDiary
//
//  Created by Jae kwon Choi on 2022/12/10.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene as! UIWindowScene)
        window?.makeKeyAndVisible()
        
        let rootViewController = MainViewController()
        
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        let appearance = UINavigationBarAppearance()
        let navigationBar = UINavigationBar()
        appearance.configureWithOpaqueBackground()
        appearance.configureWithTransparentBackground()
        navigationBar.standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        
        
        self.window?.rootViewController = navigationController
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    // 액티브 상태가 됐을 경우
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    // app switcher 모드
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    // 백그라운드 상태였다가 돌아왔을 경우
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
//        NotificationCenter.default.post(name: NSNotification.Name("reload"), object: nil)
    }

    // 백그라운드 상태로 갔을경우
    func sceneDidEnterBackground(_ scene: UIScene) {
        exit(0)
    }
}

