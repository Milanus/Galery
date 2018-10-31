//
//  JsParser.swift
//  Galery
//
//  Created by Milan Schon on 27/10/2018.
//  Copyright © 2018 Milan Schon. All rights reserved.
//

import UIKit

struct JsParser {

}
// Seznam json repozitary
struct SeznamRepo:Codable {
    let html:String
    //key
    private enum keys:String, CodingKey{
        case html = "html";
    }
}
