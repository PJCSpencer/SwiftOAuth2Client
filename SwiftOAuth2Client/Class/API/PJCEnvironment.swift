//
//  PJCEnvironment.swift
//
//  Created by Peter Spencer on 14/07/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


protocol HTTPHost
{
    var scheme: HTTPScheme { get }
    
    var name: String { get } // TODO:Support DomainName ..?
    
    var address: String? { get } // TODO:Support IPAddress ..?
}

extension HTTPHost
{
    var scheme: HTTPScheme { return .https }
    
    var address: String? { return nil }
}

enum PJCEnvironment
{
    case develop
    case production
    case qa
    
    
    // MARK: - Returning the Current Environment
    
    static var current: PJCEnvironment
    { return .develop }
    
    
    // MARK: - Returning the Host(s)
    
    static var host: OAuth2Host
    {
        switch PJCEnvironment.current
        {
        default: return GoogleAccounts()
        }
    }
    
    var authHost: OAuth2Host { return PJCEnvironment.host }
    
    var tokenHost: OAuth2Host? { return GoogleOAuth2() }
}

