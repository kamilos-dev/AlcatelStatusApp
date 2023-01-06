//
//  ModemStatusBarService.swift
//  AlcatelApp (macOS)
//
//  Created by Kamil Szymeczko on 13/04/2022.
//

import Foundation
import SwiftUI

class AppStatusBarService {
    
    private var currentBatteryInfo: BatteryInfo?
    private var connectedDevices: [ConnectedDevice]
    
    private var statusItem: NSStatusItem!
    private var menuTitle: String!
    
    init() {
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        self.currentBatteryInfo = nil
        self.connectedDevices = []
        
        self.menuTitle = ""
    }
    
    func setNoWifiConnection() {
        connectedDevices = []
        setMenuTitle("No wifi")
    }
    
    func setNotSupportedWifi() {
        connectedDevices = []
        setMenuTitle("Wifi not supported")
    }
    
    func setBatteryInfo(_ batteryInfo: BatteryInfo?) {
        if batteryInfo == nil {
            setMenuTitle("Cannot read data")
            return
        }
        
        if currentBatteryInfo == batteryInfo {
            return
        }

        currentBatteryInfo = batteryInfo
        
        var iconTitle = String(currentBatteryInfo!.level) + "%"
        
        if currentBatteryInfo!.isCharging {
            iconTitle += " 🔋"
        }
        
        setMenuTitle(iconTitle)
    }
    
    func setConnectedDevices(_ data: [ConnectedDevice]) {
        self.connectedDevices = data
        buildMenu()
    }
    
    private func setMenuTitle(_ title: String) {
        self.menuTitle = title
        buildMenu()
    }
    
    private func buildMenu() {
        // menu title
        if let button = statusItem.button {
            button.title = self.menuTitle
            //button.image = NSImage(systemSymbolName: "2.circle", accessibilityDescription: "1")
        }
        
        // devices
        let menu = NSMenu()
        
        let items = buildConnectedDevicesMenuItems()
        menu.items.append(contentsOf: items)
        
        menu.items.append(.separator())
        menu.items.append(buildCloseMenuItem())
        statusItem.menu = menu
    }
    
    private func buildConnectedDevicesMenuItems() -> [NSMenuItem] {
        
        var items: [NSMenuItem] = []
        
        for device in self.connectedDevices {
            let editMenuItem = NSMenuItem()
            editMenuItem.title = device.name + " : " + device.ipAddress
            editMenuItem.indentationLevel = 0
            
            items.append(editMenuItem)
        }
        
        return items
    }
    
    private func buildCloseMenuItem() -> NSMenuItem {
        let closeMenuItem  = NSMenuItem()
        closeMenuItem.title = "Close"
        closeMenuItem.action = #selector(NSApplication.shared.terminate)
        return closeMenuItem
    }
}
