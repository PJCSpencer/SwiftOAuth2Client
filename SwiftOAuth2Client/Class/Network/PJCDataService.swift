//
//  PJCDataService.swift
//
//  Created by Peter Spencer on 14/07/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


typealias PJCDataTaskResult = Result<PJCTaskData, Error>

typealias PJCDataTaskResponseHandler = (PJCDataTaskResult) -> Void

typealias PJCDataTaskResponseHandlerProvider = (_ statusCode: Int) -> PJCDataTaskResponseHandler?

protocol PJCDataTaskProvider
{
    func task(for request: URLRequest,
              responseHandler: @escaping PJCDataTaskResponseHandlerProvider) -> URLSessionTask
}

protocol PJCDataTaskResponseHandlerDelegate
{
    func responseHandler(forStatus code: Int) -> PJCDataTaskResponseHandler?
}

extension PJCDataTaskResult where Success == PJCTaskData
{
    func serialisedJSON<T:Codable>() -> Result<T, Error>
    {
        guard let result: T = try? self.get().decodedJSON() else
        { return .failure(PJCDataServiceError.failed) }
        
        return .success(result)
    }
}

// MARK: - PJCTaskData
struct PJCTaskData
{
    let data: Data
    
    let type: ContentType
}

extension PJCTaskData
{
    func decodedJSON<T:Codable>() -> T?
    {
        guard self.type == ContentType(MIMETypeApplication.json),
            let result = try? JSONDecoder().decode(T.self, from: self.data) else
        { return nil }
        
        return result
    }
}

// MARK: - PJCDataService
class PJCDataService
{
    // MARK: - Property(s)
    
    private(set) var session: URLSession // Alternatively, URLSession could be extended to support PJCDataTaskProvider.
    
    
    // MARK: - Initialisation
    
    init(session: URLSession? = nil)
    { self.session = session ?? URLSession.shared }
}

extension PJCDataService: PJCDataTaskProvider // TODO:Task could be baked in to the returned escaping function which takes a completion handler ..?
{
    typealias PJCTaskResponseHandler = (Result<Any, Error>) -> Void
    
    typealias PJCTaskResponseCompletionHandler = () -> Void
    
    func task(for request: URLRequest,
              responseHandler: @escaping PJCDataTaskResponseHandlerProvider) -> URLSessionTask
    {
        return self.session.dataTask(with: request)
        { (data, response, error) in
            
            if (error as NSError?)?.code == NSURLErrorCancelled,
               let handler = responseHandler(PJCDataServiceError.cancelled.statusCode) as PJCDataTaskResponseHandler?
            {
                handler(.failure(PJCDataServiceError.cancelled))
                return
            }
            
            guard error == nil,
                let response = response as? HTTPURLResponse else
            { return }
            
            let statusCode = response.statusCode
            guard let handler = responseHandler(statusCode) as PJCDataTaskResponseHandler? else
            { return }
            
            let serviceError = PJCDataServiceError.status(statusCode)
            guard let contentType = response.allHeaderFields[HTTPHeaderField.contentType.rawValue] as? String,
                let data = data  else
            {
                handler(.failure(serviceError))
                return
            }
            
            guard let type = ContentType(contentType) else
            {
                handler(.failure(PJCDataServiceError.unkownData))
                return
            }
            
            let result = PJCTaskData(data: data, type: type)
            handler(.success(result))
        }
    }
}

