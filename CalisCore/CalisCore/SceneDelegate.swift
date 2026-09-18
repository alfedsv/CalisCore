//
//  SceneDelegate.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 15.09.2026.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        // Проверяем, нужно ли показать экран согласия
        if ConsentManager.shared.needsConsent {
            window.rootViewController = ConsentViewController()
        } else {
            window.rootViewController = makeMainNavigationController()
        }
        
        window.makeKeyAndVisible()
    }
    
    /// Создаёт основной навигационный стек приложения.
    private func makeMainNavigationController() -> UINavigationController {
        let rootViewController = SetupViewController()
        let navController = UINavigationController(rootViewController: rootViewController)
        return navController
    }
    
    /// Плавный переход с экрана согласия на основной экран приложения.
    func switchToMain() {
        guard let window = window else { return }
        let mainNav = makeMainNavigationController()
        
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
            window.rootViewController = mainNav
        }, completion: nil)
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }


}

