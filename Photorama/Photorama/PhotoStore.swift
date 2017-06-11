//
//  PhotoStore.swift
//  Photorama
//
//  Created by Laurent Boileau on 2017-06-07.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit
import CoreData

enum ImageResult {
    case success(UIImage)
    case failure(Error)
}

enum PhotoError: Error {
    case imageCreationError
}

enum PhotosResult {
    case success([Photo])
    case failure(Error)
}

class PhotoStore {

    let imageStore = ImageStore()

    let persistantContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Photorama")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error setting up Core Data (\(error)).")
            }
        }
        return container
    }()

    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()

    func fetchImage(for photo: Photo, completion: @escaping (ImageResult) -> Void) {

        // Hit cache first
        guard let photoKey = photo.photoID else {
            preconditionFailure("Photo expected to hava a photoID.")
        }

        if let image = imageStore.image(forKey: photoKey) {
            OperationQueue.main.addOperation {
                completion(.success(image))
            }
            return
        }

        guard let photoURL = photo.remoteURL else {
            preconditionFailure("Photo expected to hava a remote URL.")
        }

        let request = URLRequest(url: photoURL as URL)

        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            let result = self.processImageRequest(data: data, error: error)

            // Store in cache
            if case let .success(image) = result {
                self.imageStore.setImage(image, forKey: photo.photoID!)
            }

            OperationQueue.main.addOperation {
                completion(result)
            }
        }

        task.resume()
    }

    func fetchInterestingPhotos(completion: @escaping (PhotosResult) -> Void) {
        let url = FlickrAPI.interestingPhotosURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) -> Void in
            var result = self.processPhotosRequest(data: data, error: error)
            if case .success = result {
                do {
                    try self.persistantContainer.viewContext.save()
                } catch let error {
                    result = .failure(error)
                }
            }
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }

    func fetchAllPhotos(completion: @escaping (PhotosResult) -> Void) {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let sortByDateTaken = NSSortDescriptor(key: #keyPath(Photo.dateTaken), ascending: false)

        fetchRequest.sortDescriptors = [sortByDateTaken]

        let viewContext = persistantContainer.viewContext

        viewContext.perform {
            do {
                let allPhotos = try viewContext.fetch(fetchRequest)
                completion(.success(allPhotos))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func incrementViewCount(for photo: Photo) {
        let viewContext = persistantContainer.viewContext

        viewContext.performAndWait {
            photo.viewCount += 1
        }

        do {
            try viewContext.save()
        } catch let error {
            print("Failed to increment view count. Error: \(error)")
        }
    }

    private func processImageRequest(data: Data?, error: Error?) -> ImageResult {
        guard
            let imageData = data,
            let image = UIImage(data: imageData)
        else {
            if data == nil {
                return .failure(error!)
            } else {
                return .failure(PhotoError.imageCreationError)
            }
        }

        return .success(image)
    }

    private func processPhotosRequest(data: Data?, error: Error?) -> PhotosResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        return FlickrAPI.photos(fromJSON: jsonData, into: persistantContainer.viewContext)
    }

}
