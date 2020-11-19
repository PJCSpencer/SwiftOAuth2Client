//
//  PJCDataServiceConsumer+Additions.swift
//  SwiftOAuth2Client
//
//  Created by Peter Spencer on 19/11/2020.
//

import Foundation


class PJCConsumerErrorRouter<T>
{
    // MARK: - Property(s)
    
    fileprivate var completion: PJCDataServiceConsumerHandler<T>
    
    
    // MARK: - Initialisation
    
    init(_ completion: @escaping PJCDataServiceConsumerHandler<T>)
    { self.completion = completion }
}

extension PJCConsumerErrorRouter: PJCConsumerRouter
{
    func route(_ result: PJCDataTaskResult)
    {
        var error: Error = PJCDataServiceError.unkown
            
        switch result
        {
        case .failure(let err): error = err
        default: break
        }
        
        DispatchQueue.main.async()
        { self.completion(.failure(error)) }
    }
}

class PJCConsumerJSONRouter<T:Codable>
{
    // MARK: - Property(s)
    
    fileprivate var completion: PJCDataServiceConsumerHandler<T>
    
    
    // MARK: - Initialisation
    
    init(_ completion: @escaping PJCDataServiceConsumerHandler<T>)
    { self.completion = completion }
}

extension PJCConsumerJSONRouter: PJCConsumerRouter
{
    func route(_ result: PJCDataTaskResult)
    {
        DispatchQueue.main.async()
        { self.completion(result.serialisedJSON()) }
    }
}

class PJCErrorConsumerRouters // TODO:
{
    static func all<T>(with completion: @escaping PJCDataServiceConsumerHandler<T>) -> [PJCConsumerRouter]
    {
        return []
    }
}

