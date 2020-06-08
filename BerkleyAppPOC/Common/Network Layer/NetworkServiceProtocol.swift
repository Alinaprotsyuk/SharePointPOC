//
//  NetworkView.swift
//  BerkleyAppPOC
//
//  Created by Alina Protsiuk on 5/28/19.
//  Copyright © 2019 CoreValue. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol: AnyObject {
    func getListOfItems(retry: Bool, completion: @escaping (GeneralList?, [String : String]?, String?) -> Void)
    func createItem(retry: Bool, parameters: [String: Any], completion: @escaping (Item?, String?) -> Void)
    func editItem(retry: Bool, id: String, parameters: [String: Any], completion: @escaping ([String: Any]?, String?) -> Void)
    func getInitialInfo(retry: Bool, completion: @escaping (DataSitesId?, [String : String]?, String?) -> Void)
    //func signOut()
}
