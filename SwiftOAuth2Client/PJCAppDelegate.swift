//
//  PJCAppDelegate.swift
//  SwiftOAuth2Client
//
//  Created by Peter Spencer on 30/10/2020.
//

import UIKit


@main
class PJCAppDelegate: UIResponder, UIApplicationDelegate
{
    // MARK: - UIApplicationDelegate

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    { return true }

    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration
    {
        return UISceneConfiguration(name: "Default Configuration",
                                    sessionRole: connectingSceneSession.role)
    }
}

// MARK: - Utility
extension UIApplication
{
    var rootViewController: UIViewController?
    {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else
        { return nil }
        
        return window.rootViewController
    }
}

extension UIApplication
{
    var clientCredentials: OAuth2ClientCredentials
    {
        return OAuth2ClientCredentials(apiKey: "<paste api key here>",
                                       apiSecretKey: "<paste api secret key here>")
    }
    
    var authorizationCredentials: OAuth2AuthorizationCredentials
    {
        return OAuth2AuthorizationCredentials("1022352150242-i40f7j75nujm0ovr2hod7t9ohubjp12p.apps.googleusercontent.com",
                                              redirectUri: "com.googleusercontent.apps.1022352150242-i40f7j75nujm0ovr2hod7t9ohubjp12p:")
    }
    
    var scopes: [String]
    {
        return ["https://www.googleapis.com/auth/gmail.labels"]
    }
}

