//
//  ProductCollectionViewCell.swift
//  Shoppy
//
//  Created by EGEMEN AYHAN on 8.09.2018.
//  Copyright © 2018 Egemen Ayhan. All rights reserved.
//

import UIKit
import Networking
import Kingfisher

class ProductCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet fileprivate weak var productImageView: UIImageView!
    @IBOutlet fileprivate weak var designerLabel: UILabel!
    @IBOutlet fileprivate weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var priceLabel: UILabel!
    @IBOutlet fileprivate weak var minPriceLabel: UILabel!
    
    // MARK: - Properties
    static let identifier = String(describing: ProductCollectionViewCell.self)
    
    // MARK: - Functions
    func configure(with product: Product) {
        nameLabel.text = product.name
        designerLabel.text = product.designerName
        
        displayPrice(regular: product.price, min: product.minPrice)
        
        productImageView.kf.setImage(with: product.thumbnailURL)
        
        layoutSubviews()
    }
    
}

// MARK: - Private extension
private extension ProductCollectionViewCell {
    
    func displayPrice(regular: Double, min: Double) {
        minPriceLabel.isHidden = regular == min
        
        let formattedRegular = String(format: "%.f AED", regular)
        if regular != min {
            priceLabel.attributedText = NSAttributedString(string: formattedRegular, attributes: [NSAttributedStringKey.strikethroughStyle: 1])
            minPriceLabel.text = String(format: "%.f AED", min)
        } else {
            priceLabel.text = formattedRegular
        }
    }
    
}
