//
//  NetworkResponse.swift
//  BerkleyAppPOC
//
//  Created by Alina Protsiuk on 6/3/19.
//  Copyright © 2019 CoreValue. All rights reserved.
//

import Foundation

enum NetworkResponse {
    case success(Data)
    case failure(String)
}
