//
//  Items.swift
//  BerkleyAppPOC
//
//  Created by Alina Protsiuk on 6/12/19.
//  Copyright © 2019 CoreValue. All rights reserved.
//

import Foundation

struct Item: Decodable {
    let odataEtag : String?
    let createdDateTime : String?
    let eTag : String?
    let id : String?
    let lastModifiedDateTime : String?
    let webUrl : String?
    let createdBy : CreatedBy?
    let lastModifiedBy : LastModifiedBy?
    let parentReference : ParentReference?
    let contentType : ContentType?
    let fieldsOdataContext : String?
    var fields: Dictionary<String, Any>
    
    enum CodingKeys: String, CodingKey {
        case odataEtag = "@odata.etag"
        case createdDateTime = "createdDateTime"
        case eTag = "eTag"
        case id = "id"
        case lastModifiedDateTime = "lastModifiedDateTime"
        case webUrl = "webUrl"
        case createdBy = "createdBy"
        case lastModifiedBy = "lastModifiedBy"
        case parentReference = "parentReference"
        case contentType = "contentType"
        case fieldsOdataContext = "fields@odata.context"
        case fields = "fields"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        odataEtag = try values.decodeIfPresent(String.self, forKey: .odataEtag)
        createdDateTime = try values.decodeIfPresent(String.self, forKey: .createdDateTime)
        eTag = try values.decodeIfPresent(String.self, forKey: .eTag)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        lastModifiedDateTime = try values.decodeIfPresent(String.self, forKey: .lastModifiedDateTime)
        webUrl = try values.decodeIfPresent(String.self, forKey: .webUrl)
        createdBy = try values.decodeIfPresent(CreatedBy.self, forKey: .createdBy)
        lastModifiedBy = try values.decodeIfPresent(LastModifiedBy.self, forKey: .lastModifiedBy)
        parentReference = try values.decodeIfPresent(ParentReference.self, forKey: .parentReference)
        contentType = try values.decodeIfPresent(ContentType.self, forKey: .contentType)
        fieldsOdataContext = try values.decodeIfPresent(String.self, forKey: .fieldsOdataContext)
        fields = try values.decode(Dictionary<String, Any>.self, forKey: .fields)
    }
}


