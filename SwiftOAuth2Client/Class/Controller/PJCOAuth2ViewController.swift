//
//  PJCOAuth2ViewController.swift
//  SwiftOAuth2Client
//
//  Created by Peter Spencer on 30/10/2020.
//

import UIKit


class PJCOAuth2ViewController: UIViewController
{
    // MARK: - Property(s)
    
    var consentService: OAuth2ConsentServiceDelegate?
    
    var tokenService: OAuth2TokenServiceDelegate?
    
    
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
    { self.authorize() }
    
    func twoLeggedExample()
    {
        let credentials = UIApplication.shared.clientCredentials
        self.exchange(grant: .clientCredentials(credentials))
    }
}

extension PJCOAuth2ViewController
{
    // MARK: - Authorizing
    
    func authorize()
    {
        guard let verifier = PJCCodeVerifier() else
        { return }
        
        let credentials = UIApplication.shared.authorizationCredentials
        let scopes = UIApplication.shared.scopes
        let parameters = OAuth2ConsentParameters(credentials,
                                                 verifier: verifier,
                                                 scopes: scopes)
        
        self.consentService?.authorize(parameters: parameters,
                                       completion: self.exchange)
    }
    
    
    // MARK: - Exchanging
    
    func exchange(_ result: Result<OAuth2GrantType, Error>)
    {
        guard let grant: OAuth2GrantType = try? result.get() else
        { return }
        
        self.exchange(grant: grant)
    }
    
    func exchange(grant: OAuth2GrantType)
    {
        self.tokenService?.exchange(grant: grant)
        { (result) in self.log(result) }
    }
    
    func log(_ result: Result<OAuth2TokenResponse, Error>)
    {
        switch result
        {
        case .success(let response):
            print("Access token: \(response.accessToken)")
            
            if response.refreshToken != nil
            {
                print("\nAttempting to exchange refresh token")
                
                let credentials = UIApplication.shared.authorizationCredentials
                let parameters = OAuth2RefreshParameters(credentials: credentials,
                                                         response: response)
                
                self.exchange(grant: .refreshToken(parameters))
            }
            
        case .failure(let error): print("There was a error: \(error)")
        }
    }
}

