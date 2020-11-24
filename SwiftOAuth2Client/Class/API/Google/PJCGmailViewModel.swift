//
//  PJCGmailViewModel.swift
//  SwiftOAuth2Client
//
//  Created by Peter Spencer on 24/11/2020.
//

import Foundation


class PJCGmailLabelsViewModel {} // TODO:Support data source/store ...

extension PJCGmailLabelsViewModel
{
    static func reload()
    {
        guard let email = PJCEmailAddress("<paste gmail here>") else
        { return }
        
        OAuth2Controller.shared.completion = { (_) in Self.reload() }
        
        let request = GmailServiceRequest<GmailLabelCollection>(GmailParameters(email),
                                                                provider: GmailLabels.list)
        
        GmailService.shared.request(request)
        { (result) in
            
            if let collection = try? result.get()
            { collection.labels.forEach({ print($0.name )}) }
        }
    }
}

