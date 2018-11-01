//
//  Extensions.swift
//  Galery
//
//  Created by Milan Schon on 29/10/2018.
//  Copyright © 2018 Milan Schon. All rights reserved.
//

import Foundation

extension String {
    // decode html string
    // overriding initializer with html string
    init(htmlEncodedString: String) {
        self.init()
//        converting html to data
        guard let encodedData = htmlEncodedString.data(using: .utf8) else {
            self = htmlEncodedString
            return
        }
        // setting attributes options
        let attributedOptions: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        do {
            //adding the converted string 
            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            self = attributedString.string
        } catch {
            print("Error: \(error)")
            self = htmlEncodedString
        }
    }
    // replace html from string
    func replacaHtmlFromString () -> String {
        let replacedString = self.replacingOccurrences(of: "\\/", with: "/").replacingOccurrences(of: "\\\"", with: "")
        return replacedString
    }
}
