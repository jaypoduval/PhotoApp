//
//  PhotoViewController.swift
//  PhotoApp
//
//  Created by Jay Poduval on 10/12/18.
//  Copyright © 2018 Journalite LLC. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //  Variables
    fileprivate var photos: [Photo] = []
    fileprivate var selectedPhoto: Photo?
    fileprivate var headerMessage: String?
    fileprivate var activityAnimation: Bool = false
    fileprivate var photoPresenter: PhotoPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "PhotoDetailSegue") {
            if let controller = segue.destination as? PhotoDetailViewController {
                controller.photo = selectedPhoto
                controller.configure()
            }
        }
    }
    
    fileprivate func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        photoPresenter = PhotoPresenter(self)
        photoPresenter.fetchPhotos()
    }
}

extension PhotoViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath)
        let photo = photos[indexPath.row]
        photoPresenter.fetchPhoto(photo: photo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")
        
        if let headerCell = cell as? HeaderCell {
            headerCell.configure(text: headerMessage, activityAnimation: activityAnimation)
        }
        return cell
    }
}

extension PhotoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerMessage == nil ? 0.0 : 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let photo = photos[indexPath.row]
        photoPresenter.selectedPhoto = photo
    }
}

extension PhotoViewController: PhotoViewable {
    
    func showTitle(titleText: String) {
        self.title = titleText
    }
    
    func showMessage(message: String, activityAnimation: Bool) {
        self.activityAnimation = activityAnimation
        self.headerMessage = message
        self.tableView.reloadData()
    }
    
    func showPhotos(photos: [Photo]) {
        headerMessage = nil
        self.photos = photos
        self.tableView.reloadData()
    }
    
    func showPhoto(photo: Photo) {
        if let photoIndex = self.photos.index(of: photo) {
            
            let photoIndexPath = IndexPath(row: photoIndex, section: 0)
            
            if let photoCell = self.tableView.cellForRow(at: photoIndexPath) as? PhotoCell {
                photoCell.configure(photo)
            }
        }
    }
    
    func showPhotoDetail(photo: Photo) {
        selectedPhoto = photo
        performSegue(withIdentifier: "PhotoDetailSegue", sender: self)
    }
}
