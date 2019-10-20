//
//  DummyAppTests.swift
//  DummyAppTests
//
//  Created by Vicentiu Petreaca on 20/10/2019.
//  Copyright © 2019 Vicentiu Petreaca. All rights reserved.
//

import XCTest
import FutureKit

@testable import DummyApp

class RepositoryListPresenterTests: XCTestCase {
    func test_correctFetching() {
        let presenter = RepositoryListPresenter { _, _ -> Future<[Repository]> in
            let repositoryJSON =
            """
            {
                "name": "Mock",
                "description": "usefull description",
                "owner": {
                    "avatar_url": "https://avatar.com"
                },
                "stargazers_count": 123
            }
            """
            let repository = try! JSONDecoder().decode(Repository.self, from: repositoryJSON.data(using: .utf8)!)
            return .init(success: [repository])
        }
        presenter.fetchRepositories(limit: 0) { repos, err in
            XCTAssertNil(err)
            XCTAssertEqual(repos.count, 1)
            let repository = repos.first!
            XCTAssertEqual(repository.stars, 123)
            XCTAssertEqual(repository.name, "Mock")
            XCTAssertEqual(repository.desc, "usefull description")
            XCTAssertEqual(repository.owner.avatarUrl, "https://avatar.com")
        }
    }
    
    func test_errorIsReturned() {
        let presenter = RepositoryListPresenter { _, _ -> Future<[Repository]> in
            let error = NSError(domain: "test", code: 1, userInfo: nil)
            return .init(fail: error)
        }
        presenter.fetchRepositories(limit: 0) { _, err in
            XCTAssertNotNil(err)
            let nsErr = err! as NSError
            XCTAssertEqual(nsErr.domain, "test")
            XCTAssertEqual(nsErr.code, 1)
        }
    }
}
