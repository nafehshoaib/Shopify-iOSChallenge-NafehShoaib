//
//  ProductTableViewCell.swift
//  ShopifyTest
//
//  Created by Nafeh Shoaib on 2019-01-09.
//  Copyright © 2019 nafehshoaib. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var collectionLabel: UILabel!
    @IBOutlet weak var collectionBackground: UIView!
    @IBOutlet weak var collectionImageView: UIImageView!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var vendorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    public func setup(using product: Product) {
        var productTitle = product.title.components(separatedBy: " ")
        let collectionName = productTitle.removeFirst()
        let inventory = product.variants.map { $0.inventoryQuantity }.reduce(0, +)
        
        self.productLabel.text = productTitle.joined(separator: " ")
        self.collectionLabel.text = collectionName
        self.stockLabel.textColor = inventory <= 0 ? .red : UIColor(named: "StockGreen")
        self.stockLabel.text = String(inventory) + " in stock"
        self.collectionImageView.image = product.image
        self.priceLabel.text = "$" + String(format: "%.2f", product.minPrice)
        self.vendorLabel.text = "by " + product.vendor
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.autoresizesSubviews = false
        self.contentView.clipsToBounds = true
        self.imageView?.contentMode = .scaleAspectFill
    }
}
