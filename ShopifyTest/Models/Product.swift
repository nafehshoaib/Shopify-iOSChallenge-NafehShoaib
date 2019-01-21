//
//  Product.swift
//  ShopifyTest
//
//  Created by Nafeh Shoaib on 2019-01-08.
//  Copyright © 2019 nafehshoaib. All rights reserved.
//

import UIKit
import SwiftyJSON

class Product {
    var id: Double
    var title: String
    var bodyHTML: String
    var vendor: String
    var productType: String
    var handle: String
    
    var createdAt: Date
    var updatedAt: Date
    var publishedAt: Date
    
    var tags: [String]
    var adminGraphQL: String
    
    var variants: [Variant]
    
    var image: UIImage
    
    var minPrice: Double {
        return variants.min { a, b in a.price < b.price }!.price
    }
    
    init(id:Double, title: String, bodyHTML: String, vendor: String, productType: String, handle: String, createdAt: Date, updatedAt: Date, publishedAt: Date, tags: [String], adminGraphQL: String, variants: [Variant], image: UIImage) {
        self.id = id
        self.title = title
        self.bodyHTML = bodyHTML
        self.vendor = vendor
        self.productType = productType
        self.handle = handle
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.publishedAt = publishedAt
        self.tags = tags
        self.adminGraphQL = adminGraphQL
        self.variants = variants
        self.image = image
    }
    
    convenience init(fromJSON json: JSON, withDateFormatter dateFormatter: DateFormatter) {
        self.init(
            id: json["id"].doubleValue,
            title: json["title"].stringValue,
            bodyHTML: json["body_html"].stringValue,
            vendor: json["vendor"].stringValue,
            productType: json["product_type"].stringValue,
            handle: json["handle"].stringValue,
            createdAt: dateFormatter.date(
                from: json["created_at"].stringValue
            )!,
            updatedAt: dateFormatter.date(
                from: json["updated_at"].stringValue
            )!,
            publishedAt: dateFormatter.date(
                from: json["published_at"].stringValue
            )!,
            tags: json["tags"].stringValue.components(separatedBy: ", "),
            adminGraphQL: json["admin_graphql_api_id"].stringValue,
            variants: json["variants"].map {
                Variant(fromJSON: $1)
            },
            image: UIImage(
                fromUrl: json["image"]["src"].stringValue
            )
        )
    }
}

class Variant {
    var id: Double
    var title: String
    var price: Double
    var sku: String?
    var position: Double
    var inventoryQuantity: Int
    var requiresShipping: Bool
    
    init(id: Double, title: String, price: Double, sku: String, position: Double, inventoryQuantity: Int, requiresShipping: Bool) {
        self.id = id
        self.title = title
        self.price = price
        self.sku = sku
        self.position = position
        self.inventoryQuantity = inventoryQuantity
        self.requiresShipping = requiresShipping
    }
    
    convenience init(fromJSON json: JSON) {
        self.init(
            id: json["id"].doubleValue,
            title: json["title"].stringValue,
            price: json["price"].doubleValue,
            sku:  json["sku"].stringValue,
            position: json["position"].doubleValue,
            inventoryQuantity: json["inventory_quantity"].intValue,
            requiresShipping: json["requires_shipping"].boolValue
        )
    }
}
