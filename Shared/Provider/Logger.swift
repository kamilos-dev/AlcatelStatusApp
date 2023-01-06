//
//  SystemExtensions.swift
//  AlcatelApp
//
//  Created by Kamil Szymeczko on 09/04/2022.
//

import Foundation

class Logger {
    
    static func Log(_ msg: String) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY-MM-dd HH:mm:ss"
        
        print("["+dateFormatter.string(from: date) + "] " + msg)
    }
}
