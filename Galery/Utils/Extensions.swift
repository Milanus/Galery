//
//  Extensions.swift
//  Galery
//
//  Created by Milan Schon on 29/10/2018.
//  Copyright © 2018 Milan Schon. All rights reserved.
//

import Foundation

extension String {
    
    init(htmlEncodedString: String) {
        self.init()
        guard let encodedData = htmlEncodedString.data(using: .utf8) else {
            self = htmlEncodedString
            return
        }
        
        let attributedOptions: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        do {
            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            self = attributedString.string
        } catch {
            print("Error: \(error)")
            self = htmlEncodedString
        }
    }
    func replacaHtmlFromString () -> String {
        let replacedString = self.replacingOccurrences(of: "\\/", with: "/").replacingOccurrences(of: "\\\"", with: "")
        return replacedString
    }
}
