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

class OAuth2ConsumerRouter<T> // NB:Small compromise for convenience.
{
    // MARK: - Property(s)
    
    private(set) var route: OAuth2Route
    
    
    // MARK: - Initialisation
    
    init?(_ route: OAuth2Route? = OAuth2.authenticationRoute)
    {
        guard let route = route else
        { return nil }
        
        self.route = route
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
            { OAuth2Controller.shared.exchange(grant: .clientCredentials(credentials)) }
            
        case .threeLegged(let parameters):
            DispatchQueue.main.async()
            { OAuth2Controller.shared.authorize(parameters: parameters) }
        }
    }
}

