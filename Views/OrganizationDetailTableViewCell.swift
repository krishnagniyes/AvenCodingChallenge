//
//  OrganizationDetailTableViewCell.swift
//  AvenCodingChallenge
//
//  Created by Krishna Kumar on 4/2/23.
//

import UIKit

class OrganizationDetailTableViewCell: UITableViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var orgImageView: UIImageView!
    @IBOutlet private weak var linkTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

   
}

extension OrganizationDetailTableViewCell: OrganizationDetailTableViewCellProtocol {
    func configureCell(viewModel: OrganizationDetailViewModel) {
        self.nameLabel.text = viewModel.name
        self.descriptionLabel.text = viewModel.description
        self.linkTextView.text = viewModel.orgLink
        ImageDownloader.shared.downloadImage(url: viewModel.imageURL ?? "", completion: { [weak self] image in
            DispatchQueue.main.async {
                self?.orgImageView.image = image
            }
        })
    }
    
    
}
