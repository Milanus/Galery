//
//  File.swift
//  Galery
//
//  Created by Milan Schon on 27/10/2018.
//  Copyright © 2018 Milan Schon. All rights reserved.
//

import Foundation
import SwiftSoup

struct WebService {
    // status kode ok
    fileprivate static let statusOK:Int = 200
    // makes data request for server
    func dataRequest (path:String, handleRequest:@escaping (Data?,SessionError?) -> ()) {
        guard let url = URL(string: path) else {
            handleRequest(nil,SessionError(errorType: .badURL, errorMsg: nil))
            return
        }
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: url)  { (data, response, error) in
            guard error == nil else  {
                handleRequest(nil,SessionError(errorType: .message, errorMsg:error!.localizedDescription ))
                return
            }
            if let response = response as? HTTPURLResponse {
                if response.statusCode == WebService.statusOK {
                    handleRequest(data,nil)
                }
            }
        }
        task.resume()
    }
}
