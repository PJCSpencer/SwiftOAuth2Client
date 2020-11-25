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
        
        self.threeLeggedExample(callAPIs: true)
        // self.twoLeggedExample()
    }
}

extension PJCOAuth2ViewController
{
    func threeLeggedExample(callAPIs: Bool)
    {
        let credentials = UIApplication.shared.authorizationCredentials
        let scopes = UIApplication.shared.scopes
        
        guard let parameters = OAuth2ConsentParameters(credentials,
                                                       scopes: scopes) else
        { return }
        
        if callAPIs
        {
            OAuth2.authenticationRoute = .threeLegged(parameters)
            PJCGmailLabelsViewModel.reload()
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

