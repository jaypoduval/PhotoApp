//
//  PhotoDetailViewController.swift
//  PhotoApp
//
//  Created by Jay Poduval on 10/12/18.
//  Copyright © 2018 Journalite LLC. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    @IBOutlet weak var photoView: UIImageView!
    
    var photo: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    func configure() {
        if photoView != nil {
            photoView.image = photo?.image
        }
    }
}
