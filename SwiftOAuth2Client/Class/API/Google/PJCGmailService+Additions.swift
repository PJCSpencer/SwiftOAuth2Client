//
//  PJCGmailService+Additions.swift
//  SwiftOAuth2Client
//
//  Created by Peter Spencer on 23/11/2020.
//

import Foundation


typealias GmailResourceProvider = HTTPMethodProvider & URLBasePathProvider & GmailPathProvider

protocol GmailPathProvider
{
    func path(with parameters: GmailParameters) -> RESTResourcePathResult
}

enum GmailError: Error
{
    case failed(String)
    case missingParameter(String)
}

struct GmailParameters // TODO:Support messageId, delegateEmail ...
{
    // MARK: - Property(s)
    
    let userId: PJCEmailAddress
    
    let sendAsEmail: PJCEmailAddress?
    
    let id: String?
    
    
    // MARK: - Initialisation
    
    init(_ userId: PJCEmailAddress,
         sendAsEmail: PJCEmailAddress? = nil,
         id: String? = nil)
    {
        self.userId = userId
        self.sendAsEmail = sendAsEmail
        self.id = id
    }
}

struct GmailServiceRequest<T:Codable>
{
    // MARK: - Property(s)
    
    fileprivate let parameters: GmailParameters
    
    fileprivate let provider: GmailResourceProvider
    
    var resource: PJCEndpointResource?
    {
        switch self.provider.path(with: self.parameters)
        {
        case .success(let path): return PJCEndpointResource(self.provider.method, path: path)
        default: return nil
        }
    }
    
    
    // MARK: - Initialisation
    
    init(_ parameters: GmailParameters,
         provider: GmailResourceProvider)
    {
        self.parameters = parameters
        self.provider = provider
    }
}

extension GmailServiceRequest: PJCURLRequestHeaderProvider
{
    var headers: PJCURLRequestHeaders
    {
        guard let token = PJCKeychain.read(valueForKey: OAuth2TokenType.access.rawValue) else
        { return PJCURLRequestHeaders() }
        
        let auth = PJCURLRequestAuthorization(scheme: .bearer,
                                              token: token)
        
        return  PJCURLRequestHeaders(authorization: auth)
    }
}

extension GmailServiceRequest: PJCURLRequestProvider
{
    func urlRequest(parameters: PJCURLRequestParameters? = nil) -> URLRequest?
    {
        guard let resource = self.resource else
        { return nil }
        
        let apiRequest = PJCAPIRequest(GoogleGmail(),
                                       path: resource.path)
        
        let parameters = PJCURLRequestParameters(resource.method,
                                                 headers: self.headers)
        
        return apiRequest.urlRequest(parameters: parameters)
    }
}

