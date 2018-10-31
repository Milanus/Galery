//
//  DataSource.swift
//  Galery
//
//  Created by Milan Schon on 28/10/2018.
//  Copyright © 2018 Milan Schon. All rights reserved.
//

import UIKit

class DataSource {
    // class that manage data for view model
    fileprivate var webService:WebService!
    fileprivate var complete:completeHandler!
    fileprivate var urlPath:String!
    fileprivate var htmlParser:HtmlParse!
    fileprivate var source:[HtmlSource] = [HtmlSource]()
    fileprivate var dataModel:DataModel!
    // watch if observer is active
    fileprivate var isAlive = false
    // initializing
    init(urlPath:String ,complete:@escaping completeHandler) {
        self.webService = WebService()
        self.complete = complete
        self.urlPath = urlPath
        self.htmlParser = HtmlParse()
        self.dataModel = DataModel()
    }
    // starts request
    func start () {
        self.makeJSonRequest()
    }
    // observer watches count of enities for downoload if count get to 0 observer will release all allocated objects
    var repeatObserver = 0 {
        didSet {
            if repeatObserver > 0 {
                self.fetchImage()
                isAlive = true
            } else {
                self.stop()
            }
        }
    }
    // gets json data from url
    fileprivate func makeJSonRequest() {
        self.webService.dataRequest(path: self.urlPath) {[weak self] (data, error) in
            guard error == nil else {
                return
            }
            if let data = data {
                let decoder = JSONDecoder()
                // get html string fro
                if let htmlFromJson = try? decoder.decode(SeznamRepo.self, from: data) {
                    self?.htmlParser = HtmlParse()
                    self?.htmlParser.parseHtml(html: htmlFromJson.html, htmlHandler: { (sources, error) in
                        if let sources = sources {
                            self?.source = sources
                            self?.repeatObserver = sources.count
                        }
                    })
                }
            }
        }
    }
    
    fileprivate func fetchImage () {
        let position = self.repeatObserver - 1
        guard let imagePath = self.source[position].thumbnailPath else {
            self.repeatObserver = position
            return
        }
        self.webService.dataRequest(path: imagePath) { [weak self] (data, error) in
            self?.procesData(imageDate: data, error: error?.description(), position: position)
            self?.repeatObserver = position
        }
    }
    
    func unsubscribe () {
        self.repeatObserver = -1
        stop()
    }
    
    fileprivate func procesData (imageDate:Data?, error:String?, position:Int) {
        guard error == nil  else {
            self.complete(dataModel,error)
            return
        }
        if let data = imageDate {
            if let size = source[position].size {
                dataModel.dimension = size
            }
            dataModel.image = UIImage(data: data)
            dataModel.title = source[position].pageUrl
            if let imagePath = source[position].imagePath {
                dataModel.imagePath = imagePath
            }
            self.complete(dataModel,nil)
        }
    }
    
    fileprivate func stop () {
        self.source.removeAll()
        self.dataModel = nil
        self.webService = nil
        self.htmlParser = nil
        self.isAlive = false
    }
    
    func isSubscribed () -> Bool{
        return self.isAlive
    }
}

typealias completeHandler = (DataModel,String?)->()
