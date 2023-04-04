//
//  OrganizationListViewModel.swift
//  AvenCodingChallenge
//
//  Created by Krishna Kumar on 4/4/23.
//

import Foundation
protocol OrganizationListViewModelDelegate: AnyObject {
    func didStartFetchingOrganization()
    func didEndFetchingOrganizationWithSuccess()
    func didEndFetchingOrganizationWithFailure()
}

class OrganizationListViewModel {
    private var organizations: [OrganizationDetailViewModel] = []
    private let apiClient: APIClient
    weak var delegate: OrganizationListViewModelDelegate?
    init(apiClient: APIClient) {
        self.apiClient = apiClient
        fetchOrganizations()
    }
    
    private func fetchOrganizations() {
        APIClient.shared.fetchOrganizations { [weak self] res in
            switch res {
            case .failure(let err):
                print("Error occured \(err)")
                self?.delegate?.didEndFetchingOrganizationWithFailure()
            case .success(let list):
                self?.organizations = self?.processData(list) ?? []
                self?.delegate?.didEndFetchingOrganizationWithSuccess()
            }
        }
    }
    
    func numberOfOrganizations() -> Int {
        return organizations.count
    }
    
    func organizationAt(_ index: Int) -> OrganizationDetailViewModel? {
        guard organizations.count > index else {
            return nil
        }
        
        return organizations[index]
    }
    
    private func processData(_ list: [Organization]) -> [OrganizationDetailViewModel] {
        var organizations: [OrganizationDetailViewModel] = []
        for org in list {
            let viewModel = OrganizationDetailViewModel(name: org.login, description: org
                .description ?? "NA", imageURL: org.avatar_url, orgLink: "https://github.com/\(org.login)/")
            organizations.append(viewModel)
        }
        return organizations
    }
}
