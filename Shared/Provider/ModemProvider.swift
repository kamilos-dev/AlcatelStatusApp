//
//  ModemProvider.swift
//  AlcatelApp (macOS)
//
//  Created by Kamil Szymeczko on 13/04/2022.
//

import Foundation

class ModemProvider {
    static func getMobileModem(_ ssidName: String) -> MobileModem? {
        if MobileSsids.Ssids.contains(ssidName) {
            Logger.Log("Sieć "+ssidName+" jest obsługiwana.")
            if ssidName == "S3B" {
                Logger.Log("Wybrany modem: AlcatelModem")
                return AlcatelModem()
            }
        }
        
        Logger.Log("Sieć "+ssidName+" NIE jest obsługiwana.")
        return nil
    }
}
