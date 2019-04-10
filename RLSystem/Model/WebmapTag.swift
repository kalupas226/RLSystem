//
//  WebmapTag.swift
//  RLSystem
//
//  Created by 相川健太 on 2019/01/23.
//  Copyright © 2019年 相川健太. All rights reserved.
//

import Foundation
import RealmSwift

class WebmapTag: Object {
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var tag = ""
}
