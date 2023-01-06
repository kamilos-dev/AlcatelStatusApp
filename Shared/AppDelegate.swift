//
//  AppDelegate.swift
//  Shared
//
//  Created by Kamil Szymeczko on 08/04/2022.
//

import SwiftUI
import UserNotifications
import Foundation

class AppDelegate: NSObject, NSApplicationDelegate {
    private var window: NSWindow!
    private var appService: AppService!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {       
        appService = AppService()
        
        let networkObserver = NetworkObserver.instance
        networkObserver.onSsidChange = appService.refreshData
        networkObserver.start()
    }
}
