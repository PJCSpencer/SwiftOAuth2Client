//
//  PJCGmailAPI.swift
//  SwiftOAuth2Client
//
//  Created by Peter Spencer on 21/11/2020.
//

import Foundation


protocol GmailServiceDelegate
{
    func request<T>(_ request: GmailServiceRequest<T>,
                    completion: @escaping RESTServiceResponseHandler<T>)
}

class GmailService
{
    // MARK: - Accessing the Shared Instance
    
    static let shared: GmailService = GmailService()
    
    
    // MARK: - Property(s)
    
    var consumer: PJCDataConsumer = PJCJSONConsumer(provider: PJCDataService())
    
    var oauth2Controller: OAuth2Controller? = OAuth2Controller.shared
}

extension GmailService: GmailServiceDelegate
{
    func request<T>(_ request: GmailServiceRequest<T>,
                    completion: @escaping RESTServiceResponseHandler<T>)
    {
        guard let urlRequest = request.urlRequest() else
        {
            completion(.failure(PJCDataServiceError.badRequest))
            return
        }
        
        self.oauth2Controller?.completion =
        { [weak self] (_) in self?.request(request, completion: completion) }
        
        self.consumer.resume(with: urlRequest,
                             completion: completion)
    }
}

