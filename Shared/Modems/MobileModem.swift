//
//  MobileModem.swift
//  AlcatelApp
//
//  Created by Kamil Szymeczko on 09/04/2022.
//

import Foundation

struct BatteryInfo: Equatable {
    var isCharging: Bool = false
    var level: Int32 = 0
    
    static func == (lhs: BatteryInfo, rhs: BatteryInfo) -> Bool {
        return lhs.isCharging == rhs.isCharging && lhs.level == rhs.level
    }
}

struct ConnectedDevice: Equatable {
    var name: String!
    var ipAddress: String!
    
    static func == (lhs: ConnectedDevice, rhs: ConnectedDevice) -> Bool {
        return lhs.name == rhs.name && lhs.ipAddress == rhs.ipAddress
    }
}

struct SmsInput {
    var to: String!
    var text: String!
}

protocol MobileModem {
    func getBatteryInfo() -> BatteryInfo?
    func getConnectedDevices() -> [ConnectedDevice]
    func sendSms(_ sms: SmsInput!) -> Void
}
