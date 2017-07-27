//
//  MyError.swift
//  seesaw
//
//  Created by Ricardo on 2017/7/27.
//  Copyright © 2017年 Ricardo. All rights reserved.
//

import Foundation
import TRON
import SwiftyJSON

struct MyError: JSONDecodable{
    init(json: JSON) throws{
        print("JSON from error: \(json)")
        print("JSON parsing error")
    }
}
