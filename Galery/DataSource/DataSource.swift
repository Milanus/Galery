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
    // how in works all components are initialized witch have to live during the live cycle of the load of the images in tableview
    // start is trigger makes request for json at url witch return json data
    // html is parsed from json and than and data
    // images are download from parsed html fetch image
    // at last is called callback procesData 
 
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
        // make request to url
        self.webService.dataRequest(path: self.urlPath) {[weak self] (data, error) in
            // returns if error not nil
            // weak self manage if there is no retaine cycle in closure
            guard error == nil else {
                return
            }
            if let data = data {
                let decoder = JSONDecoder()
                // parse html from json
                if let htmlFromJson = try? decoder.decode(SeznamRepo.self, from: data) {
                    // parse html
                    self?.htmlParser = HtmlParse()
                    self?.htmlParser.parseHtml(html: htmlFromJson.html, htmlHandler: { (sources, error) in
                        if let sources = sources {
                            // get source data and triggers observer
                            self?.source = sources
                            //observer
                            self?.repeatObserver = sources.count
                        }
                    })
                }
            }
        }
    }
    // fetches all images from url
    fileprivate func fetchImage () {
        let position = self.repeatObserver - 1
        // check if image patch is nil
        guard let imagePath = self.source[position].thumbnailPath else {
            self.repeatObserver = position
            return
        }
        // make the request for the image
        self.webService.dataRequest(path: imagePath) { [weak self] (data, error) in
            // proces the image data and sets decrement the observer
            self?.procesData(imageDate: data, error: error?.description(), position: position)
            self?.repeatObserver = position
        }
    }
    
    func unsubscribe () {
        // release observer and all allocated variables
        self.repeatObserver = -1
        stop()
    }
    // convert data to data model and call callback method
    fileprivate func procesData (imageDate:Data?, error:String?, position:Int) {
        guard error == nil  else {
            self.complete(dataModel,error)
            return
        }
        // if data not nil then create data model
        if let data = imageDate {
            if let size = source[position].size {
                dataModel.dimension = size
            }
            dataModel.image = UIImage(data: data)
            dataModel.title = source[position].pageUrl
            if let imagePath = source[position].imagePath {
                dataModel.imagePath = imagePath
            }
            //callback with data model
            self.complete(dataModel,nil)
        }
    }
    // realese all objects
    fileprivate func stop () {
        self.source.removeAll()
        self.dataModel = nil
        self.webService = nil
        self.htmlParser = nil
        self.isAlive = false
    }
    // check if observer is alive
    func isSubscribed () -> Bool{
        return self.isAlive
    }
}

typealias completeHandler = (DataModel,String?)->()
