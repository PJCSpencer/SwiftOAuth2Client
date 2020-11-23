//
//  PJCGmailServiceEndpoint.swift
//  SwiftOAuth2Client
//
//  Created by Peter Spencer on 23/11/2020.
//

import Foundation


enum GmailUsers: GmailResourceProvider
{
    case base
    
    
    // MARK: - URLBasePathProvider
    
    static var basePath: String = "/gmail/v1/users"
    
    
    // MARK: - GmailPathProvider
    
    func path(with parameters: GmailParameters) -> RESTResourcePathResult
    {
        let path = Self.basePath + "/\(parameters.userId.value)"
        return .success(path)
    }
}

enum GmailLabels: GmailResourceProvider
{
    case list
    
    
    // MARK: - URLBasePathProvider
    
    static var basePath: String = "/labels"
    
    
    // MARK: - GmailPathProvider
    
    func path(with parameters: GmailParameters) -> RESTResourcePathResult
    {
        switch GmailUsers.base.path(with: parameters)
        {
        case .success(let result): return .success(result + Self.basePath)
        case .failure(let error): return .failure(error)
        }
    }
}

enum GmailSettings: GmailResourceProvider
{
    case base
    
    
    // MARK: - URLBasePathProvider
    
    static var basePath: String = "/settings"
    
    
    // MARK: - GmailPathProvider
    
    func path(with parameters: GmailParameters) -> RESTResourcePathResult
    {
        switch GmailUsers.base.path(with: parameters)
        {
        case .success(let result): return .success(result + Self.basePath)
        case .failure(let error): return .failure(error)
        }
    }
}

enum GmailSendAs: String, GmailResourceProvider
{
    case base
    
    
    // MARK: - URLBasePathProvider
    
    static var basePath: String = "/sendAs"
    
    
    // MARK: - GmailPathProvider
    
    func path(with parameters: GmailParameters) -> RESTResourcePathResult
    {
        switch GmailSettings.base.path(with: parameters)
        {
        case .success(let result):
        
            guard let value = parameters.sendAsEmail?.value else
            { return .failure(GmailError.missingParameter("sendAsEmail")) }
            
            return .success(result + Self.basePath + "/\(value)")
            
        case .failure(let error): return .failure(error)
        }
    }
}

enum GmailSmimeInfo: String, GmailResourceProvider
{
    case get
    case insert
    case setDefault
    
    
    // MARK: - URLBasePathProvider
    
    static var basePath: String = "/smimeInfo"
    
    
    // MARK: - HTTPMethodProvider
    
    var method: HTTPMethod
    {
        switch self
        {
        case .insert, .setDefault: return .post
        default: return .get
        }
    }
    
    
    // MARK: - GmailPathProvider
    
    func path(with parameters: GmailParameters) -> RESTResourcePathResult
    {
        switch GmailSendAs.base.path(with: parameters)
        {
        case .success(let result):
            
            guard let value = parameters.id else
            { return .failure(GmailError.missingParameter("id")) }
            
            let parameterPath = result + Self.basePath + "/\(value)"
            var path: String = result
            
            switch self
            {
            case .get: path = parameterPath
            case .setDefault: path = parameterPath + "/\(self.rawValue)"
            default: break
            }
            
            return .success(path)
            
        case .failure(let error): return .failure(error)
        }
    }
}

