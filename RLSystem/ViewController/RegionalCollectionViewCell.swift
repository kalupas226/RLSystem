//
//  RegionalCollectionViewCell.swift
//  RLSystem
//
//  Created by 相川健太 on 2019/01/14.
//  Copyright © 2019年 相川健太. All rights reserved.
//

import UIKit

class RegionalCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var regionalName: UILabel!
    @IBOutlet weak var regionalImage: UIImageView!
    @IBOutlet weak var matchWord: UILabel!
    @IBOutlet weak var featureWord1: UILabel!
    @IBOutlet weak var featureWord2: UILabel!
    @IBOutlet weak var featureWord3: UILabel!
    @IBOutlet weak var featureWord4: UILabel!
    @IBOutlet weak var featureWord5: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        regionalImage.image = nil
        matchWord.text = nil
        featureWord1.textColor = nil
        featureWord2.textColor = nil
        featureWord3.textColor = nil
        featureWord4.textColor = nil
        featureWord5.textColor = nil
    }
}
