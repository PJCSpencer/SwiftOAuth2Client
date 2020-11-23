//
//  PJCRestResource.swift
//  SwiftOAuth2Client
//
//  Created by Peter Spencer on 21/11/2020.
//

import Foundation


typealias RESTServiceResult<T> = Result<T, Error>

typealias RESTServiceResponseHandler<T> = (RESTServiceResult<T>) -> Void

typealias RESTResourcePathResult = Result<String, Error>

protocol RESTViewModelProvider {}

struct PJCEndpointResource
{
    // MARK: - Property(s)
    
    let method: HTTPMethod
    
    let path: String
    
    
    // MARK: - Initialisation
    
    init(_ method: HTTPMethod? = nil,
         path: String)
    {
        self.method = method ?? .get
        self.path = path
    }
}

