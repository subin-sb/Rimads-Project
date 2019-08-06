//
//  PopularCell.swift
//  TMDB Demo
//
//  Created by Subin Sundaran Baby Sarojam on 8/6/19.
//  Copyright © 2019 SSBS. All rights reserved.
//

import Foundation
import UIKit

class PopularCell : UICollectionViewCell {
    
    @IBOutlet weak var popularImageView: UIImageView!
    @IBOutlet weak var popularTitle: UILabel!
    @IBOutlet weak var popularYear: UILabel!
    @IBOutlet weak var popularRating: UILabel!
    
    /// Collection class calls this method to fill data
    func displayContent(image: UIImage, title: String, year: String, rating: String) {
        popularImageView.image = image
        popularTitle.text = title
        popularYear.text = year
        popularRating.text = rating
    }
}
