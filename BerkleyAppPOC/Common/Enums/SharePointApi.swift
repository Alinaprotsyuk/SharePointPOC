//
//  ApiCall.swift
//  BerkleyAppPOC
//
//  Created by Alina Protsiuk on 5/28/19.
//  Copyright © 2019 CoreValue. All rights reserved.
//

import Foundation

protocol SharePointProtocol {
    var baseURL: String { get }
    var path: String { get }
    var sites: String { get }
    var lists: String { get }
    var httpMethod: HTTPMethod { get }
}

enum SharePointApi: SharePointProtocol {
    case getSiteId
    case initialData
    case allItems
    case createItem
    case editItem(id: String)
    
    var baseURL: String {
        return "https://graph.microsoft.com/v1.0"
    }
    
    var sites: String {
        return "/sites"
    }
    
    var lists: String {
        return "/lists"
    }
    
    var path: String {
        switch self {
        case .getSiteId:
            return "ngkfcs.sharepoint.com:/sites/BerkPointDev?$select=id"
        case .initialData:
            return ""
        case .allItems:
            return "?expand=columns,items(expand=fields)"
            //"?expand=columns(select=readOnly,name,displayName,required),items(expand=fields)"
        case .createItem:
            return "/items"
        case .editItem(let id):
            return "/items/\(id)/fields"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .initialData, .getSiteId, .allItems:
            return .get
        case .createItem:
            return .post
        case .editItem:
            return .patch
        }
    }
}

