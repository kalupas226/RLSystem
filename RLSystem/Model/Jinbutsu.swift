//
//  Jinbutsu.swift
//  RLSystem
//
//  Created by 相川健太 on 2019/01/05.
//  Copyright © 2019年 相川健太. All rights reserved.
//

import Foundation
import RealmSwift

class Jinbutsu: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var nameYomi = ""
    @objc dynamic var dateBorn = 0
    @objc dynamic var dateDeath = 0
    @objc dynamic var catchWord = ""
    @objc dynamic var url = ""
    @objc dynamic var imgUrl = ""
}
