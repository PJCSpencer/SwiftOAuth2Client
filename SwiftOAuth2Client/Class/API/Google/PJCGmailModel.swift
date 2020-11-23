//
//  GmailModel.swift
//  SwiftOAuth2Client
//
//  Created by Peter Spencer on 23/11/2020.
//

import Foundation


// MARK: - Labels
struct GmailLabelCollection: Codable
{
    let labels: [GmailLabel]
}

struct GmailLabel: Codable
{
    let id: String
    
    let name: String
}

