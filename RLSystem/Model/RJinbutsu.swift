//
//  Rjinbutsu.swift
//  RLSystem
//
//  Created by 相川健太 on 2019/01/05.
//  Copyright © 2019年 相川健太. All rights reserved.
//

import Foundation
import RealmSwift

class RJinbutsu: Object {
    @objc dynamic var id = 0
    @objc dynamic var webmap_id = 0
    @objc dynamic var jinbutsu_id = 0
    @objc dynamic var word1 = ""
    @objc dynamic var word2 = ""
    @objc dynamic var word3 = ""
    @objc dynamic var word4 = ""
    @objc dynamic var word5 = ""
    @objc dynamic var match_words = 0
    @objc dynamic var webmap_url = ""
    @objc dynamic var jinbutsu_url = ""
}
