//
//  PJCOAuth2TokenService+Additions.swift
//  SwiftOAuth2Client
//
//  Created by Peter Spencer on 09/11/2020.
//

import Foundation


struct OAuth2AuthorizationParameters
{
    // MARK: - Property(s)
    
    let credentials: OAuth2AuthorizationCredentials
    
    let verifier: PJCCodeVerifier
    
    let consent: OAuth2AuthorizationConsent
    
    
    // MARK: - Initailisation
    
    init(_ credentials: OAuth2AuthorizationCredentials,
         verifier: PJCCodeVerifier,
         consent: OAuth2AuthorizationConsent)
    {
        self.credentials = credentials
        self.verifier = verifier
        self.consent = consent
    }
}

extension OAuth2AuthorizationParameters: PJCQueryProvider
{
    var queryItems: [URLQueryItem]
    {
        var buffer: [URLQueryItem] = []
        buffer.append(URLQueryItem(name: OAuth2AuthorizationKey.codeVerifier.rawValue,
                                   value: self.verifier.percentEncodedValue))
        
        return buffer + self.credentials.queryItems + self.consent.queryItems
    }
}

struct OAuth2AuthorizationCode
{
    // MARK: - Property(s)
    
    let value: String
    
    
    // MARK: - Initialisation
    
    init?(url: URL?)
    {
        guard let url = url,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let items = components.queryItems?.filter({ $0.name == OAuth2AuthorizationKey.code.rawValue }),
              let code = items.first?.value else
        { return nil }
        
        self.value = code
    }
}

extension OAuth2AuthorizationCode: PJCQueryProvider
{
    var queryItems: [URLQueryItem]
    {
        var buffer: [URLQueryItem] = []
        buffer.append(URLQueryItem(name: OAuth2AuthorizationKey.code.rawValue,
                                   value: self.value))
        
        return buffer
    }
}

struct OAuth2TokenResponse: Codable
{
    // MARK: - Constant(s)
    
    enum CodingKeys: String, CodingKey
    {
        case accessToken    = "access_token"
        case expiresIn      = "expires_in"
        case idToken        = "id_token"
        case refreshToken   = "refresh_token"
        case scope
        case tokenType      = "token_type"
    }
    
    
    // MARK: - Property(s)
    
    let accessToken: String
    
    let tokenType: OAuth2TokenType
    
    let expiresIn: Int?
    
    let idToken: String? // GoogleAPIs.
    
    let refreshToken: String?
    
    let scope: String?
}

