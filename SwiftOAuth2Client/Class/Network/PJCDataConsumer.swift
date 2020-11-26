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

class PJCDataConsumer: PJCDataTaskResponseHandlerDelegate
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
    
    init(provider: PJCDataTaskProvider)
    { self.provider = provider }
    
    deinit
    { self.task = nil }
    
    
    // MARK: - Controlling a Task
    
    func resume<T:Codable>(with request: URLRequest,
                           completion: @escaping PJCDataServiceConsumerHandler<T>)
    {
        self.task = self.provider.task(for: request,
                                       responseHandler: self.responseHandler)
    }
    
    func cancel()
    { self.task = nil }
    
    
    // MARK: - PJCDataTaskResponseHandlerDelegate
    
    func responseHandler(forStatus code: Int) -> PJCDataTaskResponseHandler?
    { return nil }
}

