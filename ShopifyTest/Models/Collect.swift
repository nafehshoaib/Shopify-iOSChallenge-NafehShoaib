//
//  Product.swift
//  ShopifyTest
//
//  Created by Nafeh Shoaib on 2019-01-08.
//  Copyright © 2019 nafehshoaib. All rights reserved.
//

import UIKit
import SwiftyJSON

class Collect {
    var id: Double!
    var productID: Double
    var featured: Bool
    var createdAt: Date
    var updatedAt: Date
    var position: Double
    var sortValue: String
    
    init(id: Double, productID: Double, featured: Bool, createdAt: Date, updatedAt: Date, position: Double, sortValue: String) {
        self.id = id
        self.productID = productID
        self.featured = featured
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.position = position
        self.sortValue = sortValue
    }
    convenience init(from json: JSON, withDateFormatter dateFormatter: DateFormatter) {
        self.init(
            id: json["id"].doubleValue,
            productID: json["product_id"].doubleValue,
            featured: json["featured"].boolValue,
            createdAt: dateFormatter.date(
                from: json["created_at"].stringValue
            )!,
            updatedAt: dateFormatter.date(
                from: json["updated_at"].stringValue
            )!,
            position: json["position"].doubleValue,
            sortValue: json["sort_value"].stringValue
        )
    }
}
