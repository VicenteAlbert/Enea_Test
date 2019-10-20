//
//  RepositoryListPresenter.swift
//  DummyApp
//
//  Created by Vicentiu Petreaca on 20/10/2019.
//  Copyright © 2019 Vicentiu Petreaca. All rights reserved.
//

import Foundation
import FutureKit

class RepositoryListPresenter {
    
    // Why a function here? because it'll help us a lot when we'll be testing this presenter
    // it's way more declarative like this because you don't really need to know what happens
    // inside of it, you only know that give a String, which represents the query (or in our case the whole url) and an
    // Int which represents the number of the results returned, you get back a Future of your needed type that will be
    // filled at some point
    private var networking: (String, Int) -> Future<[Repository]>
    
    // here we declare our downloading function optional and assign a value of nil to it for the following reason:
    // maybe you don't need any custom behavior and you just want to use the default behavior, in our tests, we'll
    // inject a custom function so we don't actually hit the network
    init(loader: ((String, Int) -> Future<[Repository]>)? = nil) {
        self.networking = loader ?? NetworkManager.defaultRepositoryLoader
    }
    
    // This method fetches the top `limit` repositories from github
    func fetchRepositories(limit: Int, _ completion: @escaping ([Repository], Error?) -> Void) {
        
        // hardcoded strings are not a great idea, but for the sake of simplicity and because in the reqs was not
        // specified anything about the query itself (if it's random, if the user has to input it, etc), I've just
        // hardcoded a query that searches for the word "swift" and the results are already sorted by their stars
        let query = "https://api.github.com/search/repositories?q=swift+language:swift&sort=stars&order=desc"
        
        // just call our fetching function and forward it's results to the completion
        networking(query, limit)
            .onSuccess { repositories in
                completion(repositories, nil)
            }
            .onFail { error in
                completion([], error)
        }
    }
}
