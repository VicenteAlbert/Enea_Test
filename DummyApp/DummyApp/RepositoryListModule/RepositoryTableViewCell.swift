//
//  RepositoryTableViewCell.swift
//  DummyApp
//
//  Created by Vicentiu Petreaca on 20/10/2019.
//  Copyright © 2019 Vicentiu Petreaca. All rights reserved.
//

import UIKit
import AlamofireImage

class RepositoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ownerImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func configure(imageUrlString: String?, title: String, description: String?) {
        if let urlString = imageUrlString,
            let url = URL(string: urlString) {
            
            // we're using here the Alamofire's Image library to set the image of the imageview, leveraging that it has
            // builtin cache and also the fact that while the image loads, it'll show the placeholder image
            ownerImage.af_setImage(withURL: url, placeholderImage: UIImage(named: "no_img"))
        }
        titleLabel.text = title
        descriptionLabel.text = description
    }
}
