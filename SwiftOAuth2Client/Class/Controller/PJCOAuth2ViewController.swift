//
//  PJCOAuth2ViewController.swift
//  SwiftOAuth2Client
//
//  Created by Peter Spencer on 30/10/2020.
//

import UIKit


class PJCOAuth2ViewController: UIViewController
{
    // MARK: - Managing the View
    
    override func loadView()
    { self.view = PJCOAuth2View(frame: UIScreen.main.bounds) }
    
    
    // MARK: - Responding to View Events
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.threeLeggedExample(callAPIs: false)
        // self.twoLeggedExample()
    }
}

extension PJCOAuth2ViewController
{
    func threeLeggedExample(callAPIs: Bool)
    {
        guard let verifier = PJCCodeVerifier() else
        { return }
        
        let credentials = UIApplication.shared.authorizationCredentials
        let scopes = UIApplication.shared.scopes
        let parameters = OAuth2ConsentParameters(credentials,
                                                 verifier: verifier,
                                                 scopes: scopes)
        
        if callAPIs
        {
            OAuth2Controller.shared.completion = { [weak self] (_) in self?.callAPIs() }
            OAuth2.authenticationRoute = .threeLegged(parameters)
        
            self.callAPIs()
        }
        else
        {
            OAuth2Controller.shared.completion = { (result) in print(result) }
            OAuth2Controller.shared.authorize(parameters: parameters)
        }
    }
    
    func twoLeggedExample()
    {
        let credentials = UIApplication.shared.clientCredentials
        
        OAuth2Controller.shared.completion = { (result) in print(result) }
        OAuth2Controller.shared.exchange(grant: .clientCredentials(credentials))
    }
}

extension PJCOAuth2ViewController
{
    func callAPIs()
    {
        guard let email = PJCEmailAddress("<paste gmail here>") else
        { return }
        
        let request = GmailServiceRequest<GmailLabelCollection>(GmailParameters(email),
                                                                provider: GmailLabels.list)
        
        GmailService.shared.request(request)
        { (result) in
            
            if let collection = try? result.get()
            { collection.labels.forEach({ print($0.name )}) }
        }
    }
}

