//
//  PJCJSONConsumer.swift
//  SwiftOAuth2Client
//
//  Created by Peter Spencer on 19/11/2020.
//

import Foundation


final class PJCJSONConsumer: PJCDataServiceConsumer
{
    // MARK: - Resuming a Task
    
    override func resume<T:Codable>(with request: URLRequest,
                                    completion: @escaping PJCDataServiceConsumerHandler<T>)
    {
        self.routers[PJCDataServiceError.success.statusCode] = PJCConsumerJSONRouter(completion)
        self.routers[PJCDataServiceError.unauthorized.statusCode] = OAuth2ConsumerRouter(completion)
        self.routers[PJCDataServiceError.imATeapot.statusCode] = PJCConsumerErrorRouter(completion)
        
        super.resume(with: request,
                     completion: completion)
    }
    
    
    // MARK: - PJCResponseHandlerProvider
    
    func responseHandler(forStatus code: Int) -> PJCDataTaskResponseHandler?
    {
        switch code
        {
        case 400: return self.routers[PJCDataServiceError.imATeapot.statusCode]?.route
        case 402...500: return self.routers[PJCDataServiceError.imATeapot.statusCode]?.route // TODO:Support range constants ...
        default: return self.routers[code]?.route
        }
    }
}

