/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation

struct DataSitesId : Codable {
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
	}

}
