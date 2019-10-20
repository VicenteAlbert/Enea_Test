//
//  LoginViewController.swift
//  DummyApp
//
//  Created by Vicentiu Petreaca on 20/10/2019.
//  Copyright © 2019 Vicentiu Petreaca. All rights reserved.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {

    var presenter: LoginPresenter!
    
    @IBAction func loginPressed() {
        
        // when you press the "Login with Github" button, forward the action to the presenter and attempt to login with
        // Github's OAuth
        presenter.loginWithGithub { [weak self] success in
            
            // If you enter the correct credentials then just navigate to the next screen, the repository list
            if success {
                self?.performSegue(withIdentifier: "toList", sender: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // instantiate the login presenter which will be used for handling the button tap
        presenter = LoginPresenter()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let listController = segue.destination as? RepositoryListViewController
        
        // just inject the presenter for the next screen
        listController?.presenter = RepositoryListPresenter()
    }
    
}
