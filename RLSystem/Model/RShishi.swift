//
//  RShishi.swift
//  RLSystem
//
//  Created by 相川健太 on 2019/01/17.
//  Copyright © 2019年 相川健太. All rights reserved.
//

import Foundation
import RealmSwift

class RShishi: Object {
    @objc dynamic var id = 0
    @objc dynamic var webmap_id = 0
    @objc dynamic var shishi_id = 0
    @objc dynamic var word1 = ""
    @objc dynamic var word2 = ""
    @objc dynamic var word3 = ""
    @objc dynamic var word4 = ""
    @objc dynamic var word5 = ""
    @objc dynamic var match_words = 0
    @objc dynamic var webmap_url = ""
    @objc dynamic var shishi_url = ""
}
