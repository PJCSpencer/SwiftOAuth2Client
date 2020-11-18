//
//  PJCOAuth2Controller.swift
//  SwiftOAuth2Client
//
//  Created by Peter Spencer on 18/11/2020.
//

import Foundation


class PJCOAuth2Controller
{
    // MARK: - Accessing the Shared Instance
    
    static let shared: PJCOAuth2Controller = PJCOAuth2Controller()
    
    
    // MARK: - Property(s)
    
    var consentService: OAuth2ConsentServiceDelegate = OAuth2ConsentService.shared
    
    var tokenService: OAuth2TokenServiceDelegate = OAuth2TokenService.shared
    
    var automaticallyRefreshAccessToken: Bool = true
    
    var completion: OAuth2TokenServiceResponseHandler?
    
    fileprivate var credentials: OAuth2AuthorizationCredentials? // TODO:Remove ...
    
    
    // MARK: - Initialisation
    
    private init() {}
}

extension PJCOAuth2Controller
{
    // MARK: - Authorizing Consent Parameters
    
    func authorize(parameters: OAuth2ConsentParameters)
    {
        self.credentials = parameters.credentials
        self.consentService.authorize(parameters: parameters,
                                      completion: self.exchange)
    }
    
    
    // MARK: - Exchanging a Grant
    
    fileprivate func exchange(_ result: Result<OAuth2GrantType, Error>)
    {
        switch result
        {
        case .success(let grant): self.exchange(grant: grant)
        case .failure(let error): self.completion?(.failure(error))
        }
    }
    
    func exchange(grant: OAuth2GrantType)
    {
        // TODO:Support automaticallyRefreshAccessToken ...
        
        self.tokenService.exchange(grant: grant,
                                   completion: self.completion ?? self.log)
    }
    
    
    // MARK: -
    
    func refresh(parameters: OAuth2RefreshParameters) { /* TODO: */ }
}

extension PJCOAuth2Controller
{
    fileprivate func log(_ result: Result<OAuth2TokenResponse, Error>)
    {
        switch result
        {
        case .success(let response):
            print("Access token: \(response.accessToken)")
            
            if self.automaticallyRefreshAccessToken,
               let credentials = self.credentials,
               let token = response.refreshToken
            {
                print("\nAttempting to exchange refresh token")
                
                let parameters = OAuth2RefreshParameters(credentials,
                                                         token: token)
                
                // Avoid looping.
                self.credentials = nil
                self.exchange(grant: .refreshToken(parameters))
            }
            
        case .failure(let error): print("There was a error: \(error)")
        }
    }
}

