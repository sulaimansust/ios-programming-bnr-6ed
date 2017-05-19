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

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
    }

    @IBAction func addNewItem(_ sender: UIButton) {
        // Create a new item and add it to the store
        let newItem = itemStore.createItem()

        // Figure out where that item is in the array
        if let index = itemStore.allItems.index(of: newItem) {
            let indexPath = IndexPath(row: index, section: 0)

            // Insert this new row into the table
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }

    @IBAction func toggleEditingMode(_ sender: UIButton) {
        if isEditing {
            // Change text of button to inform user of state
            sender.setTitle("Edit", for: .normal)

            // Turn off editing mode
            setEditing(false, animated: true)
        } else  {
            // Change text of button to inform user of state
            sender.setTitle("Done", for: .normal)

            // Enter editing mode
            setEditing(true, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // If the table view is asking to commit a delete command...
        if editingStyle == .delete {
            let item = itemStore.allItems[indexPath.row]

            let title = "Delete \(item.name)?"
            let message = "Are you sure you want to delete this item?"

            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)

            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
                // Remove the item from the store
                self.itemStore.removeItem(item)

                // Also remove that row from the table view with an animation
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            ac.addAction(deleteAction)

            // Present the alert controller
            present(ac, animated: true, completion: nil)
        }
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Update the model
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return itemStore.allItems.count
        default:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = indexPath.section == 0 ? "ItemCell" : "NoMoreItems"

        // Get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        if indexPath.section == 0 {
            // Set the text on the cell with the description of the utem
            // that is at the nth index of items, where n = row this cell
            // will appear in on the tableview
            let item = itemStore.allItems[indexPath.row]

            let itemCell = cell as! ItemCell

            itemCell.nameLabel.text = item.name
            itemCell.serialNumberLabel.text = item.serialNumber
            itemCell.valueLabel.text = item.price

            itemCell.valueLabel.textColor = item.valueInDollars < 50 ? #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1) : #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)

            return itemCell
        } else {
            cell.textLabel?.text = "No more items!"
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0
    }

    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            return sourceIndexPath
        }
        return proposedDestinationIndexPath
    }

}
