//
//  PJCOAuth2ConsumerRouter.swift
//  SwiftOAuth2Client
//
//  Created by Peter Spencer on 19/11/2020.
//

import Foundation


enum OAuth2Route
{
    case twoLegged(OAuth2ClientCredentials)
    case threeLegged(OAuth2ConsentParameters)
}

class OAuth2ConsumerRouter<T>
{
    // MARK: - Property(s)
    
    private(set) var route: OAuth2Route
    
    fileprivate var completion: PJCDataServiceConsumerHandler<T>
    
    
    // MARK: - Initialisation
    
    init?(_ route: OAuth2Route? = OAuth2.authenticationRoute,
          completion: @escaping PJCDataServiceConsumerHandler<T>)
    {
        guard let route = route else
        { return nil }
        
        self.route = route
        self.completion = completion
    }
}

extension OAuth2ConsumerRouter: PJCConsumerRouter
{
    func route(_ result: PJCDataTaskResult)
    {
        switch self.route
        {
        case .twoLegged(let credentials):
            DispatchQueue.main.async()
            { PJCOAuth2Controller.shared.exchange(grant: .clientCredentials(credentials)) }
            
        case .threeLegged(let parameters):
            DispatchQueue.main.async()
            { PJCOAuth2Controller.shared.authorize(parameters: parameters) }
        }
    }
}

