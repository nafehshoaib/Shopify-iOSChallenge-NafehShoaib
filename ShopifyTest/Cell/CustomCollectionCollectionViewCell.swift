//
//  CustomCollectionsCollectionViewCell.swift
//  ShopifyTest
//
//  Created by Nafeh Shoaib on 2019-01-08.
//  Copyright © 2019 nafehshoaib. All rights reserved.
//

import UIKit
import ViewAnimator

class CustomCollectionCollectionViewCell: UICollectionViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
        self.animate(animations: animations)
    }
    
    public func setup(using customCollection: CustomCollection) {
        self.backgroundColor = .white
        self.titleLabel.text = customCollection.title?.components(separatedBy: " ")[0]
        self.imageView.image = customCollection.image
    }
}
