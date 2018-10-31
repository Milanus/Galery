//
//  ImageViewModel.swift
//  Galery
//
//  Created by Milan Schon on 31/10/2018.
//  Copyright © 2018 Milan Schon. All rights reserved.
//

import UIKit

class ImageViewModel {
    
    fileprivate var imageModel:ImageModel!
    fileprivate var webservice:WebService!
    
    init() {
        self.webservice = WebService()
        self.imageModel = ImageModel()
    }
    
    func populate (url:String, onImageLoaded:@escaping imageLoaded) {
        self.webservice.dataRequest(path: url) {(imageData, error) in
            guard error == nil else {
                DispatchQueue.main.async {
                     onImageLoaded(self.imageModel,error?.description())
                }
                return
            }
            if let data = imageData  {
                self.imageModel.image = UIImage(data: data)
                DispatchQueue.main.async {
                    onImageLoaded(self.imageModel,nil)
                }
            }
        }
    }
  
}
  typealias imageLoaded =  (ImageModel,String?)->()
