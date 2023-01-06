//
//  ModemDataGetter.swift
//  MobileStatusApp (macOS)
//
//  Created by Kamil Szymeczko on 13/04/2022.
//

import Foundation

class ModemDataGetter {
    
    private var modem: MobileModem!
    
    private var batteryInfo: BatteryInfo?
    private var connectedDevices: [ConnectedDevice]
    
    var onBatteryInfoChange: ((BatteryInfo?) -> Void)?
    var onConnectedDevicesChange: (([ConnectedDevice]) -> Void)?
    
    init (_ modem: MobileModem!) {
        self.modem = modem
        self.connectedDevices = []
    }
    
    func getData() {
        getBatteryInfo()
        getConnectedDevices()
    }
    
    private func getBatteryInfo() {
        let batteryInfo = self.modem.getBatteryInfo()
        
        if (batteryInfo == self.batteryInfo) {
            return
        }
        
        self.batteryInfo = batteryInfo
        
        onBatteryInfoChange?(self.batteryInfo)
    }
    
    private func getConnectedDevices() {
        let connectedDevices = self.modem.getConnectedDevices()
        
        if connectedDevices == self.connectedDevices {
            return
        }
        
        self.connectedDevices = connectedDevices
        
        onConnectedDevicesChange?(self.connectedDevices)
    }
}
