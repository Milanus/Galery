//
//  FileStorage.swift
//  Galery
//
//  Created by Milan Schon on 31/10/2018.
//  Copyright © 2018 Milan Schon. All rights reserved.
//

import UIKit

protocol Cacheble {
    // callbacks from file storage
    // if fileExists
    func fileExist(filePath:String)
    // file is creates
    func fileCreated(info:Storage)
    // file has error
    func error(error:String)
    // error
    func contentOfImage (imageData:Data?)
}

class FileStorage {
    // address of cache storage
     static var cachDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory,.userDomainMask, true)[0]
     static var CACHEDIR = FileStorage.cachDir+"/fotoCache/"
    // file manager
    var manager:FileManager!
    // protocol delegate
    var cacheDelegate:Cacheble?
    
    init() {
        self.manager = FileManager.default
    }
    // creates cache directory if get called that why lazy
    lazy var createCacheDir:String? = {
        let cacheDir = FileStorage.cachDir+"/fotoCache/"
        let manager = FileManager.default
        // if directory doesn't exists than create
        if !manager.fileExists(atPath: cacheDir) {
            do {
                try  manager.createDirectory(atPath: cacheDir, withIntermediateDirectories: false, attributes: nil)
                return cacheDir
            } catch { return nil}
        }
        // returns directory location
        return cacheDir
    }()
    // creates file
    func createFile (fileData:Data,urlPath:String) {
        guard let url = URL(string: urlPath) else {
            cacheDelegate?.error(error: "bad url")
            return
        }
        // here is called the lazy property
        let filePath = self.createCacheDir! + url.lastPathComponent
        if (manager.fileExists(atPath: filePath)) {
            cacheDelegate?.fileExist(filePath: filePath)
        } else {
            do {
                print("filePath \(filePath)")
//                creates file and send callback
                try fileData.write(to: URL(fileURLWithPath: filePath))
                cacheDelegate?.fileCreated(info:Storage(key: urlPath, value: filePath))
            } catch {
                cacheDelegate?.error(error: error.localizedDescription)
            }
        }
    }
    // fetch file if exists
    func fetchFile (filePath:String)  {
        // gets file from location on storage
        if manager.fileExists(atPath: filePath) {
           let data = manager.contents(atPath: filePath)
            cacheDelegate?.contentOfImage(imageData: data)
        } else {
            cacheDelegate?.error(error: "file not found ")
        }
    }
    // get file for share image feature
    func getFileFoShare (filePath:String) -> Data?{
        if manager.fileExists(atPath: filePath) {
            let data = manager.contents(atPath: filePath)
            return data
        }
        return nil
    }
    // clear directory for every new search query because it can get big with all those images
    func clearStorage() {
        if manager.fileExists(atPath: FileStorage.CACHEDIR) {
            do {
                // remove directory if exists
                try manager.removeItem(at:URL(fileURLWithPath: FileStorage.CACHEDIR))
            } catch {
                cacheDelegate?.error(error: error.localizedDescription)
            }
        }
    }
    
}
// base struct for storing information about cached image
struct Storage {
    let key:String
    let value:String
}
