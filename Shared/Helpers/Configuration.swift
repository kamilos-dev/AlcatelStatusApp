//
//  Configuration.swift
//  MobileStatusApp (macOS)
//
//  Created by Kamil Szymeczko on 25/04/2022.
//

import Foundation

enum Configuration {
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }

    static func infoForKey(_ key: String) -> String? {
            return (Bundle.main.infoDictionary?[key] as? String)?
                .replacingOccurrences(of: "\\", with: "")
     }
}
