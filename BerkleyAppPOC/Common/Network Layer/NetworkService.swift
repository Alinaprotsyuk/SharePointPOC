//
//  AuthManager.swift
//  BerkleyAppPOC
//
//  Created by Alina Protsiuk on 5/28/19.
//  Copyright © 2019 CoreValue. All rights reserved.
//

import Foundation

class NetworkService {
    fileprivate let jsonDecoder = JSONDecoder()
    fileprivate let networkManager: URLSessionProvider
    let authHelper: AuthHelper
    let storage = Defaults()
    let infoPlist: PlistManager
    var siteId = ""

    init() {
        infoPlist = PlistManager()
        authHelper = AuthHelper(infoPlist: infoPlist)
        networkManager = URLSessionProvider(authHelper)
    }
    
    func checkAcquireToken(completion: @escaping (_ success: Bool, _ error: String?) -> Void) {
        authHelper.acquireToken { (success, error) in
            completion(success, error)
        }
    }
}

extension NetworkService: NetworkServiceProtocol {
    private func getSiteId(completion: @escaping (String?) -> Void) {
        let point = SharePointApi.getSiteId
        let urlComponents = URLComponents(service: point, siteId: "", listId: "")
        
        let currentAccount = authHelper.currentAccount()
        
        let request = networkManager.setupReguest(httpMethod: point.httpMethod, url: urlComponents.url!, accessToken: currentAccount?.accessToken ?? "", parameters: nil)
        networkManager.createDataTask(for: request) { [weak self] (response) in
            switch response {
            case .success(let data):
                do {
                    if let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String],
                        let id = result["id"] {
                        self?.siteId = id
                        completion(nil)
                    } else {
                        completion("Can't parse data")
                    }
                } catch {
                    completion(error.localizedDescription)
                }
            case .failure(let error):
                completion(error)
            }
        }
    }
   
    func getInitialInfo(retry: Bool = true, completion: @escaping (DataSitesId?, [String : String]?, String?) -> Void) {
        getSiteId { [weak self] (error) in
            if let errorMessage = error {
                completion(nil, nil, errorMessage)
            } else {
                let point = SharePointApi.initialData
                let urlComponents = URLComponents(service: point, siteId: self?.siteId ?? "", listId: "")
                let currentAccount = self?.authHelper.currentAccount()
                
                let request = self!.networkManager.setupReguest(httpMethod: point.httpMethod, url: urlComponents.url!, accessToken: currentAccount?.accessToken ?? "", parameters: nil)
                self!.networkManager.createDataTask(for: request) { [weak self] (response) in
                    switch response {
                    case .success(let data):
                        do {
                            let result = try self?.jsonDecoder.decode(DataSitesId.self, from: data)
                            completion(result, [AccountCredential.name.rawValue: currentAccount?.userInformation?.givenName ?? "", AccountCredential.surname.rawValue : currentAccount?.userInformation?.familyName ?? ""], nil)
                        } catch {
                            completion(nil, nil, error.localizedDescription)
                        }
                    case .failure(let error):
                        completion(nil, nil, error)
                    }
                }
            }
        }
    }
    
    func getListOfItems(retry: Bool = true, completion: @escaping (GeneralList?, [String : String]?, String?) -> Void) {
        let point = SharePointApi.allItems
        let urlComponents = URLComponents(service: point, siteId: siteId, listId: infoPlist.getListId() ?? "")
        
        let currentAccount = authHelper.currentAccount()

        let request = networkManager.setupReguest(httpMethod: point.httpMethod, url: urlComponents.url!, accessToken: currentAccount?.accessToken ?? "", parameters: nil)
        networkManager.createDataTask(for: request) { [weak self] (response) in
            switch response {
            case .success(let data):
                do {
                    let result = try self?.jsonDecoder.decode(GeneralList.self, from: data)
                    completion(result, [AccountCredential.name.rawValue: currentAccount?.userInformation?.givenName ?? "", AccountCredential.surname.rawValue : currentAccount?.userInformation?.familyName ?? ""], nil)
                } catch {
                    completion(nil, nil, error.localizedDescription)
                }
            case .failure(let error):
                completion(nil, nil, error)
            }
            
        }
    }
    
    func createItem(retry: Bool = true, parameters: [String: Any], completion: @escaping (Item?, String?) -> Void) {
        let point = SharePointApi.createItem
        let urlComponents = URLComponents(service: point, siteId: siteId, listId: infoPlist.getListId() ?? "")
        
        let currentAccount = authHelper.currentAccount()
        
        let request = networkManager.setupReguest(httpMethod: point.httpMethod, url: urlComponents.url!, accessToken: currentAccount?.accessToken ?? "",  parameters: parameters)
        networkManager.createDataTask(for: request) { [weak self] (response) in
            switch response {
            case .success(let data):
                do {
                    let result = try self?.jsonDecoder.decode(Item.self, from: data)
                    completion(result, nil)
                } catch {
                    completion(nil, error.localizedDescription)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func editItem(retry: Bool = true, id: String, parameters: [String: Any], completion: @escaping ([String: Any]?, String?) -> Void ) {
        let point = SharePointApi.editItem(id: id)
        let urlComponents = URLComponents(service: point, siteId: siteId, listId: infoPlist.getListId() ?? "")
        
        let currentAccount = authHelper.currentAccount()
        
        let request = networkManager.setupReguest(httpMethod: point.httpMethod, url: urlComponents.url!, accessToken: currentAccount?.accessToken ?? "",  parameters: parameters)
        networkManager.createDataTask(for: request) { (response) in
            switch response {
            case .success(let data):
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any>
                    completion(result, nil)
                } catch {
                    completion(nil, error.localizedDescription)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
}

