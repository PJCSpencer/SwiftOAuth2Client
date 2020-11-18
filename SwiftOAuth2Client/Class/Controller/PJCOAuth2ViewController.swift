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
        
        self.threeLeggedExample()
        // self.twoLeggedExample()
    }
}

extension PJCOAuth2ViewController
{
    func threeLeggedExample()
    {
        guard let verifier = PJCCodeVerifier() else
        { return }
        
        let credentials = UIApplication.shared.authorizationCredentials
        let scopes = UIApplication.shared.scopes
        let parameters = OAuth2ConsentParameters(credentials,
                                                 verifier: verifier,
                                                 scopes: scopes)
        
        PJCOAuth2Controller.shared.authorize(parameters: parameters)
    }
    
    func twoLeggedExample()
    {
        let credentials = UIApplication.shared.clientCredentials
        PJCOAuth2Controller.shared.exchange(grant: .clientCredentials(credentials))
    }
}

