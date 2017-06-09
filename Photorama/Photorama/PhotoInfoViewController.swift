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

    // MARK: - Properties

    var photo: Photo! {
        didSet {
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

}