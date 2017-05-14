//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Laurent Boileau on 2017-05-13.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var celciusLabel: UILabel!
    @IBOutlet var textField: UITextField!

    var fahrenheitValue: Measurement<UnitTemperature>? {
        didSet {
            updateCelciusLabel()
        }
    }

    var celciusValue: Measurement<UnitTemperature>? {
        if let fahrenheitValue = fahrenheitValue {
            return fahrenheitValue.converted(to: .celsius)
        } else {
            return nil
        }
    }

    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()

    @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField) {
        if let text = textField.text, let value = Double(text) {
            fahrenheitValue = Measurement(value: value, unit: .fahrenheit)
        } else {
            fahrenheitValue = nil
        }
    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }

    func updateCelciusLabel() {
        if let celciusValue = celciusValue {
            celciusLabel.text = numberFormatter.string(from: NSNumber(value: celciusValue.value))
        } else {
            celciusLabel.text = "???"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateCelciusLabel()
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let existingTextHasDecimalSeperator = textField.text?.range(of: ".")
        let replacementTextHasDecimalSeperator = string.range(of: ".")

        for unicodeScalar in string.unicodeScalars {
            if CharacterSet.letters.contains(unicodeScalar) {
                return false
            }
        }

        if existingTextHasDecimalSeperator != nil, replacementTextHasDecimalSeperator != nil {
            return false
        } else {
            return true
        }
    }

}
