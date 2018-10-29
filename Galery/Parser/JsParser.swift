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

struct SeznamRepo:Codable {
    let htmlCode:String
    
    private enum keys:String, CodingKey{
        case html;
    }
}
