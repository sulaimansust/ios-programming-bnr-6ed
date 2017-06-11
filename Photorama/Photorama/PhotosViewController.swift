//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Laurent Boileau on 2017-06-07.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import Foundation
import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate {

    @IBOutlet var collectionView: UICollectionView!

    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = photoDataSource
        collectionView.delegate = self

        updateDataSource()

        store.fetchInterestingPhotos { (photosResult) -> Void in
            self.updateDataSource()
        }
    }

    // MARK: - UICollectionViewDelegate methods

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photo = photoDataSource.photos[indexPath.row]

        // Download the image data, which could take some time
        store.fetchImage(for: photo) { (result) -> Void in
            // The index path for the photo might have changed between the
            // time the request started and finished, so find the most recent index path
            guard
                let photoIndex = self.photoDataSource.photos.index(of: photo),
                case let .success(image) = result
            else {
                return
            }
            let photoIndexPath = IndexPath(item: photoIndex, section: 0)
            // When the request finishes, only update the cell if it's still visible
            if let cell = self.collectionView.cellForItem(at: photoIndexPath) as? PhotoCollectionViewCell {
                cell.update(with: image)
            }
        }
    }

    // MARK: - Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showPhoto"?:
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                let photo = photoDataSource.photos[selectedIndexPath.row]
                let destinationVC = segue.destination as! PhotoInfoViewController

                destinationVC.photo = photo
                destinationVC.store = store
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }

    private func updateDataSource() {
        store.fetchAllPhotos { (photosResult) in
            switch photosResult {
            case let .success(photos):
                self.photoDataSource.photos = photos
            case .failure:
                self.photoDataSource.photos.removeAll()
            }
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }


}
