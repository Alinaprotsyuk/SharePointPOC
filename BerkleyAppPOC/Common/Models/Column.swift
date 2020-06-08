//
//  Columns.swift
//  BerkleyAppPOC
//
//  Created by Alina Protsiuk on 6/12/19.
//  Copyright © 2019 CoreValue. All rights reserved.
//

import UIKit

struct Column: Codable {
    let displayName : String?
    let name : String?
    let readOnly : Bool?
    let required: Bool?
    var width: CGFloat = 0
    let text: TextualType?
    let number: NumericType?
    
    enum CodingKeys: String, CodingKey {
        case displayName = "displayName"
        case name = "name"
        case readOnly = "readOnly"
        case required = "required"
        case text = "text"
        case number = "number"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        displayName = try values.decodeIfPresent(String.self, forKey: .displayName)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        readOnly = try values.decodeIfPresent(Bool.self, forKey: .readOnly)
        required = try values.decodeIfPresent(Bool.self, forKey: .required)
        text = try values.decodeIfPresent(TextualType.self, forKey: .text)
        number = try values.decodeIfPresent(NumericType.self, forKey: .number)
    }
    
}

struct TextualType: Codable {
    let allowMultipleLines: Bool?
    let appendChangesToExistingText: Bool?
    let linesForEditing: Int?
    let maxLength: Int?
    let textType: String?
}

struct NumericType: Codable {
    let decimalPlaces: String?
    let displayAs: String?
    let maximum: Double?
    let minimum: Double?
}
