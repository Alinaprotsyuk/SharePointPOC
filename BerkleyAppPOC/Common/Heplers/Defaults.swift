//
//  Defaults.swift
//  BerkleyAppPOC
//
//  Created by Alina Protsiuk on 7/2/19.
//  Copyright © 2019 CoreValue. All rights reserved.
//

import Foundation

final class Defaults {
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    subscript(key: String) -> String? {
        get {
            return defaults.string(forKey: key)
        }
        
        set {
            defaults.set(newValue, forKey: key)
        }
    }
}
