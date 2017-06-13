//
//  PhotoInfoViewController.swift
//  Photorama
//
//  Created by Laurent Boileau on 2017-06-09.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit

class PhotoInfoViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet var imageView: UIImageView!

    @IBOutlet var favoriteItem: UIBarButtonItem!

    // MARK: - Properties

    var photo: Photo! {
        didSet {
            favoriteItem.title = getFavoriteBarButtonTitle(for: photo)
            navigationItem.title = photo.title
        }
    }

    var store: PhotoStore!

    override func viewDidLoad() {
        super.viewDidLoad()

        store.fetchImage(for: photo) { (result) -> Void in
            switch result {
            case let .success(image):
                self.imageView.image = image
            case let .failure(error):
                print("Error fetching image for photo: \(error)")
            }
        }
    }

    func getFavoriteBarButtonTitle(for photo: Photo) -> String {
        return (photo.favorite) ? "♥︎" : "♡"
    }

    @IBAction func favoriteToggled(_ sender: UIBarButtonItem) {
        photo.favorite = !photo.favorite

        do {
            try store.persistantContainer.viewContext.save()
        } catch {
            print("Core Data save failed: \(error).")
            return
        }

        favoriteItem.title = getFavoriteBarButtonTitle(for: photo)
    }

    // MARK: - Storyboard segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showTags"?:
            let navController = segue.destination as! UINavigationController
            let tagController = navController.topViewController as! TagsViewController

            tagController.store = store
            tagController.photo = photo
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }

}
