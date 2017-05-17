//
//  ItemStore.swift
//  Homepwner
//
//  Created by Laurent Boileau on 2017-05-17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit

class ItemStore {

    var allItems = [Item]()

    init() {
        for _ in 0..<5 {
            createItem()
        }
    }

    @discardableResult func createItem() -> Item {
        let newItem = Item(random: true)
        allItems.append(newItem)
        return newItem
    }

}
