//
//  TagDataSource.swift
//  Photorama
//
//  Created by Laurent Boileau on 2017-06-12.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit
import CoreData

class TagDataSource: NSObject, UITableViewDataSource {

    var tags: [Tag] = []

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let tag = tags[indexPath.row]

        cell.textLabel?.text = tag.name

        cell.accessibilityHint = "Double tap to toggle selected"

        return cell
    }

}
