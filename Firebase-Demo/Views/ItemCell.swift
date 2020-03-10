//
//  ItemCell.swift
//  Firebase-Demo
//
//  Created by Tiffany Obi on 3/5/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit
import Kingfisher

class ItemCell: UITableViewCell {
    
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    @IBOutlet weak var itemNameLabel: UILabel!
    
    @IBOutlet weak var sellerNameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    
    public func configureCell(with item: Item) {
        
        itemImageView.kf.setImage(with: URL(string: item.imageURL))
        categoryNameLabel.text = item.catergoryName
        itemNameLabel.text = "Product:  \(item.itemName)"
        sellerNameLabel.text = "Seller: @\(item.sellerName)"
        let price = String(format: "%.2f", item.price)
        priceLabel.text = "Price - $\(price)"
        
    }
    
}
