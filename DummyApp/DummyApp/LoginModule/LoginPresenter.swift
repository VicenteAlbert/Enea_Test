//
//  LoginPresenter.swift
//  DummyApp
//
//  Created by Vicentiu Petreaca on 20/10/2019.
//  Copyright © 2019 Vicentiu Petreaca. All rights reserved.
//

import AuthenticationServices

class LoginPresenter {
    
    // here we store the ASWebAuthenticationSession locally because if we don't do that and just instantiate it on the
    // loginWithGithub method, it'll be deallocated even before showing the confirmation alert for the login
    private var authSession: ASWebAuthenticationSession?
    
    public func loginWithGithub(_ response: @escaping (Bool) -> Void) {
        
        // again this is not a good idea, because even the clientid is hardcoded, which should be kept somewhere secret
        // like the keychain, but for the sake of simplicity we'll just leave it here
        let urlString = "https://github.com/login/oauth/authorize?scope=read:user&client_id=7698d5e2a47e5b8bc1e1"
        guard let url = URL(string: urlString) else { return }
        
        // instantiate the authentiation session
        authSession = ASWebAuthenticationSession(url: url, callbackURLScheme: "dummy-app") { receivedUrl, err in
            
            // here we make the following assumption: the credentials were entered correctly (because otherwise this
            // completion wouldn't be called by the authentication session) so therefore we've received the callback
            // url set in the Github's application, which has the scheme "dummy-app://". If the received url is not nil
            // and the error is nil, we consider the login successful
            response(receivedUrl != nil && err == nil)
        }
        
        // start the session which will trigger the confirmation alert
        authSession?.start()
    }
}
