//
//  TopRatedCell.swift
//  TMDB Demo
//
//  Created by Subin Sundaran Baby Sarojam on 8/6/19.
//  Copyright © 2019 SSBS. All rights reserved.
//

import Foundation
import UIKit

class TopRatedCell : UICollectionViewCell {
    
    @IBOutlet weak var topRatedImageView: UIImageView!
    @IBOutlet weak var topRatedTitle: UILabel!
    @IBOutlet weak var topRatedYear: UILabel!
    @IBOutlet weak var topRatedRating: UILabel!
    
    /// Collection class calls this method to fill data
    func displayContent(image: UIImage, title: String, year: String, rating: String) {
        topRatedImageView.image = image
        topRatedTitle.text = title
        topRatedYear.text = year
        topRatedRating.text = rating
    }
}
