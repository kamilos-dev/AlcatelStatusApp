//
//  Encoding.swift
//  AlcatelApp
//
//  Created by Kamil Szymeczko on 08/04/2022.
//

import Foundation

struct Encoding {
    static func encode(value: String) -> String {
        let key = "e5dl12XYVggihggafXWf0f2YSf2Xngd1"
        
        var str1: [UInt8] = []
        var encryStr = ""
        
        for i in 0..<value.count {
            let char_i = value[i]
            let num_char_i = Character(char_i).asciiValue
            
            let index = i % key.count
            let char = key[index]
            let charAsciiValue = Character(char).asciiValue
            
            let encodedValue1 = (
                (charAsciiValue!) & 0xf0) |
                ((num_char_i! & 0xf) ^ (charAsciiValue! & 0xf))
            
            str1.insert(encodedValue1, at: 2 * i)
            
            let encodedValue2 = (
                charAsciiValue! & 0xf0) |
                ((num_char_i! >> 4) ^ (charAsciiValue! & 0xf))
            
            str1.insert(encodedValue2, at: 2 * i + 1)
        }
        
        for i in 0..<str1.count {
            encryStr += String(Character(UnicodeScalar(str1[i])))
        }
        
        return encryStr
    }
}
