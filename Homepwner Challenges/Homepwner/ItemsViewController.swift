//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by Laurent Boileau on 2017-05-17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {

    var itemStore: ItemStore!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Get tht height of the status bar
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets

        // Table view background image
        let backgroundImage = UIImageView(image: #imageLiteral(resourceName: "TableBackground"))
        tableView.backgroundView = backgroundImage
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let under50 = itemStore.items(under: 50)

        switch section {
        case 0: // under 50
            return under50.count
        case 1: // over 50
            return itemStore.allItems.count - under50.count
        case 2: // No more items!
            return 1
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Set the text on the cell with the description of the utem
        // that is at the nth index of items, where n = row this cell
        // will appear in on the tableview

        var item: Item?
        let priceAsc = { (lhs: Item, rhs: Item) -> Bool in
            return lhs.valueInDollars < rhs.valueInDollars
        }

        let under50 = itemStore.items(under: 50).sorted(by: priceAsc)
        let over50 = itemStore.items(over: 50).sorted(by: priceAsc)

        var cellIdentifier = "UITableViewCell"

        switch indexPath.section {
        case 0:
            item = under50[indexPath.row]
        case 1:
            item = over50[indexPath.row]
        default:
            cellIdentifier = "NoMoreCell"
            break;
        }

        // Get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        if let item = item {
            cell.textLabel?.text = item.name
            cell.detailTextLabel?.text = item.price
        } else {
            cell.textLabel?.text = "No more items!"
            cell.detailTextLabel?.text = ""
        }

        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection: Int) -> String? {
        switch titleForHeaderInSection {
        case 0:
            return "Under 50$"
        case 1:
            return "Over 50$"
        default:
            return nil
        }
    }

}
