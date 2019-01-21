//
//  Services.swift
//  ShopifyTest
//
//  Created by Nafeh Shoaib on 2019-01-08.
//  Copyright © 2019 nafehshoaib. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

/** Helper class to handle API Calls to Shopify HTTP Endpoint. */
class Services {
    // Static constants for Shopify API
    private static let ACCESS_TOKEN = "c32313df0d0ef512ca64d5b336a0d7c6"
    private static let CUSTOM_COLLECTIONS_URL = "https://shopicruit.myshopify.com/admin/custom_collections.json"
    private static let COLLECTS_URL = "https://shopicruit.myshopify.com/admin/collects.json"
    private static let PRODUCT_URL = "https://shopicruit.myshopify.com/admin/products.json"
    
    private let dateFormatter = DateFormatter(isShopify: true)
    
    /** Calls the Custom Collection Shopify API and returns the CustomCollection array in completion handler. */
    public func getCustomCollections(completion: @escaping (Result<[CustomCollection]>) -> Void) {
        // Parameters that include the access token that is to be sent to the API
        let params: Parameters = [
            "access_token": Services.ACCESS_TOKEN
        ]
        // Send HTTP Get Request for CustomCollections using Alamofire, passing in URL and parameters.
        Alamofire.request(Services.CUSTOM_COLLECTIONS_URL, parameters: params).responseJSON { response in
            // Safeley unwrap the response's result's value property, in case is ends up nil
            if let value = response.result.value {
                // Get an array of CustomCollection by wrapping the value in JSON, using Swifty JSON, accessing relevant key in
                // said json, and creating an array using each sub-json in said json using swift's map function
                // and a custom Model for CustomCollection
                let customCollections = JSON(value)["custom_collections"].map {
                    CustomCollection(fromJSON: $1, withDateFormatter: self.dateFormatter)
                }
                
                // Send the completion result using Grand Central Dispatch, to be used with the completion handler
                DispatchQueue.main.async {
                    completion(Result.success(customCollections))
                }
            }
        }
    }
    
    /*** Similar logic to getCustomCollections() used in functions below. ***/
    
    /** Calls the Collects Shopify API and returns the Collects Array in completion handler. */
    public func getCollects(for id: Double, completion: @escaping (Result<[Collect]>) -> Void) {
        let params: Parameters = [
            "collection_id": id,
            "access_token": Services.ACCESS_TOKEN
        ]
        Alamofire.request(Services.COLLECTS_URL, parameters: params).responseJSON { response in
            if let value = response.result.value {
                // Sends in the dateFormatter to correctly format json properties that are dates
                let collects = JSON(value)["collects"].map { Collect(from: $1, withDateFormatter: self.dateFormatter) }
                
                DispatchQueue.main.async {
                    completion(Result.success(collects))
                }
            }
        }
    }
    
    /** Calls the Products Shopify API and returns the Products array in completion handler. */
    public func getProducts(withProductIDs ids:[Int], completion: @escaping (Result<[Product]>) -> Void) {
        // Creat a string with comma separated id's by first using Swift's map method to create a String array
        // and then joining them by using the String class's joined method, passing in the desired separator
        let idString = ids.map { String($0) }.joined(separator: ",")
        
        let params: Parameters = [
            "ids": idString,
            "access_token": Services.ACCESS_TOKEN
        ]
        
        Alamofire.request(Services.PRODUCT_URL, parameters: params).responseJSON { response in
            if let value = response.result.value {
                let products = JSON(value)["products"].map { Product(fromJSON: $1, withDateFormatter: self.dateFormatter) }
                
                DispatchQueue.main.async {
                    completion(Result.success(products))
                }
            }
        }
    }
}

// MARK: Extensions that help to create the required instances of classes
extension DateFormatter {
    /** Creates a DateFormatter that works with the date fields provided in the Shopify API. */
    convenience init(isShopify: Bool) {
        // Call parent
        self.init()
        if isShopify {
            self.locale = Locale(identifier: "en_US_POSIX")
            self.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            self.timeZone = TimeZone(secondsFromGMT: 0)
        }
    }
}

extension UIImage {
    /** Creates a UIImage from a URL String that downloads from the web and sets its image. */
    convenience init(fromUrl url: String) {
        // Creates URL using url String
        let imageURL = URL(string: url)
        // Tries to download data from the contents of said url
        let imageData = try? Data(contentsOf: imageURL!)
        // checks if returned data is not nil, creating the UIImage using said data, otherwise, creating a generic UIImage
        if imageData != nil {
            self.init(data: imageData!)!
        } else {
            self.init()
        }
    }
}
