//
//  HeaderCell.swift
//  PhotoApp
//
//  Created by Jay Poduval on 10/12/18.
//  Copyright © 2018 Journalite LLC. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {
    @IBOutlet var messageLabel: UILabel!
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
        activityIndicatorView.stopAnimating()
        messageLabel.text = ""
    }
    
    func configure(text: String?, activityAnimation: Bool) {
        
        activityAnimation ? activityIndicatorView.startAnimating(): activityIndicatorView.stopAnimating()
        
        if let text = text {
            activityIndicatorView.stopAnimating()
            messageLabel.text = text
        }
    }
}
