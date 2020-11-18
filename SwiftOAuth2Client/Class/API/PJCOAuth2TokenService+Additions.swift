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

struct OAuth2AuthorizationState
{
    // MARK: - Property(s)
    
    let value: String
    
    
    // MARK: - Initialisation
    
    init?(url: URL?)
    {
        guard let url = url,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let items = components.queryItems?.filter({ $0.name == OAuth2AuthorizationKey.state.rawValue }),
              let value = items.first?.value else
        { return nil }
        
        self.value = value
    }
}

extension OAuth2AuthorizationState: Equatable
{
    static func == (lhs: OAuth2AuthorizationState,
                    rhs: OAuth2AuthorizationState) -> Bool
    { return lhs.value == rhs.value }
}

struct OAuth2TokenResponse: Codable
{
    // MARK: - Constant(s)
    
    enum CodingKeys: String, CodingKey
    {
        case accessToken    = "access_token"
        case expiresIn      = "expires_in"
        case refreshToken   = "refresh_token"
        case scope
        case tokenType      = "token_type"
    }
    
    
    // MARK: - Property(s)
    
    let accessToken: OAuth2Token
    
    let tokenType: OAuth2TokenType
    
    let expiresIn: Int?
    
    let refreshToken: OAuth2Token?
    
    let scope: String?
    
    
    // MARK: - Decodable Initialisation
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        guard let accessToken = try? container.decode(String.self, forKey: Self.CodingKeys.accessToken) else
        { throw DecodingError.dataCorruptedError(forKey: Self.CodingKeys.accessToken,
                                                 in: container,
                                                 debugDescription: "Failed to parse token.") }
        
        self.accessToken = OAuth2Token(.access,
                                       value: accessToken)
        
        self.tokenType = try container.decode(OAuth2TokenType.self, forKey: Self.CodingKeys.tokenType)
        self.expiresIn = try? container.decodeIfPresent(Int.self, forKey: Self.CodingKeys.expiresIn)
        
        if let refreshToken = try? container.decode(String.self, forKey: Self.CodingKeys.refreshToken)
        {
            self.refreshToken = OAuth2Token(.refresh,
                                            value: refreshToken)
        }
        else { self.refreshToken = nil }
        
        self.scope = try? container.decodeIfPresent(String.self, forKey: Self.CodingKeys.scope)
    }
}

struct OAuth2RefreshParameters
{
    // MARK: - Property(s)
    
    let credentials: OAuth2AuthorizationCredentials
    
    let token: OAuth2Token
    
    
    // MARK:  - Initialisation
    
    init(_ credentials: OAuth2AuthorizationCredentials,
         token: OAuth2Token)
    {
        self.credentials = credentials
        self.token = token
    }
}

extension OAuth2RefreshParameters: PJCQueryProvider
{
    var queryItems: [URLQueryItem]
    {
        var buffer = self.token.queryItems
        buffer += self.credentials.queryItems.filter({ $0.name != OAuth2Key.redirectUri.rawValue })
        
        return buffer
    }
}

