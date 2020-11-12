//
//  PJCEndpoint.swift
//  SwiftOAuth2Client
//
//  Created by Peter Spencer on 06/11/2020.
//

import Foundation


// MARK: - Google
struct GoogleAPI: HTTPHost
{ var name: String { return "googleapis.com" }}

struct GoogleAccounts: HTTPHost
{ var name: String { return "accounts.google.com" }}

extension GoogleAccounts: OAuth2PathProvider, OAuth2BasePath
{
    var oauth2Path: OAuth2BasePath { return self }
    
    var auth: String { return "/o/oauth2/v2/auth" }
}

struct GoogleOAuth2: HTTPHost
{ var name: String { return "oauth2.\(GoogleAPI().name)" }}

extension GoogleOAuth2: OAuth2PathProvider, OAuth2BasePath
{ var oauth2Path: OAuth2BasePath { return self }}

// MARK: - Twitter
struct TwitterAPI: HTTPHost
{ var name: String { return "api.twitter.com" }}

struct TwitterOAuth2: HTTPHost
{ var name: String { return TwitterAPI().name }}

extension TwitterOAuth2: OAuth2PathProvider, OAuth2BasePath
{
    var oauth2Path: OAuth2BasePath { return self }
    
    var token: String { return "/oauth2/token" }
}

