//
//  StaticDataHelper.swift
//  BerkleyAppPOC
//
//  Created by Alina Protsiuk on 7/4/19.
//  Copyright © 2019 CoreValue. All rights reserved.
//

import Foundation

struct PlistManager {
    private var nsDictionary: NSDictionary?
    
    init() {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            nsDictionary = NSDictionary(contentsOfFile: path)
        }
    }
    
    func getAuthority() -> String? {
        return nsDictionary?[authority] as? String
    }
    
    func getClientID() -> String? {
        return nsDictionary?[clientId] as? String
    }
    
    func getRedirectURI() -> URL? {
        guard let stringURL = nsDictionary?[redirectURI] as? String else { return nil }
        return URL(string: stringURL)
    }
    
    func getBaseURL() -> String? {
        return nsDictionary?[baseURL] as? String
    }
    
    func getScope() -> String? {
        return nsDictionary?[_scope] as? String
    }
    
    func getListId() -> String?  {
        return nsDictionary?[listId] as? String
    }
    
}
