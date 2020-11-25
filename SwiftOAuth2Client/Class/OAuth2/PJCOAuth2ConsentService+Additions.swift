//
//  PJCOAuth2ConsentService+Additions.swift
//  SwiftOAuth2Client
//
//  Created by Peter Spencer on 09/11/2020.
//

import Foundation


struct OAuth2ConsentParameters
{
    // MARK: - Property(s)
    
    let credentials: OAuth2AuthorizationCredentials
    
    let responseType: String = OAuth2AuthorizationKey.code.rawValue
    
    let scopes: String // TODO:Support tiny domain type ..?
    
    let verifier: PJCCodeVerifier
    
    let state: String? = nil
    
    
    // MARK: - Initailisation
    
    init?(_ credentials: OAuth2AuthorizationCredentials,
          scopes: [String])
    {
        guard let verifier = PJCCodeVerifier() else
        { return nil }
        
        self.credentials = credentials
        self.verifier = verifier
        self.scopes = String(scopes.map({ $0 + " " }).reduce("", +).dropLast())
    }
}

extension OAuth2ConsentParameters: PJCQueryProvider
{
    var queryItems: [URLQueryItem]
    {
        var buffer: [URLQueryItem] = []
        buffer.append(URLQueryItem(name: OAuth2Key.responseType.rawValue, value: self.responseType))
        buffer.append(URLQueryItem(name: OAuth2Key.scope.rawValue, value: self.scopes))
        
        return self.credentials.queryItems + self.verifier.queryItems + buffer
    }
}

struct OAuth2AuthorizationConsent
{
    // MARK: - Property(s)
    
    let code: OAuth2AuthorizationCode
    
    let state: OAuth2AuthorizationState?
    
    
    // MARK: - Initialisation
    
    init?(url: URL?)
    {
        guard let code = OAuth2AuthorizationCode(url: url) else
        { return nil }
         
        self.code = code
        self.state = OAuth2AuthorizationState(url: url)
    }
}

extension OAuth2AuthorizationConsent: PJCQueryProvider
{
    var queryItems: [URLQueryItem]
    { return self.code.queryItems }
}

