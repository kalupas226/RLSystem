//
//  Shishi.swift
//  RLSystem
//
//  Created by 相川健太 on 2019/01/05.
//  Copyright © 2019年 相川健太. All rights reserved.
//

import Foundation
import RealmSwift

class Shishi: Object {
    @objc dynamic var id = 0
    @objc dynamic var book_name = ""
    @objc dynamic var volume_id = ""
    @objc dynamic var part_id = ""
    @objc dynamic var section_id = ""
    @objc dynamic var subsection_id = ""
    @objc dynamic var subsubsection_id = ""
    @objc dynamic var paragraph_id = ""
    @objc dynamic var volume_title = ""
    @objc dynamic var part_title = ""
    @objc dynamic var section_title = ""
    @objc dynamic var subsection_title = ""
    @objc dynamic var subsubsection_title = ""
    @objc dynamic var paragraph_title = ""
    @objc dynamic var paragraph_title_words = ""
    @objc dynamic var paragraph_title_name_words = ""
    @objc dynamic var paragraph_body = ""
    @objc dynamic var url = ""
    @objc dynamic var image_exists = ""
    @objc dynamic var image_title = ""
    @objc dynamic var image_id = ""
    @objc dynamic var image_url = ""
}
