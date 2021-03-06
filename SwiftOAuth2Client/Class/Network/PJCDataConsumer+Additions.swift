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
    
    fileprivate var completion: PJCDataConsumerHandler<T>
    
    
    // MARK: - Initialisation
    
    init(_ completion: @escaping PJCDataConsumerHandler<T>)
    { self.completion = completion }
}

extension PJCConsumerErrorRouter: PJCConsumerRouter
{
    func route(_ result: PJCDataTaskResult)
    {
        var error: Error = PJCDataServiceError.unknown
            
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
    
    fileprivate var completion: PJCDataConsumerHandler<T>
    
    
    // MARK: - Initialisation
    
    init(_ completion: @escaping PJCDataConsumerHandler<T>)
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

