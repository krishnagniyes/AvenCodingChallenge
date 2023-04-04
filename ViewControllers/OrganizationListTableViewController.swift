//
//  OrganizationListTableViewController.swift
//  AvenCodingChallenge
//
//  Created by Krishna Kumar on 4/2/23.
//

import UIKit

class OrganizationListTableViewController: UITableViewController {

    private var viewModel:OrganizationListViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = OrganizationListViewModel(apiClient: APIClient.shared)
        self.viewModel.delegate = self
        self.title = "Organizations"
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfOrganizations()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OrganizationDetailTableViewCell", for: indexPath) as? OrganizationDetailTableViewCell {
            if let org = viewModel.organizationAt(indexPath.row) {
                cell.configureCell(viewModel: org)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let org = viewModel.organizationAt(indexPath.row) else {
            return
        }

        if let name = org.name {
            let alert = UIAlertController(title: "Name: \(name)", message: "You clicked on \(name)'s repo!", preferredStyle: UIAlertController.Style.alert)
                 alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                 self.present(alert, animated: true, completion: nil)
        }
       
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension OrganizationListTableViewController: OrganizationListViewModelDelegate {
    func didStartFetchingOrganization() {
        
    }
    
    func didEndFetchingOrganizationWithSuccess() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didEndFetchingOrganizationWithFailure() {
        
    }
}
