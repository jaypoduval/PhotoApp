//
//  PhotoPresenterTests.swift
//  PhotoAppTests
//
//  Created by Jay Poduval on 10/12/18.
//  Copyright © 2018 Journalite LLC. All rights reserved.
//

import XCTest
@testable import PhotoApp

class PhotoViewMock:  NSObject, PhotoViewable {
    
    var titleText: String = ""
    var message: String = ""
    var activityAnimation: Bool = false
    var photos: [Photo] = []
    var photo: Photo?
    
    func showTitle(titleText: String) {
        self.titleText = titleText
    }
    
    func showMessage(message: String, activityAnimation: Bool) {
        self.message = message
        self.activityAnimation = activityAnimation
    }
    
    func showPhotos(photos: [Photo]) {
        self.photos = photos
    }
    
    func showPhoto(photo: Photo) {
        self.photo = photo
    }
    
    func showPhotoDetail(photo: Photo) {
        self.photo = photo
    }
}

class PhotoPresenterTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testShouldShowTitle() {
        
        //given
        let expectedTitle = "Flicker : Recents"
        let photoViewMock = PhotoViewMock()
        
        //when
        let photoPresenter = PhotoPresenter(photoViewMock)
        
        //verify
        XCTAssertTrue(photoViewMock.titleText == expectedTitle, "Title Should show")
    }
}
