//
//  PJCDataService+Additions.swift
//
//  Created by Peter Spencer on 14/07/2020.
//  Copyright © 2020 Peter Spencer. All rights reserved.
//

import Foundation


protocol PJCURLRequestProvider
{
    func urlRequest(parameters: PJCURLRequestParameters?) -> URLRequest?
}

protocol PJCURLRequestHeaderProvider
{
    var headers: PJCURLRequestHeaders { get }
}

protocol PJCURLRequestHeaderFieldsProvider
{
    func allHTTPHeaderFields() -> [String:String]
}

protocol PJCURLRequestContentProvider
{
    var content: PJCURLRequestContent { get }
}

protocol PJCURLRequestContentBodyProvider
{
    var body: Data? { get }
}

enum PJCDataServiceError: Error
{
    case none, failed, unkown, noHost, badResponse, unkownData
    
    // 200.
    case success
    
    // 300.
    case redirection
    
    // 400.
    case clientError
    case badRequest, unauthorized, forbidden, notFound, requestTimeout
    case cancelled
    
    // 500.
    case serverError
    case internalServerError, notImplemented, serviceUnavailable
    case permissionDenied
    
    var statusCode: Int // TODO:Support StatusCode struct ...
    {
        switch self
        {
        case .success: return 200
        case .redirection: return 300
        case .badRequest: return 400
        case .unauthorized: return 401
        case .requestTimeout: return 408
        case .cancelled: return 499
        case .internalServerError: return 500
        default: return 0
        }
    }
    
    static func status(_ statusCode: Int) -> PJCDataServiceError
    {
        switch statusCode
        {
        case 200...208: return .success
        case 300...308: return .redirection
        case 400: return .badRequest
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 405...407: return .clientError
        case 408: return .requestTimeout
        case 409...451: return .clientError
        case 499: return .cancelled
        case 500: return .internalServerError
        case 501: return .notImplemented
        case 502: return .serverError
        case 503: return .serviceUnavailable
        case 504...511: return .serverError
        case 550: return .permissionDenied
        default: return .failed
        }
    }
}

enum StatusCode: Int
{
    // 200.
    case success        = 200
    
    // 300
    case redirection    = 300
    
    // 400.
    case badRequest     = 400
    case unauthorized   = 401
    case forbidden      = 403
    case requestTimeout = 408
    case cancelled      = 499
}

enum HTTPHeaderField: String
{
    // MARK: - Accept
    case accept             = "Accept"
    case acceptCharset      = "Accept-Charset"
    case acceptEncoding     = "Accept-Encoding"
    case acceptLanguage     = "Accept-Language"
        
    case authorization      = "Authorization"
        
    // MARK: - Content
    case contentEncoding    = "Content-Encoding"
    case contentLength      = "Content-Length"
    case contentType        = "Content-Type"
}

enum HTTPScheme: String
{
    case http       = "http"
    case https      = "https"
}

enum HTTPMethod: String
{
    case get        = "GET"
    case post       = "POST"
    case delete     = "DELETE"
}

enum AuthenticationScheme: String
{
    case basic      = "Basic"
    case bearer     = "Bearer"
    case digest
    case custom
}

struct ContentType
{
    // MARK: - Constant(s)
    
    static let supportedMIMETypes: [String:MIMEType] =
    [
        MIMETypeApplication.json.description    : MIMETypeApplication.json,
        MIMETypeImage.jpeg.description          : MIMETypeImage.jpeg,
        MIMETypeImage.png.description           : MIMETypeImage.png,
        MIMETypeText.plain.description          : MIMETypeText.plain,
        MIMETypeText.html.description           : MIMETypeText.html
    ]
    
    
    // MARK: - Property(s)
    
    let mimeType: MIMEType
    
    
    // MARK: - Initialisation
    
    init(_ mimeType: MIMEType)
    { self.mimeType = mimeType }
    
    init?(_ string: String?)
    {
        guard let trimmed = string?.lowercased().trimmingCharacters(in: .whitespaces),
            let first = trimmed.split(separator: ";").first,
            let key = String(first) as String?,
            let value = Self.supportedMIMETypes[key] else
        { return nil }
        
        self.mimeType = value
    }
}

// MARK: - Equatable
extension ContentType: Equatable
{
    static func == (lhs: ContentType,
                    rhs: ContentType) -> Bool
    { return lhs.mimeType.description == rhs.mimeType.description }
}

enum ContentEncoding: String
{
    case none
}

protocol MIMEType: CustomStringConvertible
{
    static var domain: String { get }
}

enum MIMETypeApplication: String
{
    case json
    case xFormUrlencoded = "x-www-form-urlencoded; charset=utf-8"
}

