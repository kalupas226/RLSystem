//
//  CuluturalCollectionViewCell.swift
//  RLSystem
//
//  Created by 相川健太 on 2019/02/18.
//  Copyright © 2019 相川健太. All rights reserved.
//

import UIKit

class CulturalCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var culturalTitle: UILabel!
    @IBOutlet weak var culturalImage: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        culturalImage.image = nil
        culturalTitle.text = nil
    }
}
