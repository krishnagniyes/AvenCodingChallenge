//
//  APIClient+GetOrganizationList.swift
//  AvenCodingChallenge
//
//  Created by Krishna Kumar on 4/3/23.
//

import Foundation

import Foundation
let kBaseURL = "https://api.github.com/organizations"
extension APIClient {
    func fetchOrganizations(result: @escaping (Result<[Organization], APIServiceError>) -> Void) {
        // We may pass different paramters/more as a QueryItem
        let url = URL(string: "\(kBaseURL)")
        sendRequest(url: url!, completion: result)
    }
}
