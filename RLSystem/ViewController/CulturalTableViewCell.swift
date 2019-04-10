//
//  CulturalTableViewCell.swift
//  RLSystem
//
//  Created by 相川健太 on 2019/01/21.
//  Copyright © 2019年 相川健太. All rights reserved.
//

import UIKit

class CulturalTableViewCell: UITableViewCell {
    @IBOutlet weak var culturalImage: UIImageView!
    @IBOutlet weak var culturalTitle: UILabel!
    @IBOutlet weak var culturalFeature: UILabel!
    @IBOutlet weak var relateLabel: UILabel!
    @IBOutlet weak var CulturalCell: CulturalTableViewCell!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        culturalTitle.text = nil
        culturalFeature.text = nil
        relateLabel.text = nil
        culturalImage.image = nil
    }
    
}
