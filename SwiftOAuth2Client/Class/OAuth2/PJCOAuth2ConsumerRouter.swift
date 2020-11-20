//
//  PJCOAuth2ConsumerRouter.swift
//  SwiftOAuth2Client
//
//  Created by Peter Spencer on 19/11/2020.
//

import Foundation


class OAuth2ConsumerRouter<T>
{
    // MARK: - Property(s)
    
    fileprivate var completion: PJCDataServiceConsumerHandler<T>
    
    
    // MARK: - Initialisation
    
    init(_ completion: @escaping PJCDataServiceConsumerHandler<T>)
    { self.completion = completion }
}

extension OAuth2ConsumerRouter: PJCConsumerRouter
{
    func route(_ result: PJCDataTaskResult)
    { print("\(self)::\(#function)")
        
        // TODO:
    }
}

