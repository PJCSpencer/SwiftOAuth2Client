//
//  PJCOAuth2Service.swift
//  SwiftOAuth2Client
//
//  Created by Peter Spencer on 30/10/2020.
//

import Foundation


typealias OAuth2Host = HTTPHost & OAuth2PathProvider

protocol OAuth2BasePath // TODO:Extend ...
{
    var auth: String { get }
    
    var token: String { get }
}

extension OAuth2BasePath
{
    var auth: String { return "/auth" }
    
    var token: String { return "/token" }
}

protocol OAuth2PathProvider // NB:I like this pattern.
{
    var oauth2Path: OAuth2BasePath { get }
}

enum OAuth2Error: Error
{
    case failed
    case invalidParameters
    case invalidURL
    case invalidSigningKey
    case invalidSignature
    case invalidRequest
    case noConsent
    case unkown
}

enum OAuth2Key: String
{
    case apiKey
    case apiSecretKey
    
    case clientId               = "client_id"
    case redirectUri            = "redirect_uri"
    case responseType           = "response_type"
    case scope                  = "scope"
    case codeChallenge          = "code_challenge"
    case codeChallengeMethod    = "code_challenge_method"
    case state                  = "state"
    case loginHint              = "login_hint"
}

enum OAuth2AuthorizationKey: String
{
    case clientId       = "client_id"
    case clientSecret   = "client_secret"
    case code
    case state
    case codeVerifier   = "code_verifier"
    case grantType      = "grant_type"
    case redirectUri    = "redirect_uri"
}

enum OAuth2TokenType: String, Codable
{
    case unkown
    case bearer
    case access     = "access_token"
    case refresh    = "refresh_token"
    
    
    // MARK: - Decodable Initialisation
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.singleValueContainer().decode(String.self)
        self = OAuth2TokenType(rawValue: container.lowercased()) ?? .unkown
    }
}

struct OAuth2Token: Codable
{
    // MARK: - Property(s)
    
    let type: OAuth2TokenType
    
    let value: String
    
    
    // MARK: - Initialisation
    
    init(_ type: OAuth2TokenType,
         value: String)
    {
        self.type = type
        self.value = value
    }
}

extension OAuth2Token: PJCKeychainSupporter
{
    func saveToKeychain()
    {
        PJCKeychain.write(value: self.value,
                          forKey: self.type.rawValue)
    }
}

extension OAuth2Token: PJCQueryProvider
{
    var queryItems: [URLQueryItem]
    { return [URLQueryItem(name: self.type.rawValue, value: self.value)] }
}

struct OAuth2ClientCredentials
{
    // MARK: - Consumer API keys
    
    let apiKey: String
    
    let apiSecretKey: String 
    
    
    // MARK: - Access token & access token secret
    
    let accessToken: String?
    
    let accessTokenSecret: String?
    
    
    // MARK: - Initailisation
    
    public init(apiKey: String,
                apiSecretKey: String,
                accessToken: String? = nil,
                accessTokenSecret: String? = nil)
    {
        self.apiKey = apiKey
        self.apiSecretKey = apiSecretKey
        self.accessToken = accessToken
        self.accessTokenSecret = accessTokenSecret
    }
}

extension OAuth2ClientCredentials: PJCURLRequestContentBodyProvider
{
    var body: Data?
    { return "\(self.apiKey):\(self.apiSecretKey)".data(using: .utf8) }
}

struct OAuth2AuthorizationCredentials
{
    // MARK: - Property(s)
    
    let clientId: String
    
    let clientSecret: String?
    
    let redirectUri: String
    
    
    // MARK: - Initailisation
    
    init(_ clientId: String,
         clientSecret: String? = nil,
         redirectUri: String)
    {
        self.clientId = clientId
        self.clientSecret = clientSecret ?? nil
        self.redirectUri = redirectUri
    }
}

extension OAuth2AuthorizationCredentials: PJCQueryProvider
{
    var queryItems: [URLQueryItem]
    {
        var buffer: [URLQueryItem] = []
        buffer.append(URLQueryItem(name: OAuth2Key.clientId.rawValue, value: self.clientId))
        buffer.append(URLQueryItem(name: OAuth2Key.redirectUri.rawValue, value: self.redirectUri))
        
        if let secret = self.clientSecret
        { buffer.append(URLQueryItem(name: OAuth2AuthorizationKey.clientSecret.rawValue, value: secret)) }
        
        return buffer
    }
}

class OAuth2
{
    static var authenticationRoute: OAuth2Route?
    
    static var token: String = ""
}

