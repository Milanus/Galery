//
//  ImageViewModel.swift
//  Galery
//
//  Created by Milan Schon on 31/10/2018.
//  Copyright © 2018 Milan Schon. All rights reserved.
//

import UIKit

class ImageViewModel:Cacheble {

    // representing image controller model
    fileprivate var imageModel:ImageModel!
    fileprivate var webservice:WebService!
    fileprivate var cache:[String:String] = [String:String]()
    fileprivate var storage:FileStorage!
    fileprivate var onImageLoaded:imageLoaded!
    var shareUrl:String!
    // with callback
    init(onImageLoaded:@escaping imageLoaded) {
        self.webservice = WebService()
        self.imageModel = ImageModel()
        self.storage = FileStorage()
        self.storage.cacheDelegate = self
        self.onImageLoaded = onImageLoaded
        self.storage.clearStorage()
    }
    // populate image view with data
    func populate (url:String) {
        self.shareUrl = url
        // check if file exist in local storage if not than it will be downloaded
        if !self.checkIfFileExists(urlString: url) {
            self.webservice.dataRequest(path: url) {(imageData, error) in
                guard error == nil else {
                    DispatchQueue.main.async {
                        // error when
                        self.onImageLoaded(self.imageModel,error?.description())
                        self.imageModel.image = nil
                    }
                    return
                }
                if let data = imageData  {
                    // send callback with downloaded data on main thread
                    self.storage.createFile(fileData: data, urlPath: url)
                    self.imageModel.image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.onImageLoaded(self.imageModel,nil)
                        self.imageModel.image = nil
                    }
                }
            }
        } else {
            //fetching file from local storage
            storage.fetchFile(filePath: self.cache[url]!)
        }
    }
    
    func fileExist(filePath: String) {
        
    }
    
    func fileCreated(info: Storage) {
//        set local cache key url value file path
        cache[info.key] = info.value
    }
    
    func error(error: String) {
     
    }
    // image is loaded from local storage
    func contentOfImage(imageData: Data?) {
        if let imageData = imageData {
            self.imageModel.image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.onImageLoaded(self.imageModel,nil)
                self.imageModel.image = nil
            }
        }
    }
    // check if if file exists in cache
    fileprivate func checkIfFileExists (urlString:String) -> Bool {
        if cache[urlString] != nil {
            return true
        }
        return false
    }
    // get image for share
    func getImage() ->UIImage? {
        if checkIfFileExists(urlString: self.shareUrl) {
            if let imageData = storage.getFileFoShare(filePath: cache[self.shareUrl]!) {
                return  UIImage(data: imageData)
            }
        }
        return nil
    }
    
}
  typealias imageLoaded =  (ImageModel,String?)->()
