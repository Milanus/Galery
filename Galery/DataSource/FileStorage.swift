//
//  FileStorage.swift
//  Galery
//
//  Created by Milan Schon on 31/10/2018.
//  Copyright © 2018 Milan Schon. All rights reserved.
//

import UIKit

protocol Cacheble {
    func fileExist(filePath:String)
    func fileCreated(info:Storage)
    func error(error:String)
    func contentOfImage (imageData:Data?)
}

class FileStorage {
     static var cachDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory,.userDomainMask, true)[0]
     static var CACHEDIR = FileStorage.cachDir+"/fotoCache/"
    var manager:FileManager!
    var cacheDelegate:Cacheble?
    
    init() {
        self.manager = FileManager.default
    }
    
    lazy var createCacheDir:String? = {
        let cacheDir = FileStorage.cachDir+"/fotoCache/"
        let manager = FileManager.default
        if !manager.fileExists(atPath: cacheDir) {
            do {
                try  manager.createDirectory(atPath: cacheDir, withIntermediateDirectories: false, attributes: nil)
                return cacheDir
            } catch { return nil}
        }
        return cacheDir
    }()
    
    func createFile (fileData:Data,urlPath:String) {
        guard let url = URL(string: urlPath) else {
            cacheDelegate?.error(error: "bad url")
            return
        }
        let filePath = self.createCacheDir! + url.lastPathComponent
        if (manager.fileExists(atPath: filePath)) {
            cacheDelegate?.fileExist(filePath: filePath)
        } else {
            do {
                print("filePath \(filePath)")
                try fileData.write(to: URL(fileURLWithPath: filePath))
                cacheDelegate?.fileCreated(info:Storage(key: urlPath, value: filePath))
            } catch {
                cacheDelegate?.error(error: error.localizedDescription)
            }
        }
    }
    
    func fetchFile (filePath:String)  {
        if manager.fileExists(atPath: filePath) {
           let data = manager.contents(atPath: filePath)
            cacheDelegate?.contentOfImage(imageData: data)
        } else {
            cacheDelegate?.error(error: "file not found ")
        }
    }
    
    func getFileFoShare (filePath:String) -> Data?{
        if manager.fileExists(atPath: filePath) {
            let data = manager.contents(atPath: filePath)
            return data
        }
        return nil
    }
    
    func clearStorage() {
        if manager.fileExists(atPath: FileStorage.CACHEDIR) {
            do {
                try manager.removeItem(at:URL(fileURLWithPath: FileStorage.CACHEDIR))
            } catch {
                cacheDelegate?.error(error: error.localizedDescription)
            }
        }
    }
    
}

struct Storage {
    let key:String
    let value:String
}
