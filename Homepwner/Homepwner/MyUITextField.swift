//
//  MyUITextField.swift
//  Homepwner
//
//  Created by Laurent Boileau on 2017-05-31.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit

class MyUITextField: UITextField {

    override func becomeFirstResponder() -> Bool {
        self.borderStyle = .line
        return super.becomeFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        self.borderStyle = .roundedRect
        return super.resignFirstResponder()
    }

}
