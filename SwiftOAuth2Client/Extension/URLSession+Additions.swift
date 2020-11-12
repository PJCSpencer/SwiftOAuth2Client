//
//  URLSession+Additions.swift
//
//  Created by Peter Spencer on 14/07/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


typealias JSONObject = [String:Any]
typealias JSONCollection = [JSONObject]

let PJCDefaultTimeoutInterval: TimeInterval = 30

// MARK: - URLSessionConfiguration
extension URLSessionConfiguration
{
    class func named(_ path: String) -> URLSessionConfiguration
    {
        let anObject: URLSessionConfiguration = URLSessionConfiguration.default
        anObject.requestCachePolicy = .useProtocolCachePolicy
        anObject.timeoutIntervalForRequest = PJCDefaultTimeoutInterval
        anObject.waitsForConnectivity = true
        anObject.urlCache = URLCache(memoryCapacity: 1.megabytes(),
                                     diskCapacity: 10.megabytes(),
                                     diskPath: path)
        
        return anObject
    }
}

// MARK: - URLComponents
extension URLComponents
{
    static func from(_ request: PJCAPIRequest) -> URLComponents
    {
        var components: URLComponents = URLComponents()
        components.scheme = request.host.scheme.rawValue
        components.host = request.host.name
        components.path = request.path
        components.queryItems = request.queryItems.isEmpty ? nil : request.queryItems
        
        return components
    }
    
    static func from<T>(_ request: PJCGenericAPIRequest<T>) -> URLComponents
    {
        var components: URLComponents = URLComponents()
        components.scheme = request.host.scheme.rawValue
        components.host = request.host.name
        components.path = request.type.relativePath
        components.queryItems = request.queryItems.isEmpty ? nil : request.queryItems
        
        return components
    }
}

extension URLComponents: PJCURLRequestProvider
{
    func urlRequest(parameters: PJCURLRequestParameters? = nil) -> URLRequest?
    {
        guard let url = self.url else
        { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = parameters?.method.rawValue
        request.httpBody = parameters?.headers?.content.body
        request.timeoutInterval = parameters?.timeout ?? PJCDefaultTimeoutInterval
        
        parameters?.headers?.allHTTPHeaderFields().forEach()
        { (key, value) in request.setValue(value, forHTTPHeaderField: key) }
        
        return request
    }
}

