//
//  PJCDataServiceConsumer.swift
//  SwiftOAuth2Client
//
//  Created by Peter Spencer on 18/11/2020.
//

import Foundation


typealias PJCDataServiceConsumerHandler<T> = (Result<T, Error>) -> Void

protocol PJCConsumerRouter
{
    func route(_ result: PJCDataTaskResult)
}

class PJCDataServiceConsumer
{
    // MARK: - Property(s)
    
    var routers: [Int:PJCConsumerRouter] = [:]
    
    fileprivate var provider: PJCDataTaskProvider
    
    fileprivate var task: URLSessionTask?
    {
        didSet
        {
            if let oldValue = oldValue,
               oldValue.state != .completed
            { oldValue.cancel() }
            
            task?.resume()
        }
    }
    
    
    // MARK: - Initialisation
    
    init(_ provider: PJCDataTaskProvider)
    { self.provider = provider }
    
    deinit
    { self.task = nil }
}

// MARK: - Resuming a Task
extension PJCDataServiceConsumer
{
    func resume<T:Codable>(with request: URLRequest,
                           completion: @escaping PJCDataServiceConsumerHandler<T>)
    {
        if self.routers[PJCDataServiceError.cancelled.statusCode] == nil
        {
            self.routers[PJCDataServiceError.success.statusCode] = PJCConsumerJSONRouter(completion)
            self.routers[PJCDataServiceError.cancelled.statusCode] = PJCConsumerErrorRouter(completion)
        }
        
        self.task = self.provider.task(for: request,
                                       responseHandler: self.responseHandler)
    }
}

// MARK: - PJCResponseHandlerProvider
extension PJCDataServiceConsumer: PJCDataTaskResponseHandlerDelegate
{
    func responseHandler(forStatus code: Int) -> PJCDataTaskResponseHandler?
    {
        switch code
        {
        case 200: return self.routers[code]?.route
        case 400...500: return self.routers[PJCDataServiceError.cancelled.statusCode]?.route
        default: return nil
        }
    }
}

