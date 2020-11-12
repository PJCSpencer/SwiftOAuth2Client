//
//  PJCOAuth2Service+Additions.swift
//  SwiftOAuth2Client
//
//  Created by Peter Spencer on 08/11/2020.
//

import Foundation


enum OAuth2GrantType
{
    case authorizationCode(OAuth2AuthorizationParameters)
    case PKCE
    case implicit                                               // No one should any longer use the implicit grant!
    case password                                               // Not recommended at all anymore.
    case clientCredentials(credentials: OAuth2ClientCredentials)
    case refreshToken
    
    
    // MARK: - Getting the Associated Value
    
    func get<T>() -> T?
    {
        switch self
        {
        case .authorizationCode(let response):
          return response as? T
        case .clientCredentials(let credentials):
            return credentials as? T
        default:
          return nil
        }
    }
}

extension OAuth2GrantType: CustomStringConvertible
{
    var description: String
    {
        switch self
        {
        case .authorizationCode: return "authorization_code"
        case .PKCE: return "pkce"
        case .implicit: return "implicit"
        case .password: return "resource_owner_credentials"
        case .clientCredentials: return "client_credentials"
        case .refreshToken: return "refresh_token"
        }
    }
}

extension OAuth2GrantType: PJCQueryProvider
{
    var queryItems: [URLQueryItem]
    {
        var buffer: [URLQueryItem] = []
        
        if let provider: PJCQueryProvider = self.get()
        {
            buffer = provider.queryItems
            buffer.append(URLQueryItem(name: OAuth2AuthorizationKey.grantType.rawValue,
                                       value: self.description))
        }
        return buffer
    }
}

extension OAuth2GrantType: PJCURLRequestHeaderProvider
{
    var headers: PJCURLRequestHeaders
    {
        switch self
        {
        case .authorizationCode:
            return PJCURLRequestHeaders(self.content)
            
        case .clientCredentials(let credentials):
            
            guard let token = credentials.body?.base64EncodedString() else
            { return PJCURLRequestHeaders() }
            
            let authorization = PJCURLRequestAuthorization(scheme: .basic,
                                                           token: token)
            return PJCURLRequestHeaders(self.content,
                                        authorization: authorization)
            
        default:
            return PJCURLRequestHeaders()
        }
    }
}

extension OAuth2GrantType: PJCURLRequestContentProvider
{
    var content: PJCURLRequestContent
    {
        return PJCURLRequestContent(MIMETypeApplication.xFormUrlencoded,
                                    body: self.body)
    }
}

extension OAuth2GrantType: PJCURLRequestContentBodyProvider
{
    var body: Data?
    {
        var components = URLComponents()
        components.queryItems = self.queryItems
        
        switch self
        {
        case .authorizationCode:
            return components.percentEncodedQuery?
                .replacingOccurrences(of: "+", with: "%2B")
                .data(using: .utf8)
            
        case .clientCredentials:
            return "\(OAuth2AuthorizationKey.grantType.rawValue)=\(self.description)".data(using: .utf8)
        
        default: return nil
        }
    }
}

