//
//  Item.swift
//  seesaw
//
//  Created by Ricardo on 2017/7/27.
//  Copyright © 2017年 Ricardo. All rights reserved.
//

import Foundation
import TRON
import SwiftyJSON

struct Img_item:JSONDecodable {
    let id: Int
    //let img: Any

    init(json:JSON){
        id = json["id"].intValue
        //img = json["img"].object
    }

}
