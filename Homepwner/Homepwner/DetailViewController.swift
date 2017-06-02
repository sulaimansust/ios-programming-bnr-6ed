//
//  DetailViewController.swift
//  Homepwner
//
//  Created by Laurent Boileau on 2017-05-19.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var nameField: UITextField!
    @IBOutlet var serialNumberField: UITextField!
    @IBOutlet var valueField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var removeImageButton: UIBarButtonItem!

    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    var imageStore: ImageStore!

    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    // MARK: - View life cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        nameField.text = item.name
        serialNumberField.text = item.serialNumber
        valueField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
        dateLabel.text = dateFormatter.string(from: item.dateCreated)

        // Get the item key
        let key = item.itemKey

        // If there's an associated image with the item
        // display it on the image view
        if let imageToDisplay = imageStore.image(forKey: key) {
            imageView.image = imageToDisplay
            removeImageButton.isEnabled = true
        } else {
            imageView.image = nil
            removeImageButton.isEnabled = false
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Clear first responder
        view.endEditing(true)

        // "Save" changes to item
        item.name = nameField.text ?? ""
        item.serialNumber = serialNumberField.text

        if let valueText = valueField.text,
           let value = numberFormatter.number(from: valueText) {
            item.valueInDollars = value.intValue
        } else {
            item.valueInDollars = 0
        }
    }

    // MARK: - UITextFieldDelegate methods

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // MARK: - Actions

    @IBAction func removePicture(_ sender: UIBarButtonItem) {
        imageView.image = nil
        imageStore.deleteImage(forKey: item.itemKey)
    }

    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()

        // If the device has a camera, take a picture; otherwise,
        // just pick from photo library

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.cameraOverlayView = { () -> UIView in
                let crossHairSize: CGFloat = 64.0
                let crossHairWidth: CGFloat = 1.0
                let center = CGPoint(x: super.view.frame.midX, y: super.view.frame.midY)

                let crossHairs = UIView(frame: CGRect(x: center.x - (crossHairSize / 2),
                                                      y: center.y - (crossHairSize / 2),
                                                      width: crossHairSize,
                                                      height: crossHairSize))
                crossHairs.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3)
                crossHairs.translatesAutoresizingMaskIntoConstraints = false
                crossHairs.layer.cornerRadius = crossHairSize / 2.0

                let horizontalLine = UIView(frame: CGRect(x: 0,
                                                          y: (crossHairSize / 2) - (crossHairWidth / 2),
                                                          width: crossHairSize,
                                                          height: crossHairWidth))
                horizontalLine.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                horizontalLine.translatesAutoresizingMaskIntoConstraints = false

                let verticalLine = UIView(frame: CGRect(x: (crossHairSize / 2) - (crossHairWidth / 2),
                                                        y: 0,
                                                        width: crossHairWidth,
                                                        height: crossHairSize))
                verticalLine.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                verticalLine.translatesAutoresizingMaskIntoConstraints = false
                
                crossHairs.addSubview(horizontalLine)
                crossHairs.addSubview(verticalLine)
                
                return crossHairs
            }()
        } else {
            imagePicker.sourceType = .photoLibrary
        }

        imagePicker.delegate = self

        // Allow editing
        imagePicker.allowsEditing = true

        // Place image picker on screen
        present(imagePicker, animated: true, completion: nil)
    }

    // MARK: - UIImagePickerControllerDelegate methods

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get picked image from info dictionary
        let image = info[UIImagePickerControllerEditedImage] as! UIImage

        // Store the image in the ImageStore for the item's key
        imageStore.setImage(image, forKey: item.itemKey)

        // Put that image on the screen in the image view
        imageView.image = image

        // Take image picker off screen - you must call this dismiss method 
        dismiss(animated: true, completion: nil)
    }
}
