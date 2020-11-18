//
//  PJCOAuth2Controller.swift
//  SwiftOAuth2Client
//
//  Created by Peter Spencer on 18/11/2020.
//

import Foundation


final class PJCOAuth2Controller
{
    // MARK: - Accessing the Shared Instance
    
    static let shared: PJCOAuth2Controller = PJCOAuth2Controller()
    
    
    // MARK: - Property(s)
    
    var consentService: OAuth2ConsentServiceDelegate = OAuth2ConsentService.shared
    
    var tokenService: OAuth2TokenServiceDelegate = OAuth2TokenService.shared
    
    var automaticallyRefreshAccessToken: Bool = true
    
    var completion: OAuth2TokenServiceResponseHandler?
    
    
    // MARK: - Initialisation
    
    private init() {}
}

extension PJCOAuth2Controller
{
    // MARK: - Authorizing Consent Parameters
    
    func authorize(parameters: OAuth2ConsentParameters)
    {
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
        self.tokenService.exchange(grant: grant)
        { (result) in
            
            switch result
            {
            case .success(let response):
                print("Access token: \(response.accessToken)")
                
                if self.automaticallyRefreshAccessToken,
                   let parameters: OAuth2AuthorizationParameters = grant.get(),
                   let credentials = parameters.credentials as OAuth2AuthorizationCredentials?,
                   let token = response.refreshToken
                {
                    print("\nAttempting to exchange refresh token")
                    let parameters = OAuth2RefreshParameters(credentials,
                                                             token: token)
                    self.exchange(grant: .refreshToken(parameters))
                }
                else
                { self.completion?(.success(response)) }
                
            case .failure(let error):
                print("There was a error: \(error)")
                self.completion?(.failure(OAuth2Error.failed))
            }
        }
    }
    
    
    // MARK: - Refreshing an Access Token
    
    func refresh(parameters: OAuth2RefreshParameters)
    { self.exchange(grant: .refreshToken(parameters)) }
}

