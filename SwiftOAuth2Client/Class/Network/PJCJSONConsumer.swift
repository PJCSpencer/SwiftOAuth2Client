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
        if self.routers[PJCDataServiceError.imATeapot.statusCode] == nil
        {
            self.routers[PJCDataServiceError.success.statusCode] = PJCConsumerJSONRouter(completion)
            self.routers[PJCDataServiceError.imATeapot.statusCode] = PJCConsumerErrorRouter(completion)
        }
        
        super.resume(with: request,
                     completion: completion)
    }
    
    
    // MARK: - PJCResponseHandlerProvider
    
    override func responseHandler(forStatus code: Int) -> PJCDataTaskResponseHandler?
    {
        switch code
        {
        case 200: return self.routers[code]?.route
        case 400...500: return self.routers[PJCDataServiceError.imATeapot.statusCode]?.route
        default: return nil
        }
    }
}

