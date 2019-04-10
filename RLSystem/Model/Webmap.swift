//
//  Webmap.swift
//  RLSystem
//
//  Created by 相川健太 on 2019/01/05.
//  Copyright © 2019年 相川健太. All rights reserved.
//

import Foundation
import RealmSwift

class Webmap: Object {
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var title_yomi = ""
    @objc dynamic var author = ""
    @objc dynamic var date = ""
    @objc dynamic var context = ""
    @objc dynamic var inscription = ""
    @objc dynamic var reference = ""
    @objc dynamic var tourist_sign = ""
    @objc dynamic var english = ""
    @objc dynamic var hantaiji = ""
    @objc dynamic var kantaiji = ""
    @objc dynamic var russian = ""
    @objc dynamic var hangul = ""
    @objc dynamic var thai = ""
    @objc dynamic var large_area = ""
    @objc dynamic var small_area = ""
    @objc dynamic var location = ""
    @objc dynamic var age_production = ""
    @objc dynamic var age_subject = ""
    @objc dynamic var url = ""
}
