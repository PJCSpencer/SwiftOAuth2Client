//
//  PJCOAuth2ConsentService.swift
//  SwiftOAuth2Client
//
//  Created by Peter Spencer on 30/10/2020.
//

import Foundation
import AuthenticationServices


typealias OAuth2ConsentServiceResult = Result<OAuth2GrantType, Error>

typealias OAuth2ConsentServiceResponseHandler = (OAuth2ConsentServiceResult) -> Void

protocol OAuth2ConsentServiceDelegate
{
    func authorize(parameters: OAuth2ConsentParameters,
                   completion: @escaping OAuth2ConsentServiceResponseHandler)
}

final class OAuth2ConsentService: NSObject
{
    // MARK: - Accessing the Shared Instance
    
    static let shared: OAuth2ConsentService = OAuth2ConsentService()
    
    
    // MARK: - Property(s)
    
    var host: OAuth2Host?
    
    fileprivate var parameters: OAuth2ConsentParameters!
    
    fileprivate var completionHandler: OAuth2ConsentServiceResponseHandler!
    
    fileprivate var session: ASWebAuthenticationSession?
    {
        didSet
        {
            oldValue?.cancel()
            
            session?.presentationContextProvider = self
            session?.start()
        }
    }
}

// MARK: - PJCAthletesAPIRequestDelegate
extension OAuth2ConsentService: OAuth2ConsentServiceDelegate
{
    func authorize(parameters: OAuth2ConsentParameters,
                   completion: @escaping OAuth2ConsentServiceResponseHandler)
    {
        guard let host = self.host else
        {
            completion(.failure(PJCDataServiceError.noHost))
            return
        }
        
        let apiRequest = PJCAPIRequest(path: host.oauth2Path.auth,
                                       queryItems: parameters.queryItems)
        
        guard let url = apiRequest.urlRequest()?.url else
        {
            completion(.failure(PJCDataServiceError.badRequest))
            return
        }
        
        self.parameters = parameters
        self.completionHandler = completion
        self.session = ASWebAuthenticationSession(url: url,
                                                  callbackURLScheme: parameters.credentials.redirectUri,
                                                  completionHandler: self.refresh)
    }
    
    fileprivate func refresh(url: URL?,
                             error: Error?)
    {
        guard let consent = OAuth2AuthorizationConsent(url: url) else
        {
            self.completionHandler(.failure(OAuth2Error.noConsent))
            return
        }
        
        let authorization = OAuth2AuthorizationParameters(self.parameters.credentials,
                                                          verifier: self.parameters.verifier,
                                                          consent: consent)
        
        self.completionHandler(.success(.authorizationCode(authorization)))
    }
}

// MARK: - ASWebAuthenticationPresentationContextProviding
extension OAuth2ConsentService: ASWebAuthenticationPresentationContextProviding
{
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor
    { return UIApplication.shared.windows.first ?? ASPresentationAnchor() }
}

