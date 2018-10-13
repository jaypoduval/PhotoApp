//
//  PhotoViewable.swift
//  PhotoApp
//
//  Created by Jay Poduval on 10/12/18.
//  Copyright © 2018 Journalite LLC. All rights reserved.
//

import Foundation

protocol PhotoViewable: NSObjectProtocol {
    
    func showTitle(titleText: String)
    
    func showMessage(message: String, activityAnimation: Bool)
    
    func showPhotos(photos: [Photo])
    
    func showPhoto(photo: Photo) 
    
    func showPhotoDetail(photo: Photo)
}