// MARK: - CustomStringConvertible
extension MIMETypeApplication: MIMEType
{
    static let domain: String = "application"
    
    var description: String
    { return Self.domain + "/" + self.rawValue }
}

enum MIMETypeImage: String
{
    case gif
    case jpeg
    case png
    case svg
}

// MARK: - CustomStringConvertible
extension MIMETypeImage: MIMEType
{
    static let domain: String = "image"
    
    var description: String
    { return Self.domain + "/" + self.rawValue }
}

enum MIMETypeText: String
{
    case plain
    case html
}

// MARK: - CustomStringConvertible
extension MIMETypeText: MIMEType
{
    static let domain: String = "text"
    
    var description: String
    { return Self.domain + "/" + self.rawValue }
}

// MARK: - PJCURLRequestParameters
struct PJCURLRequestParameters
{
    // MARK: - Property(s)
    
    let method: HTTPMethod
    
    let headers: PJCURLRequestHeaders?
    
    let timeout: TimeInterval
    
    
    // MARK: - Initialisation
    
    init(_ method: HTTPMethod = .get,
         headers: PJCURLRequestHeaders? = nil,
         timeout: TimeInterval = 30)
    {
        self.method = method
        self.headers = headers ?? PJCURLRequestHeaders()
        self.timeout = timeout
    }
}

// MARK: - PJCURLRequestHeaders
struct PJCURLRequestHeaders
{
    // MARK: - Property(s)
    
    let accept: PJCURLRequestAccept?
    
    let authorization: PJCURLRequestAuthorization?
    
    let content: PJCURLRequestContent
    
    let other: PJCURLRequestHeaderFieldsProvider?
    
    
    // MARK: - Initialisation
    
    init(_ content: PJCURLRequestContent = PJCURLRequestContent(),
         authorization: PJCURLRequestAuthorization? = nil,
         other: PJCURLRequestHeaderFieldsProvider? = nil)
    {
        self.accept = nil
        self.authorization = authorization ?? nil
        self.content = content
        self.other = other
    }
}

extension PJCURLRequestHeaders: PJCURLRequestHeaderFieldsProvider
{
    func allHTTPHeaderFields() -> [String:String]
    {
        return (self.accept?.allHTTPHeaderFields() ?? [:])
            + (self.authorization?.allHTTPHeaderFields() ?? [:])
            + self.content.allHTTPHeaderFields()
            + (self.other?.allHTTPHeaderFields() ?? [:])
    }
}

// MARK: - PJCURLRequestAccept
struct PJCURLRequestAccept
{
    let type: MIMEType
}

extension PJCURLRequestAccept: PJCURLRequestHeaderFieldsProvider
{
    func allHTTPHeaderFields() -> [String:String]
    { return [HTTPHeaderField.accept.rawValue:self.type.description] }
}

// MARK: - PJCURLRequestAuthorization
struct PJCURLRequestAuthorization
{
    let scheme: AuthenticationScheme
    
    let token: String
}

extension PJCURLRequestAuthorization: PJCURLRequestHeaderFieldsProvider
{
    func allHTTPHeaderFields() -> [String:String]
    {
        let token = self.scheme == .custom ? self.token : self.scheme.rawValue + " " + self.token
        return [HTTPHeaderField.authorization.rawValue:token]
    }
}

// MARK: - PJCURLRequestContent
struct PJCURLRequestContent
{
    // MARK: - Property(s)
    
    let type: MIMEType
    
    let encoding: ContentEncoding
    
    let body: Data?
    
    
    // MARK: - Initialisation
    
    init(_ type: MIMEType = MIMETypeApplication.json,
         encoding: ContentEncoding? = nil,
         body: Data? = nil)
    {
        self.type = type
        self.encoding = encoding ?? .none
        self.body = body
    }
}

extension PJCURLRequestContent: PJCURLRequestHeaderFieldsProvider
{
    func allHTTPHeaderFields() -> [String:String]
    {
        var fields: [String:String] = [:]
        fields[HTTPHeaderField.contentType.rawValue] = self.type.description
        
        if self.encoding != .none
        { fields[HTTPHeaderField.contentEncoding.rawValue] = self.encoding.rawValue }
        
        if let count = self.body?.count
        { fields[HTTPHeaderField.contentLength.rawValue] = "\(count)" }
        
        return fields
    }
}

struct PJCOtherRequestHeaders
{
    let queryItems: [URLQueryItem]
}

extension PJCOtherRequestHeaders: PJCURLRequestHeaderFieldsProvider
{
    func allHTTPHeaderFields() -> [String:String]
    {
        let fields: [String:String] = self.queryItems.compactMap({ [$0.name:$0.value!] }).reduce([:], +)
        return fields
    }
}

