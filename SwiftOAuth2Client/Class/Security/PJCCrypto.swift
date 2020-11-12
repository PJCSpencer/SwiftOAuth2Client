//
//  PJCCrypto.swift
//  SwiftOAuth2Client
//
//  Created by Peter Spencer on 30/10/2020.
//

import Foundation
import CryptoKit


enum PJCCryptoKey: String
{
    case s256 = "S256"
}

struct PJCCodeVerifier
{
    // MARK: - Property(s)
    
    let percentEncodedValue: String
    
    
    // MARK: - Initialisation
    
    init?()
    {
        guard let result = String.randomHighEntropyCryptographic(in: 43..<128).urlEncodedSHA256() else
        { return nil }
          
        self.percentEncodedValue = result
    }
}

extension PJCCodeVerifier: PJCQueryProvider
{
    var queryItems: [URLQueryItem]
    {
        var buffer: [URLQueryItem] = []
        buffer.append(URLQueryItem(name: OAuth2Key.codeChallenge.rawValue, value: self.percentEncodedValue))
        buffer.append(URLQueryItem(name: OAuth2Key.codeChallengeMethod.rawValue, value: PJCCryptoKey.s256.rawValue))
        
        return buffer
    }
}

extension SHA256Digest
{
    var bytes: [UInt8]
    { return Array(self.makeIterator()) }
    
    var data: Data
    { return Data(bytes: self.bytes, count: self.bytes.count) }
}

extension String
{
    func toBase64URLEncoded() -> String
    {
        let base64 = Data(self.utf8).base64EncodedString()
 
        return base64.replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
    
    func urlEncodedSHA256() -> String?
    { return self.sha256()?.toBase64URLEncoded() }
    
    func sha256(encoding: String.Encoding = .ascii) -> String?
    {
        guard let data = self.data(using: encoding) else
        { return nil }
        
        let result = SHA256.hash(data: data).data
        return String(decoding: result, as:  UTF8.self )
    }
}

