//
//  PhotoCell.swift
//  PhotoApp
//
//  Created by Jay Poduval on 10/12/18.
//  Copyright © 2018 Journalite LLC. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure()
    }
    
    func configure() {
        activityIndicatorView.startAnimating()
        photoImageView.image = nil
    }
    
    func configure(_ photo: Photo) {
        if let imageToDisplay = photo.image {
            activityIndicatorView.stopAnimating()
            photoImageView.image = imageToDisplay
        }
    }
}
