//
//  Extension URLComponents.swift
//  BerkleyAppPOC
//
//  Created by Alina Protsiuk on 6/3/19.
//  Copyright © 2019 CoreValue. All rights reserved.
//

import Foundation

extension URLComponents {
    init(service: SharePointProtocol, siteId: String, listId: String) {
        if listId != "" {
            let url = URL(string: service.baseURL + service.sites + "/" + siteId + service.lists + listId + service.path)
            self.init(url: url!, resolvingAgainstBaseURL: true)!
        } else {
            let url = URL(string: service.baseURL + service.sites + "/" + siteId + service.path)
            self.init(url: url!, resolvingAgainstBaseURL: true)!
        }
    }
}
