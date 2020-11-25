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
    
    var consumer: PJCDataServiceConsumer
    
    
    // MARK: - Initialisation
    
    private init()
    {
        let configuration = URLSessionConfiguration.named("com.SwiftOAuth2Client.GmailService.cache")
        let session = URLSession(configuration: configuration)
        let service = PJCDataService(session: session)
        
        self.consumer = PJCJSONConsumer(service)
    }
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
        
        OAuth2Controller.shared.completion =
        { [weak self] (_) in self?.request(request, completion: completion) }
        
        self.consumer.resume(with: urlRequest,
                             completion: completion)
    }
}

