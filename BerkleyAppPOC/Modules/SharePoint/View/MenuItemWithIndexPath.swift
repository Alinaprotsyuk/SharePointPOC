//
//  MenuItemWithIndexPath.swift
//  BerkleyAppPOC
//
//  Created by Alina Protsiuk on 6/19/19.
//  Copyright © 2019 CoreValue. All rights reserved.
//

import UIKit

class MenuItemWithIndexPath: UIMenuItem {
    var indexPath: IndexPath?
    
    init(title: String, action: Selector, indexPath: IndexPath) {
        super.init(title: title, action: action)
        self.indexPath = indexPath
    }
}
