//
//  ProductCollectionTableViewCell.swift
//  ShopifyTest
//
//  Created by Nafeh Shoaib on 2019-01-09.
//  Copyright © 2019 nafehshoaib. All rights reserved.
//

import UIKit

class ProductCollectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionImageView: UIImageView!
    @IBOutlet weak var collectionLabel: UILabel!
    @IBOutlet weak var collectionDescription: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setup(usingCustomCollection customCollection: CustomCollection) {
        self.collectionLabel.text = "The " + customCollection.title!.components(separatedBy: " ")[0] + " Collection"
        self.collectionDescription.text = customCollection.bodyHTML
        self.collectionImageView.image = customCollection.image!
    }

}
