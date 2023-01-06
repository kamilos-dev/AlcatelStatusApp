//
//  AppService.swift
//  AlcatelApp
//
//  Created by Kamil Szymeczko on 09/04/2022.
//

import Foundation
import SwiftUI

class AppService {
    
    private var timer: Timer
    private let appStatusBarService: AppStatusBarService!
    
    private var modem: MobileModem? = nil
    private var modemDataGetter: ModemDataGetter!
    
    private var alertIsShown: Bool = false
    
    init() {
        self.appStatusBarService = AppStatusBarService()
        timer = Timer()
    }
    
    deinit {
        timer.invalidate()
    }
    
    func refreshData(_ ssidName: String?) -> Void {
        timer.invalidate()
        
        if ssidName == nil {
            Logger.Log("Brak nazwy sieci. Czekam na podłączenie.")
            appStatusBarService.setNoWifiConnection()
            return
        }
        
        let ssidName = ssidName!
        self.modem = ModemProvider.getMobileModem(ssidName)
                
        if self.modem == nil {
            Logger.Log("Brak modemu dla danej sieci. Czekam na zmianę WIFI.")
            appStatusBarService.setNotSupportedWifi()
            return
        }
        
        self.modemDataGetter = ModemDataGetter(self.modem)
        self.modemDataGetter.onBatteryInfoChange = refreshBatteryInfo;
        self.modemDataGetter.onConnectedDevicesChange = appStatusBarService.setConnectedDevices
        
        self.modemDataGetter.getData()
                
        startRefreshDataTimer()
    }
    
    private func startRefreshDataTimer() {
        Logger.Log("Uruchamiam odświeżanie danych z modemu co 30 sekund.")
        
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true, block: { _ in
            Logger.Log("Odświeżam dane z modemu.")
            self.modemDataGetter.getData()
        })
    }
    
    private func refreshBatteryInfo(_ batteryInfo: BatteryInfo?) -> Void {
        
        if batteryInfo != nil {
            let batteryInfo = batteryInfo!
            
            if !batteryInfo.isCharging && batteryInfo.level <= 10 {
                let sendSms = Configuration.infoForKey("SEND_SMS")

                if sendSms == "YES" {
                    let numbers = Configuration.infoForKey("PHONE_NUMBERS")!.components(separatedBy: " ")
                    for number in numbers {
                        self.modem?.sendSms(SmsInput(to: number, text: "Witam! To ja, Twój router. Mam mało baterii, tak z 10%. Proszę podłącz we mnię ładowarkę co bym mógł się doładować ⚡️⚡️⚡️"))
                    }
                }
                
                AlertHelper.showWarning("Niski poziom naładowania baterii.", "Poziom baterii spadł poniżej 10%. Podłącz ładowarkę.")
            }
        }
        
        appStatusBarService.setBatteryInfo(batteryInfo)
    }
}
