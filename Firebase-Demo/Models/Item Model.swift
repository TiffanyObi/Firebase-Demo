//
//  Item Model.swift
//  Firebase-Demo
//
//  Created by Tiffany Obi on 3/2/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import Foundation

struct Item {
    let itemName: String
    let price: Double
    let itemID : String // document ID
    let listedDate: Date
    let sellerName: String
    let sellerID : String
    let catergoryName: String
    let imageURL: String
}

extension Item {
    
    init(_ dictionary: [String: Any]) {
         self.itemName = dictionary["itemName"] as? String ?? "no name"
         self.price = dictionary["price"] as? Double ?? 0.0
        self.itemID = dictionary["itemId"] as? String ?? "no id"
        self.listedDate = dictionary["listedDate"] as? Date ?? Date()
         self.sellerName = dictionary["sellerName"] as? String ?? "no seller name"
         self.sellerID = dictionary["sellerId"] as? String ?? "no seller ID"
        self.catergoryName = dictionary["categoryName"] as? String ?? "no catergory name"
        self.imageURL = dictionary["imageURL"] as? String ?? "no image"
    }
    

}
