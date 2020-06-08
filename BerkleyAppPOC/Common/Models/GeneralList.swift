//
//  GeneralList.swift
//  BerkleyAppPOC
//
//  Created by Alina Protsiuk on 6/12/19.
//  Copyright © 2019 CoreValue. All rights reserved.
//

import Foundation

struct GeneralList: Decodable {
    let odataContext : String?
    let odataEtag : String?
    let createdDateTime : String?
    let description : String?
    let eTag : String?
    let id : String?
    let lastModifiedDateTime : String?
    let name : String?
    let webUrl : String?
    let displayName : String?
    let createdBy : CreatedBy?
    let lastModifiedBy : LastModifiedBy?
    let parentReference : ParentReference?
    let list : List?
    let columnsOdataContext : String?
    let columns : [Column]?
    let itemsOdataContext : String?
    let items : [Item]?
    
    enum CodingKeys: String, CodingKey {
        
        case odataContext = "@odata.context"
        case odataEtag = "@odata.etag"
        case createdDateTime = "createdDateTime"
        case description = "description"
        case eTag = "eTag"
        case id = "id"
        case lastModifiedDateTime = "lastModifiedDateTime"
        case name = "name"
        case webUrl = "webUrl"
        case displayName = "displayName"
        case createdBy = "createdBy"
        case lastModifiedBy = "lastModifiedBy"
        case parentReference = "parentReference"
        case list = "list"
        case columnsOdataContext = "columns@odata.context"
        case columns = "columns"
        case itemsOdataContext = "items@odata.context"
        case items = "items"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        odataContext = try values.decodeIfPresent(String.self, forKey: .odataContext)
        odataEtag = try values.decodeIfPresent(String.self, forKey: .odataEtag)
        createdDateTime = try values.decodeIfPresent(String.self, forKey: .createdDateTime)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        eTag = try values.decodeIfPresent(String.self, forKey: .eTag)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        lastModifiedDateTime = try values.decodeIfPresent(String.self, forKey: .lastModifiedDateTime)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        webUrl = try values.decodeIfPresent(String.self, forKey: .webUrl)
        displayName = try values.decodeIfPresent(String.self, forKey: .displayName)
        createdBy = try values.decodeIfPresent(CreatedBy.self, forKey: .createdBy)
        lastModifiedBy = try values.decodeIfPresent(LastModifiedBy.self, forKey: .lastModifiedBy)
        parentReference = try values.decodeIfPresent(ParentReference.self, forKey: .parentReference)
        list = try values.decodeIfPresent(List.self, forKey: .list)
        columnsOdataContext = try values.decodeIfPresent(String.self, forKey: .columnsOdataContext)
        columns = try values.decodeIfPresent([Column].self, forKey: .columns)
        itemsOdataContext = try values.decodeIfPresent(String.self, forKey: .itemsOdataContext)
        items = try values.decodeIfPresent([Item].self, forKey: .items)
    }
    
}
