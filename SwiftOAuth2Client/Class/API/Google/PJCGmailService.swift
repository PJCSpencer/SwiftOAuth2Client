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

class PJCGmailService
{
    // MARK: - Accessing the Shared Instance
    
    static let shared: PJCGmailService = PJCGmailService()
    
    
    // MARK: - Property(s)
    
    var consumer: PJCDataServiceConsumer
    
    
    // MARK: - Initialisation
    
    private init()
    {
        let configuration = URLSessionConfiguration.named("com.SwiftOAuth2Client.PJCGmailService.cache")
        let session = URLSession(configuration: configuration)
        let service = PJCDataService(session: session)
        
        self.consumer = PJCJSONConsumer(service)
    }
}

extension PJCGmailService: GmailServiceDelegate
{
    func request<T>(_ request: GmailServiceRequest<T>,
                    completion: @escaping RESTServiceResponseHandler<T>)
    {
        guard let resource = request.resource else
        { return }
        
        let apiRequest = PJCAPIRequest(GoogleGmail(),
                                       path: resource.path)
        
        let parameters = PJCURLRequestParameters(resource.method,
                                                 headers: request.headers)
        
        guard let urlRequest = apiRequest.urlRequest(parameters: parameters) else
        {
            completion(.failure(PJCDataServiceError.badRequest))
            return
        }
        
        self.consumer.resume(with: urlRequest,
                             completion: completion)
    }
}

