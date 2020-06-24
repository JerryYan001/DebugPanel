//
//  SceneDelegate.swift
//  DebugPanel
//
//  Created by xaoxuu on 2020/6/19.
//  Copyright © 2020 xaoxuu. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        DebugPanel.load { (panel) in
            panel.titleLabel.text = "调试窗口"
            panel.width = 150
            
            panel.add("按钮1") { (sender) in
                print("点击了按钮1")
                DebugPanel.update(button: 0, title: "按钮1+")
            }
            panel.add("按钮2") { (sender) in
                print("点击了按钮2")
                DebugPanel.update(button: 1, title: "按钮2+")
            }
            panel.add("按钮3") { (sender) in
                print("点击了按钮3")
                DebugPanel.update(button: 2, title: "按钮3+")
            }
            panel.add("不可用的按钮")
            panel.add("隐藏") { (sender) in
                panel.isHidden = true
            }
        }
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
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
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

