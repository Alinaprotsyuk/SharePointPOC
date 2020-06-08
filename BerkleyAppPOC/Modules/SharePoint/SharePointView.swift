//
//  SharePointView.swift
//  BerkleyAppPOC
//
//  Created by Alina Protsiuk on 5/29/19.
//  Copyright © 2019 CoreValue. All rights reserved.
//

import Foundation

protocol SharePointView: class {
    func success()
    func reload()
    func showError(_ message: String)
    func showActivity()
    func hideActivity()
    func setup(title: String)
    func createAccountView()
}
