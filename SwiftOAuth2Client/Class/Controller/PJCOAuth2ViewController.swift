//
//  PJCOAuth2ViewController.swift
//  SwiftOAuth2Client
//
//  Created by Peter Spencer on 30/10/2020.
//

import UIKit


class PJCOAuth2ViewController: UIViewController
{
    // MARK: - Managing the View
    
    override func loadView()
    { self.view = PJCOAuth2View(frame: UIScreen.main.bounds) }
    
    
    // MARK: - Responding to View Events
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.threeLeggedExample()
        // self.twoLeggedExample()
    }
}

extension PJCOAuth2ViewController
{
    func threeLeggedExample()
    { self.authorizeGoogleAPIs() }
    
    func twoLeggedExample()
    {
        let credentials = UIApplication.shared.clientCredentials
        self.exchange(grant: .clientCredentials(credentials: credentials),
                      with: TwitterOAuth2())
    }
}

extension PJCOAuth2ViewController
{
    // MARK: - Authorizing
    
    func authorizeGoogleAPIs()
    {
        let credentials = UIApplication.shared.authorizationCredentials
        let scopes = UIApplication.shared.scopes
        let parameters = OAuth2ConsentParameters(credentials,
                                                 scopes: scopes)
        
        OAuth2ConsentService.shared.host = GoogleAccounts()
        OAuth2ConsentService.shared.authorize(parameters: parameters,
                                              completion: self.exchange)
    }
    
    
    // MARK: - Exchanging
    
    func exchange(_ result: Result<OAuth2GrantType, Error>)
    {
        guard let grant: OAuth2GrantType = try? result.get() else
        { return }
        
        self.exchange(grant: grant,
                      with: GoogleOAuth2())
    }
    
    func exchange(grant: OAuth2GrantType,
                  with host: OAuth2Host)
    {
        OAuth2TokenService.shared.host = host
        OAuth2TokenService.shared.exchange(grant: grant,
                                           completion: self.log)
    }
    
    func log(_ result: Result<OAuth2TokenResponse, Error>)
    {
        switch result
        {
        case .success(let response): print("Access token: \(response.accessToken)")
        case .failure(let error): print("There was a error: \(error)")
        }
    }
}

