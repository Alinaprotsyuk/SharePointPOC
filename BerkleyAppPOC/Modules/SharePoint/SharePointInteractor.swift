//
//  SharePointInteractor.swift
//  BerkleyAppPOC
//
//  Created by Alina Protsiuk on 5/29/19.
//  Copyright © 2019 CoreValue. All rights reserved.
//

import Foundation

class SharePointInteractor {
    let networkManager: NetworkService
    unowned let mainQueue = DispatchQueue.main
    
    init(networkManager: NetworkService) {
        self.networkManager = networkManager
    }
    
    func getAllItems(completion: @escaping (GeneralList?, [String: String]?, String?) -> Void) {
        networkManager.getListOfItems { [weak self] (result, data, error) in
            self?.mainQueue.async {
                completion(result, data, error)
            }
        }
    }
    
    func signOut() {
        //networkManager.signOut()
    }
    
    func getInitialInfo(completion: @escaping (DataSitesId?, [String: String]?, String?) -> Void) {
        if networkManager.authHelper.currentAccount()?.accessToken == nil {
            networkManager.checkAcquireToken { [weak self] (success, error) in
                if success {
                    self?.getInitialData(completion: { (data, accountData, error) in
                        completion(data, accountData, error)
                    })
                }
                if let errorMessage = error {
                    completion(nil, nil, errorMessage)
                }
            }
        } else {
            getInitialData(completion: { [weak self] (data, accountData, error) in
                self?.mainQueue.async {
                    completion(data, accountData, error)
                }
            })
        }
    }
    
    private func getInitialData(completion: @escaping (DataSitesId?, [String: String]?, String?) -> Void) {
        networkManager.getInitialInfo() { [weak self] (data, accountData, error) in
            self?.mainQueue.async {
                completion(data, accountData, error)
            }
        }
    }
    
//    func editItem(id: String, parameters: [String: String], complition: @escaping (Fields?, String?) -> Void) {
//        networkManager.editItem(id: id, parameters: parameters, completion: { [weak self] (result, error) in
//            self?.mainQueue.async {
//                complition(result, error)
//            }
//        })
//    }
//    
//    func createItem(parameters: [String: Any], complition: @escaping (ValueItem?, String?) -> Void) {
//        networkManager.createItem(parameters: parameters, completion: { [weak self] (result, error) in
//            self?.mainQueue.async {
//                complition(result, error)
//            }
//        })
//    }
}

