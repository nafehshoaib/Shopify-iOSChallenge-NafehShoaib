//
//  CustomCollection.swift
//  ShopifyTest
//
//  Created by Nafeh Shoaib on 2019-01-07.
//  Copyright © 2019 nafehshoaib. All rights reserved.
//

import UIKit
import SwiftyJSON

class CustomCollection {
    var id: Double!
    var title: String?
    var updatedAt: Date!
    var bodyHTML: String?
    var publishedAt: Date!
    var sortOrder: String!
    var adminGraphQL: String?
    var image: UIImage?
    
    init(id: Double, title: String, updatedAt: Date, bodyHTML: String, publishedAt: Date, sortOrder: String, adminGraphQL: String?, image: UIImage) {
        self.id = id
        self.title = title
        self.updatedAt = updatedAt
        self.bodyHTML = bodyHTML
        self.publishedAt = publishedAt
        self.sortOrder = sortOrder
        self.adminGraphQL = adminGraphQL
        self.image = image
    }
    
    convenience init(fromJSON json: JSON, withDateFormatter dateFormatter: DateFormatter) {
        self.init(
            id: json["id"].doubleValue,
            title: json["title"].stringValue,
            updatedAt: dateFormatter.date(
                from: json["updated_at"].stringValue
            )!,
            bodyHTML: json["body_html"].stringValue,
            publishedAt: dateFormatter.date(
                from: json["published_at"].stringValue
            )!,
            sortOrder: json["sort_order"].stringValue,
            adminGraphQL: json["admin_graphql_api_id"].stringValue,
            image: UIImage(
                fromUrl: json["image"]["src"].stringValue
            )
        )
    }
}
