//
//  PJCSceneDelegate.swift
//  SwiftOAuth2Client
//
//  Created by Peter Spencer on 30/10/2020.
//

import UIKit


class PJCSceneDelegate: UIResponder, UIWindowSceneDelegate
{
    // MARK: - Property(s)
    
    var window: UIWindow?


    // MARK: - Connecting and Disconnecting the Scene
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions)
    {
        guard let windowScene = (scene as? UIWindowScene) else
        { return }

        OAuth2ConsentService.shared.host = PJCEnvironment.current.authHost
        OAuth2TokenService.shared.host = PJCEnvironment.current.tokenHost ?? PJCEnvironment.current.authHost
        
        let controller = PJCOAuth2ViewController()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.windowScene = windowScene
        self.window?.rootViewController = controller
        self.window?.makeKeyAndVisible()
    }
}

