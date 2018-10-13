//
//  PhotoPresenter.swift
//  PhotoApp
//
//  Created by Jay Poduval on 10/12/18.
//  Copyright © 2018 Journalite LLC. All rights reserved.
//

import Foundation


class PhotoPresenter {
    
    weak fileprivate var photoView : PhotoViewable!
    
    var selectedPhoto: Photo! {
        didSet {
            photoView.showPhotoDetail(photo: selectedPhoto)
        }
    }
    
    fileprivate var photoManager = PhotoManager()
    
    init(_ view: PhotoViewable){
        self.photoView = view
        self.photoView.showTitle(titleText: "Flicker : Recents")
        self.photoView.showMessage(message: "Loading...", activityAnimation: true)
    }
    
    // Get most recent photo list from remote server
    func fetchPhotos() {
    
        photoManager.fetchPhotos(){ (photoResult) -> Void in
            DispatchQueue.main.async {
                
                self.photoView.showMessage(message: "", activityAnimation: false)
                
                switch photoResult {
                case .success(let photoResult):
                    self.photoView.showPhotos(photos: photoResult)
                case .failure(let error):
                    self.photoView.showMessage(message: error.localizedDescription, activityAnimation: false)
                }
            }
        }
    }
    
    // Get most recent photo from remote server
    func fetchPhoto(photo: Photo) {
        photoManager.fetchImage(for: photo) { (result) in
            DispatchQueue.main.async {
                self.photoView.showPhoto(photo: photo)
            }
        }
    }
}

