//
//  ItemsResponse.swift
//  seesaw
//
//  Created by Ricardo on 2017/7/27.
//  Copyright © 2017年 Ricardo. All rights reserved.
//

import Foundation
import TRON
import SwiftyJSON

struct ItemsResponse:JSONDecodable {
    let items: [Img_item]
    
    init(json:JSON) throws {
        print("JSON from itemResponse: \(json)")
        let itemsArray = json.arrayValue
        items = itemsArray.map({ Img_item(json: $0) })
    }
}
