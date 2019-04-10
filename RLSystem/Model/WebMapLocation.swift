//
//  WebMap_Location.swift
//  RLSystem
//
//  Created by 相川健太 on 2019/02/16.
//  Copyright © 2019 相川健太. All rights reserved.
//

import Foundation
import RealmSwift

class WebMapLocation: Object {
    @objc dynamic var webmap_id = 0
    @objc dynamic var lat = ""
    @objc dynamic var lng = ""
}
