//
//  PJCDataServiceConsumer.swift
//  SwiftOAuth2Client
//
//  Created by Peter Spencer on 18/11/2020.
//

import Foundation


/*typealias PJCDataServiceConsumerHandler<T> = (Result<T, Error>) -> Void

protocol PJCConsumerDelegate
{
    associatedtype ConsumerType
    
    // func callback<T>(_ result: Result<T, Error>)
    
    var callback: PJCDataServiceConsumerHandler<ConsumerType>? { get set }
}

class PJCDataServiceConsumer<T>
{
    // MARK: - Property(s)
    
    fileprivate var provider: PJCDataTaskProvider
    
    fileprivate var task: URLSessionTask?
    {
        didSet
        {
            if let oldValue = oldValue,
               oldValue.state != .completed
            {
                oldValue.cancel()
                
                /*DispatchQueue.main.async()
                { self.completion?(.failure(PJCAPIError.canceled)) }*/
            }
            task?.resume()
        }
    }
    
    // fileprivate var delegate: PJCConsumerDelegate?
    
    
    // MARK: - Initialisation
    
    init(_ provider: PJCDataTaskProvider)
    { self.provider = provider }
    
    deinit
    { self.task = nil }
}

// MARK: - Resuming a Task
extension PJCDataServiceConsumer
{
    func resume(with request: URLRequest,
                completion: @escaping PJCDataServiceConsumerHandler<T>)
    {
        
    }
    
    private func resumeOriginalRequest()
    {

    }
}*/

