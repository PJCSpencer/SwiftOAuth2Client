//
//  PJCDataServiceJSONConsumer.swift
//
//  Created by Peter Spencer on 21/10/2020.
//

import Foundation


typealias PJCDataServiceJSONConsumerHandler<T> = (Result<T, Error>) -> Void

class PJCDataServiceJSONConsumer<T:Codable> // TODO:Support aborting and returning error after (n) retries ...
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
                
                DispatchQueue.main.async()
                { self.completion?(.failure(PJCAPIError.canceled)) }
            }
            task?.resume()
        }
    }
    
    fileprivate var completion: PJCDataServiceJSONConsumerHandler<T>?
    
    
    // MARK: - Initialisation
    
    init(_ provider: PJCDataTaskProvider)
    { self.provider = provider }
    
    deinit
    { self.task = nil }
}

// MARK: - Resuming a Task
extension PJCDataServiceJSONConsumer
{
    func resume(with request: URLRequest,
                completion: @escaping PJCDataServiceJSONConsumerHandler<T>)
    {
        self.completion = completion
        self.task = self.provider.task(for: request,
                                       responseHandler: self.responseHandler)
    }
    
    private func resumeOriginalRequest()
    {
        guard let request = self.task?.originalRequest,
              let completion = self.completion else
        { return }
        
        self.resume(with: request,
                    completion: completion)
    }
}

// MARK: - PJCResponseHandlerProvider
extension PJCDataServiceJSONConsumer: PJCDataTaskResponseHandlerDelegate
{
    func responseHandler(forStatus code: Int) -> PJCDataTaskResponseHandler?
    {
        let table: [Int:PJCDataTaskResponseHandler] =
        [
            PJCDataServiceError.success.statusCode              : self.serialise,
            PJCDataServiceError.badRequest.statusCode           : self.badRequest,
            PJCDataServiceError.forbidden.statusCode            : self.forbidden,
            PJCDataServiceError.unauthorized.statusCode         : self.unauthorized,
            PJCDataServiceError.internalServerError.statusCode  : self.internalServerError,
        ]
        return table[code]
    }
}

// MARK: - URL Response Consumer Method(s)
extension PJCDataServiceJSONConsumer
{
    private func serialise(_ result: PJCDataTaskResult)
    {
        DispatchQueue.main.async()
        { self.completion?(result.serialisedJSON()) }
    }
    
    private func badRequest(_ result: PJCDataTaskResult)
    {
        DispatchQueue.main.async()
        { self.completion?(.failure(PJCDataServiceError.badRequest)) }
    }
    
    private func forbidden(_ result: PJCDataTaskResult)
    {
        DispatchQueue.main.async()
        { self.completion?(.failure(PJCDataServiceError.forbidden)) }
    }
    
    private func unauthorized(_ result: PJCDataTaskResult)
    {
        DispatchQueue.main.async()
        { self.completion?(.failure(PJCDataServiceError.unauthorized)) }
    }
    
    private func internalServerError(_ result: PJCDataTaskResult)
    {
        DispatchQueue.main.async()
        { self.completion?(.failure(PJCDataServiceError.internalServerError)) }
    }
}

