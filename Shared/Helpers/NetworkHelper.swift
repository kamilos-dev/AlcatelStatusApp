//
//  NetworkHelper.swift
//  AlcatelApp
//
//  Created by Kamil Szymeczko on 09/04/2022.
//

import Foundation
import CoreWLAN

class NetworkHelper {
    static func GetSsidName() -> String? {
        return CWWiFiClient.shared().interface(withName: nil)?.ssid() ?? nil
    }
}
