//
//  DateViewController.swift
//  Homepwner
//
//  Created by Laurent Boileau on 2017-05-31.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit

class DateViewController: UIViewController {

    @IBOutlet var datePicker: UIDatePicker!

    var item: Item!

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        item.dateCreated = datePicker.date
    }


    
}
