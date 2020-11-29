//
//  PJCJSONConsumer.swift
//  SwiftOAuth2Client
//
//  Created by Peter Spencer on 19/11/2020.
//

import Foundation


final class PJCJSONConsumer: PJCDataConsumer
{
    // MARK: - Resuming a Task
    
    override func resume<T:Codable>(with request: URLRequest,
                                    completion: @escaping PJCDataConsumerHandler<T>)
    {
        self.routers[PJCDataServiceError.success.statusCode] = PJCConsumerJSONRouter(completion)
        self.routers[PJCDataServiceError.imATeapot.statusCode] = PJCConsumerErrorRouter(completion)
        self.routers[PJCDataServiceError.unauthorized.statusCode] = OAuth2ConsumerRouter<T>()
        
        super.resume(with: request,
                     completion: completion)
    }
    
    
    // MARK: - PJCResponseHandlerProvider
    
    override func responseHandler(forStatus code: Int) -> PJCDataTaskResponseHandler?
    {
        switch code
        {
        case 400: return self.routers[PJCDataServiceError.imATeapot.statusCode]?.route
        case 402...500: return self.routers[PJCDataServiceError.imATeapot.statusCode]?.route // TODO:Support range constants ...
        default: return self.routers[code]?.route
        }
    }
}

