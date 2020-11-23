//
//  PJCEmail.swift
//  SwiftOAuth2Client
//
//  Created by Peter Spencer on 23/11/2020.
//

import Foundation


struct PJCDomainName
{
    // MARK: - Property(s)
    
    let value: String
    
    let labels: [String]
    
    let topLevelDomain: String
    
    
    // MARK: - Initialisation
    
    init?(_ value: String)
    {
        let components = value.components(separatedBy: ".")
        
        guard value.count < 255,
              components.count > 1,
              let tld = components.last else
        { return nil }
        
        self.value = value
        self.labels = components
        self.topLevelDomain = tld
    }
}

struct PJCEmailAddress
{
    // MARK: - Property(s)
    
    let value: String
    
    let localPart: String
    
    let domainName: PJCDomainName
    
    
    // MARK: - Initialisation
    
    init?(_ value: String)
    {
        let components = value.components(separatedBy: "@")
        
        guard components.count == 2,
              let local = components.first, local.count < 64,
              let domain = components.last, let domainName = PJCDomainName(domain) else
        { return nil }
        
        self.value = value
        self.localPart = local
        self.domainName = domainName
    }
}

