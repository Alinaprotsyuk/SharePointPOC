//
//  EditViewInteractor.swift
//  BerkleyAppPOC
//
//  Created by Alina Protsiuk on 5/29/19.
//  Copyright © 2019 CoreValue. All rights reserved.
//

import Foundation

class EditViewInteractor {
    let networkManager: NetworkService
    unowned let mainQueue = DispatchQueue.main
    
    init(networkManager: NetworkService) {
        self.networkManager = networkManager
    }
    
    func prepare(id: String?, parameters: [String: String], complition: @escaping (Any?, String?) -> Void) {
        if let id = id {
            editItem(id: id, parameters: parameters) { [weak self] (result, error) in
                self?.mainQueue.async {
                    complition(result, error)
                }
            }
        } else {
            createItem(parameters: parameters) { [weak self] (result, error) in
                self?.mainQueue.async {
                    complition(result, error)
                }
            }
        }
    }
    
    private func editItem(id: String, parameters: [String: String], complition: @escaping ([String: Any]?, String?) -> Void) {
        networkManager.editItem(id: id, parameters: parameters, completion: { [weak self] (result, error) in
            self?.mainQueue.async {
                complition(result, error)
            }
        })
    }
    
    private func createItem(parameters: [String: Any], complition: @escaping (Item?, String?) -> Void) {
        networkManager.createItem(parameters: ["fields": parameters], completion: { [weak self] (result, error) in
            self?.mainQueue.async {
                complition(result, error)
            }
        })
    }
}
