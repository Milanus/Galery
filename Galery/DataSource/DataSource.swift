//
//  DataSource.swift
//  Galery
//
//  Created by Milan Schon on 28/10/2018.
//  Copyright © 2018 Milan Schon. All rights reserved.
//

import UIKit

class DataSource {
    
    fileprivate var webService:WebService!
    fileprivate var complete:completeHandler!
    fileprivate var urlPath:String!
    fileprivate var htmlParser:HtmlParse!
    fileprivate var source:[HtmlSource] = [HtmlSource]()
    fileprivate var dataModel:DataModel!
    fileprivate var isAlive = false
    
    init(urlPath:String ,complete:@escaping completeHandler) {
        self.webService = WebService()
        self.complete = complete
        self.urlPath = urlPath
        self.htmlParser = HtmlParse()
        self.dataModel = DataModel()
    }
    
    func start () {
        self.makeRequest()
    }
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
    fileprivate func makeRequest() {
        self.webService.dataRequest(path: self.urlPath) {[weak self] (data, error) in
            guard error == nil else {
                return
            }
            if let data = data {
                self?.htmlParser = HtmlParse()
                self?.htmlParser.parseHtml(htmlData: data, htmlHandler: { (sources, error) in
                    if let sources = sources {
                        self?.source = sources
                        self?.repeatObserver = sources.count
                    }
                })
            }
        }
    }
    
    fileprivate func fetchImage () {
        let position = self.repeatObserver - 1
        guard let imagePath = self.source[position].imagePath else {
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
            if let height = source[position].heigth, let width = source[position].width {
                 dataModel.dimension = "\(width)x\(height)"
            }
            dataModel.image = UIImage(data: data)
            dataModel.title = source[position].description
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
