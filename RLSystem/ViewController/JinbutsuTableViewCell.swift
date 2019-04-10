//
//  JinbutsuTableViewCell.swift
//  RLSystem
//
//  Created by 相川健太 on 2019/02/18.
//  Copyright © 2019 相川健太. All rights reserved.
//

import UIKit

class JinbutsuTableViewCell: UITableViewCell {

    @IBOutlet weak var JinbutsuImg: UIImageView!
    @IBOutlet weak var JinbutsuLabel: UILabel!
    @IBOutlet weak var relateNum: UILabel!
    
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
        JinbutsuImg.image = nil
        JinbutsuLabel.text = nil
        relateNum.text = nil
    }
    
}
