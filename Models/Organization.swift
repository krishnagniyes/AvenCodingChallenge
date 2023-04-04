//
//  Organization.swift
//  AvenCodingChallenge
//
//  Created by Krishna Kumar on 4/3/23.
//

import Foundation

struct Organization: Decodable {
    let login: String
    let description: String?
    let avatar_url: String
    let repos_url: String
}
