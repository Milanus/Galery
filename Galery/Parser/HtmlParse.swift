//
//  HtmlParse.swift
//  Galery
//
//  Created by Milan Schon on 27/10/2018.
//  Copyright © 2018 Milan Schon. All rights reserved.
//

import UIKit
import SwiftSoup

class HtmlParse {
    func parseHtml (htmlData:Data, htmlHandler:@escaping ([HtmlSource]?,String?)->()) {
        do {
            if let html = String(data: htmlData, encoding: .utf8) {
                print("is main \(Thread.isMainThread)")
                let doc:Document = try SwiftSoup.parse(html)
                let srcs:Elements = try doc.select("img[src]")
                var htmlSource:HtmlSource!
                let srcsDetail: [HtmlSource] = srcs.array().map { src in
                    htmlSource = HtmlSource()
                    if let imagePath = try? src.attr("src").description {
                        htmlSource.imagePath = String(htmlEncodedString: imagePath).replacaHtmlFromString()
                    }
                    if let height = try? src.attr("height") {htmlSource.heigth = height.replacaHtmlFromString()}
                    if let width = try? src.attr("width") {htmlSource.width = width.replacaHtmlFromString()}
                    if let desc = try? src.attr("alt") {htmlSource.description = desc.replacaHtmlFromString()}
                    return htmlSource
                }
                htmlHandler(srcsDetail,nil)
//                print("all images \(Array(srcsStringArray))")
            }
        }catch Exception.Error(_, let message){
            htmlHandler(nil,message)
        } catch {
            htmlHandler(nil,error.localizedDescription)
        }
    }
}
