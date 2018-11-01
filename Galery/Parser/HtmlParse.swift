//
//  HtmlParse.swift
//  Galery
//
//  Created by Milan Schon on 27/10/2018.
//  Copyright © 2018 Milan Schon. All rights reserved.
//

import UIKit
import SwiftSoup
// class parse html
class HtmlParse {
    // parse html from string
    func parseHtml (html:String?, htmlHandler:@escaping ([HtmlSource]?,String?)->()) {
        do {
            if let html = html {
                let document:Document = try SwiftSoup.parse(html)
                // elements with class image
                let imageElements:Elements = try document.getElementsByClass("image")
                // mapping array of HtmlSorce model
                let htmlModel:[HtmlSource] = imageElements.array().map { imageElement in
                    var htmlSource = HtmlSource()
                    htmlSource.pageUrl = try? imageElement.getElementsByClass("url").text()
                    htmlSource.size = try? imageElement.getElementsByClass("size").text()
                    let element = try! imageElement.select("a").get(0)
                    htmlSource.imagePath = try? element.attr("data-elm")
                    htmlSource.thumbnailPath = try? element.select("img[src]").attr("src")
                    return htmlSource
                }
                //callback with data
                 htmlHandler(htmlModel,nil)
            }
        }catch Exception.Error(_, let message){
            // if error while parsing html handle error
            htmlHandler(nil,message)
            print(message)
        } catch {
            htmlHandler(nil,error.localizedDescription)
        }
    }
}
