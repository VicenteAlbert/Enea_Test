//
//  Models.swift
//  DummyApp
//
//  Created by Vicentiu Petreaca on 20/10/2019.
//  Copyright © 2019 Vicentiu Petreaca. All rights reserved.
//

struct Repository: Decodable {
    let name: String, desc: String?, owner: Owner, stars: Int
    
    private enum CodingKeys: String, CodingKey {
        case name, owner
        case desc = "description"
        case stars = "stargazers_count"
    }
}

struct Owner: Decodable {
    let avatarUrl: String?
    
    private enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
    }
}
