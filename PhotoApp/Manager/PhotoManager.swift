//
//  PhotoManager.swift
//  PhotoApp
//
//  Created by Jay Poduval on 10/12/18.
//  Copyright © 2018 Journalite LLC. All rights reserved.
//

import UIKit


class PhotoManager: NSObject {
    
    let cache = NSCache<AnyObject, AnyObject>()
    
    // Constants
    enum PhotoConstants: String {
        case apiKey = "fee10de350d1f31d5fec0eaf330d2dba" 
        case baseUrl = "https://api.flickr.com/services/rest"
        case recentUrl = "flickr.photos.getRecent"
        case perPage = "100"
    }
    
    // Handle Image Success/Failure
    enum ImageResult{
        case success(UIImage)
        case failure(Error)
    }
    
    // Handle Photo Success/Failure
    enum PhotoResult {
        case success([Photo])
        case failure(Error)
    }
    
    // Handle JSON/Image Error
    enum PhotoError: Error {
        case JSONError
        case imageError
    }
    
    // default NSURLSession
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    // Construct URL with components
    fileprivate func apiURL()-> URL {
        var components = URLComponents(string: PhotoConstants.baseUrl.rawValue)!
        
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "method", value:  PhotoConstants.recentUrl.rawValue))
        queryItems.append(URLQueryItem(name: "format", value: "json"))
        queryItems.append(URLQueryItem(name: "nojsoncallback", value: "1"))
        queryItems.append(URLQueryItem(name: "api_key", value: PhotoConstants.apiKey.rawValue))
        queryItems.append(URLQueryItem(name: "per_page", value: PhotoConstants.perPage.rawValue))
        components.queryItems = queryItems
        
        return components.url!
    }
    
    //Asynchronous call to fetch flicker recent json
    func fetchPhotos(completion: @escaping (PhotoResult) -> Void) {
        
        let url = self.apiURL()
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            // completion closure to call when the request finishes
            let result = self.processJson(data: data, error: error)
            completion(result)
        })
        
        // resume from default suspended state
        task.resume()
    }
    
    //process the API Response data
    func processJson(data: Data? , error: Error?)-> PhotoResult {
        
        //validate response data before processing
        guard let jsonData = data else {
            return .failure(error!)
        }
        
        do {
            
            let jsonObject: Any = try JSONSerialization.jsonObject(with: jsonData, options: [])
            
            //validate json object
            guard let
                jsonDictionary = jsonObject as? [AnyHashable: Any],
                let photoDictionary = jsonDictionary["photos"] as? [String:AnyObject],
                let photosArray = photoDictionary["photo"] as? [[String: AnyObject]] else {
                    return .failure(PhotoError.JSONError)
            }
            
            //Parse photo object
            var photos = [Photo]()
            for photoDictionary in photosArray {
                guard let id = photoDictionary["id"] as? String,
                    let secret = photoDictionary["secret"] as? String,
                    let server = photoDictionary["server"] as? String else {
                        continue
                }
                
                let urlText = "https://farm6.staticflickr.com/\(server)/\(id)_\(secret).jpg"
                if let imageUrl = URL(string: urlText) {
                    let photo = Photo(imageUrl:imageUrl)
                    photos.append(photo)
                }
            }
            
            return .success(photos)
        }
        catch let error {
            return .failure(error)
        }
    }
    
    
    //Asynchronous call to fetch flicker recent json
    func fetchImage(for photo: Photo, completion: @escaping (ImageResult) -> Void) {
        
        //get cached image if available
        if let image = self.image(for: photo.uniqueId) {
            photo.image = image
            completion(.success(image))
            return
        }
        
        guard let imageUrl = photo.imageUrl else {
            completion(.failure(PhotoError.imageError))
            return
        }
        
        let request = URLRequest(url: imageUrl as URL)
        
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            let result = self.processImage(data: data, error: error as NSError?)
            
            // Can use an if case statement to check wether result has a value of .Success
            // Similar to a switch case with a break under the .Failure case
            if case let .success(image) = result {
                photo.image = image
                self.setImage(image, for: photo.uniqueId)
            }
            
            completion(result)
        })
        
        task.resume()
    }
    
    //process the API Response data for Image
    func processImage(data: Data?, error: NSError?) -> ImageResult {
        
        guard let
            imageData = data,
            let image = UIImage(data:imageData) else {
                //handle error
                if data == nil {
                    return .failure(error!)
                }
                else {
                    return .failure(PhotoError.imageError)
                }
        }
        return .success(image)
    }
    
    // Cache the image
    func setImage(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: key as AnyObject)
        
        // Create full URL for image
        let imageUrl = localImageUrl(for: key)
        
        //cache to disk
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            
            try? imageData.write(to: imageUrl, options: [.atomic])
        }
    }
    
    // Get cached  image
    func image(for key: String) -> UIImage? {
        if let existingImage = cache.object(forKey: key as AnyObject) as? UIImage {
            return existingImage
        }
        
        let imageURL = localImageUrl(for: key)
        guard let imagefromDisk = UIImage(contentsOfFile: imageURL.path) else {
            return nil
        }
        
        cache.setObject(imagefromDisk, forKey: key as AnyObject)
        return imagefromDisk
    }
    
    // Get local cach image file url
    func localImageUrl(for key: String) -> URL {
        let documentsDirectories = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        
        return documentDirectory.appendingPathComponent(key)
    }
    
}
