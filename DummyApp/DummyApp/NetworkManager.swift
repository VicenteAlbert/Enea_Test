//
//  NetworkManager.swift
//  DummyApp
//
//  Created by Vicentiu Petreaca on 20/10/2019.
//  Copyright © 2019 Vicentiu Petreaca. All rights reserved.
//

import FutureKit
import Alamofire

struct NetworkManager {
    private struct Container: Decodable {
        let items: [Repository]
    }
    // we don't want to initialize this struct, as it's only used as a namespace
    private init() {}
    
    // here we define a default behavior for fetching the repositories
    static let defaultRepositoryLoader: (String, Int) -> Future<[Repository]> = { query, limit in
        guard let url = URL(string: query) else {
            let error = NSError(domain: "NetworkManager - malformed url", code: -89, userInfo: nil)
            return Future(fail: error)
        }
        
        // execute the actual request, validate it, use our written function to decode a Container, which only contains
        // one value, an items array of type Repository, finally only get the first `limit` items
        return Alamofire.request(url, method: .get)
            .validate()
            .getFutureValue(type: Container.self)
            .map { container in Array(container.items.prefix(limit)) }
    }
}
