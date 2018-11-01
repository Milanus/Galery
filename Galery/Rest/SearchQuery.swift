//
//  SearchQuery.swift
//  Galery
//
//  Created by Milan Schon on 29/10/2018.
//  Copyright © 2018 Milan Schon. All rights reserved.
//

import UIKit

struct SearchQuery {
    var searchQuery:SearchParms
    init(params:SearchParms) {
        self.searchQuery = params
    }
    // building query for request 
    var build:String? {
        var queryItems = [URLQueryItem]()
        var urlComponents = URLComponents(string: "https://www.obrazky.cz/searchAjax")
        queryItems.append(URLQueryItem(name: "q", value: searchQuery.query))
        queryItems.append(URLQueryItem(name: "s", value: ""))
        queryItems.append(URLQueryItem(name: "step", value: searchQuery.step))
        queryItems.append(URLQueryItem(name: "size", value: "any"))
        queryItems.append(URLQueryItem(name: "color", value: "any"))
        queryItems.append(URLQueryItem(name: "filter", value: "true"))
        queryItems.append(URLQueryItem(name: "from", value: searchQuery.from))
        urlComponents?.queryItems = queryItems
        return urlComponents?.url?.absoluteString
    }
}

struct SearchParms {
    let query:String
    let step:String
    let from:String
}
