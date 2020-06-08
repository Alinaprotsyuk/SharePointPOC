//
//  EditViewProtocol.swift
//  BerkleyAppPOC
//
//  Created by Alina Protsiuk on 5/28/19.
//  Copyright © 2019 CoreValue. All rights reserved.
//

import Foundation

protocol EditView: class {
    func didReceiveEditedItemFileds(_ item: Dictionary<String, Any>)
    func didReceiveNewItemFileds(_ item: Item)
    func showErrorMessage(_ text: String)
    func showActivity()
    func hideActivity()
}
