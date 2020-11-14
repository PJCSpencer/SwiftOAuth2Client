//
//  PJCAPI.swift
//
//  Created by Peter Spencer on 14/07/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


enum PJCAPIError: Error
{
    case none
    case failed, canceled
    case unknown
}

// MARK: - Protocol(s)
protocol PJCQueryProvider
{
    var queryItems: [URLQueryItem] { get }
}

protocol PJCAPIPathComponent // TODO:Support version, type, etc ..?
{
    static var relativePath: String { get }
}

// MARK: - PJCAPIRequest
struct PJCAPIRequest
{
    let host: HTTPHost
    
    let path: String
    
    let queryItems: [URLQueryItem]
    
    
    // MARK: - Initialisation
    
    init(_ host: HTTPHost? = nil,
         path: String,
         queryItems: [URLQueryItem]? = nil)
    {
        self.host = host ?? PJCEnvironment.host
        self.path = path
        self.queryItems = queryItems ?? []
    }
}

extension PJCAPIRequest: PJCURLRequestProvider
{
    func urlRequest(parameters: PJCURLRequestParameters? = nil) -> URLRequest?
    {
        return URLComponents.from(self).urlRequest(parameters: parameters)
    }
}

// MARK: - PJCGenericAPIRequest
struct PJCGenericAPIRequest<T: PJCAPIPathComponent>
{
    let host: HTTPHost
    
    let type: T.Type
    
    let queryItems: [URLQueryItem]
    
    
    // MARK: - Initialisation
    
    init(_ host: HTTPHost? = nil,
         type: T.Type,
         queryItems: [URLQueryItem] = [])
    {
        self.host = host ?? PJCEnvironment.host
        self.type = type
        self.queryItems = queryItems
    }
}

extension PJCGenericAPIRequest: PJCURLRequestProvider
{
    func urlRequest(parameters: PJCURLRequestParameters? = nil) -> URLRequest?
    {
        return URLComponents.from(self).urlRequest(parameters: parameters)
    }
}

// MARK: - PJCAPIResponse
struct PJCAPIResponse<T> // NB:The following response struct names should be swapped.
{
    let data: PJCAPIDataResponse<T>?
    
    let error: Error?
}

struct PJCAPIDataResponse<T>
{
    // MARK: - Property(s)
    
    let objects: [T]
    
    let indexPaths: [IndexPath]
    
    
    // MARK: - Initialiser(s)
    
    init(_ objects: [T]? = nil,
         indexPaths: [IndexPath]? = nil)
    {
        self.objects = objects ?? []
        self.indexPaths = indexPaths ?? []
    }
}

typealias PJCAPILoadingResult = Result<[IndexPath], Error>

typealias PJCAPILoadingRequestHandler = (PJCAPILoadingResult) -> Void

protocol PJCAPILoadingDelegate
{
    func appendLoad(_ completion: @escaping PJCAPILoadingRequestHandler)
}

