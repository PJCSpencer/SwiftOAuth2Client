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
        var sequence = [UInt8](repeating: 0,
                               count: 32)
        
        guard SecRandomCopyBytes(kSecRandomDefault,
                                 sequence.count,
                                 &sequence) == errSecSuccess else
        { return nil }
        
        self.percentEncodedValue = Data(sequence)
            .base64EncodedString()
            .base64URLEncodedString()
    }
}

extension PJCCodeVerifier: PJCQueryProvider
{
    var queryItems: [URLQueryItem]
    {
        var buffer: [URLQueryItem] = []
        buffer.append(URLQueryItem(name: OAuth2Key.codeChallenge.rawValue,
                                   value: self.percentEncodedValue.urlEncodedSHA256()))
        
        buffer.append(URLQueryItem(name: OAuth2Key.codeChallengeMethod.rawValue,
                                   value: PJCCryptoKey.s256.rawValue))
        
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
    func urlEncodedSHA256() -> String?
    { return self.sha256()?.base64URLEncodedString() }
    
    func sha256(encoding: String.Encoding = .utf8) -> String?
    {
        guard let data = self.data(using: encoding) else
        { return nil }
        
        return SHA256.hash(data: data).data.base64EncodedString()
    }
    
    func base64URLEncodedString() -> String
    {
        return self.replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
            .trimmingCharacters(in: .whitespaces)
    }
}

