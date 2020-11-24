//
//  PJCOAuth2Controller.swift
//  SwiftOAuth2Client
//
//  Created by Peter Spencer on 18/11/2020.
//

import Foundation


typealias OAuth2ControllerResult = Result<OAuth2Token, Error>

typealias OAuth2ControllerResponseHandler = (OAuth2ControllerResult) -> Void

final class OAuth2Controller
{
    // MARK: - Accessing the Shared Instance
    
    static let shared: OAuth2Controller = OAuth2Controller()
    
    
    // MARK: - Property(s)
    
    var consentService: OAuth2ConsentServiceDelegate = OAuth2ConsentService.shared
    
    var tokenService: OAuth2TokenServiceDelegate = OAuth2TokenService.shared
    
    var automaticallyRefreshAccessToken: Bool = false
    
    var completion: OAuth2ControllerResponseHandler?
    
    
    // MARK: - Initialisation
    
    private init() {}
}

extension OAuth2Controller
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
                if self.automaticallyRefreshAccessToken,
                   let parameters: OAuth2AuthorizationParameters = grant.get(),
                   let credentials = parameters.credentials as OAuth2AuthorizationCredentials?,
                   let token = response.refreshToken
                {
                    let parameters = OAuth2RefreshParameters(credentials,
                                                             token: token)
                    self.exchange(grant: .refreshToken(parameters))
                }
                else
                {
                    response.saveToKeychain()
                    self.completion?(.success(response.accessToken))
                }
                
            case .failure(_):
                self.completion?(.failure(OAuth2Error.failed))
            }
        }
    }
    
    
    // MARK: - Refreshing an Access Token
    
    func refresh(parameters: OAuth2RefreshParameters)
    { self.exchange(grant: .refreshToken(parameters)) }
}

