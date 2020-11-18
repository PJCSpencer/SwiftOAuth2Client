//
//  PJCOAuth2TokenService.swift
//  SwiftOAuth2Client
//
//  Created by Peter Spencer on 08/11/2020.
//

import Foundation


typealias OAuth2TokenServiceResult = Result<OAuth2TokenResponse, Error>

typealias OAuth2TokenServiceResponseHandler = (OAuth2TokenServiceResult) -> Void

protocol OAuth2TokenServiceDelegate
{
    func exchange(grant: OAuth2GrantType,
                  completion: @escaping OAuth2TokenServiceResponseHandler)
}

final class OAuth2TokenService
{
    // MARK: - Accessing the Shared Instance
    
    static let shared: OAuth2TokenService = OAuth2TokenService()
    
    
    // MARK: - Property(s)
    
    var host: OAuth2Host?
    
    fileprivate var consumer: PJCDataServiceJSONConsumer<OAuth2TokenResponse>
    
    
    // MARK: - Initialisation
    
    private init()
    {
        let configuration = URLSessionConfiguration.named("com.SwiftOAuth2Client.PJCOAuth2TokenService.cache")
        let session = URLSession(configuration: configuration)
        let service = PJCDataService(session: session)
        
        self.consumer = PJCDataServiceJSONConsumer<OAuth2TokenResponse>(service)
    }
}

extension OAuth2TokenService: OAuth2TokenServiceDelegate
{
    func exchange(grant: OAuth2GrantType,
                  completion: @escaping OAuth2TokenServiceResponseHandler)
    {
        guard let host = self.host else
        {
            completion(.failure(PJCDataServiceError.noHost))
            return
        }
        
        let apiRequest = PJCAPIRequest(host,
                                       path: host.oauth2Path.token)
        
        let parameters = PJCURLRequestParameters(.post,
                                                 headers: grant.headers)
        
        guard let urlRequest = apiRequest.urlRequest(parameters: parameters) else
        {
            completion(.failure(PJCDataServiceError.badRequest))
            return
        }
        
        self.consumer.resume(with: urlRequest,
                             completion: completion)
    }
}

