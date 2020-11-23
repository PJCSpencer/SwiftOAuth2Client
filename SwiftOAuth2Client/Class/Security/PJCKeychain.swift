//
//  PJCKeychain.swift
//  SwiftOAuth2Client
//
//  Created by Peter Spencer on 23/11/2020.
//

import Foundation


protocol PJCKeychainSupporter
{
    func saveToKeychain()
}

class PJCKeychain
{
    class func write(value: String,
                     forKey ket: String)
    {
        OAuth2.token = value // TODO:Write value to keychain ...
    }
}

