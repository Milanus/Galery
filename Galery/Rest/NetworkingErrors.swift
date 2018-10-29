//
//  NetworkingErrors.swift
//  Galery
//
//  Created by Milan Schon on 27/10/2018.
//  Copyright © 2018 Milan Schon. All rights reserved.
//


struct SessionError:Error {
    var errorType:NetworkError
    var errorMsg:String?
 
    init(errorType:NetworkError,errorMsg:String?) {
        self.errorType = errorType
        self.errorMsg = errorMsg
    }
    enum NetworkError {
        case badURL
        case message
    }
    
    func description () -> String  {
        switch (errorType) {
        case .badURL:
            return "bad url"
        case .message:
            return " message \(String(describing: errorMsg))"
        }
    }
}
