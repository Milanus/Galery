//
//  ImageViewModel.swift
//  Galery
//
//  Created by Milan Schon on 31/10/2018.
//  Copyright © 2018 Milan Schon. All rights reserved.
//

import UIKit

class ImageViewModel:Cacheble {
    
    
    fileprivate var imageModel:ImageModel!
    fileprivate var webservice:WebService!
    fileprivate var cache:[String:String] = [String:String]()
    fileprivate var storage:FileStorage!
    fileprivate var onImageLoaded:imageLoaded!
    var shareUrl:String!
    
    init(onImageLoaded:@escaping imageLoaded) {
        
        self.webservice = WebService()
        self.imageModel = ImageModel()
        self.storage = FileStorage()
        self.storage.cacheDelegate = self
        self.onImageLoaded = onImageLoaded
        self.storage.clearStorage()
    }
    
    func populate (url:String) {
        self.shareUrl = url
        if !self.checkIfFileExists(urlString: url) {
            self.webservice.dataRequest(path: url) {(imageData, error) in
                guard error == nil else {
                    DispatchQueue.main.async {
                        self.onImageLoaded(self.imageModel,error?.description())
                    }
                    return
                }
                if let data = imageData  {
                    self.storage.createFile(fileData: data, urlPath: url)
                    self.imageModel.image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.onImageLoaded(self.imageModel,nil)
                    }
                }
            }
        } else {
            storage.fetchFile(filePath: self.cache[url]!)
        }
    }
    
    func fileExist(filePath: String) {
        
    }
    
    func fileCreated(info: Storage) {
        cache[info.key] = info.value
    }
    
    func error(error: String) {
        print("some error \(error)")
    }
    
    func contentOfImage(imageData: Data?) {
        if let imageData = imageData {
            self.imageModel.image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.onImageLoaded(self.imageModel,nil)
            }
        }
    }
    fileprivate func checkIfFileExists (urlString:String) -> Bool {
        if cache[urlString] != nil {
            return true
        }
        return false
    }
    
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
