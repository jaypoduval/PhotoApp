//
//  Photo.swift
//  PhotoApp
//
//  Created by Jay Poduval on 10/12/18.
//  Copyright © 2018 Journalite LLC. All rights reserved.
//

import UIKit

class Photo: NSObject {
    
    var uniqueId = UUID().uuidString
    var imageUrl: URL?
    var image: UIImage?
    
    init(imageUrl: URL) {
        self.imageUrl = imageUrl
    }
}
