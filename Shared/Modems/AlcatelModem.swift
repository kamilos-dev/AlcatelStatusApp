//
//  AlcatelModem.swift
//  AlcatelApp
//
//  Created by Kamil Szymeczko on 09/04/2022.
//

import Foundation

struct SystemStatus {
    var batteryCap: Int32 = 0
    var batteryLvl: Int32 = 0 // 3 - kiedy pojemnosc jest 61, 4 - 90%
    var chargerState: Int32 = 0 // 0 - podłączony do ładowarki i ładuje,  1 - podłączony ale pełna bateria  2- z baterii
}

class AlcatelModem : MobileModem {
    
    private static let rootUrl = "http://192.168.8.1/jrd/webapi?api=";
    private static var loginToken = String?(nil)
    
    func getBatteryInfo() -> BatteryInfo? {
        if AlcatelModem.loginToken == nil {
            login()
        }
        
        let status = getSystemStatus()
        
        if status == nil {
            return nil
        }
        
        return BatteryInfo(
            isCharging: (0...1).contains(status!.chargerState), level: status!.batteryCap)
    }
    func getConnectedDevices() -> [ConnectedDevice] {
        login()
        
        return getConnectedDevicesList()
    }
    
    func sendSms(_ sms: SmsInput!) {
        login()
        sendSmsLocal(sms)
    }
    
    private func sendSmsLocal(_ sms: SmsInput!) {
        let method = "SendSMS"
        
        let url = URL(string: AlcatelModem.rootUrl + method)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request = AlcatelModem.setHeaders(request: request)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        let userData: [String: JSON] = [
          "SMSId": .integer(-1),
          "SMSContent": .string(sms.text),
          "PhoneNumber": .string(sms.to),
          "SMSTime": .string(dateFormatter.string(from: Date())),
        ]
            
        request.httpBody = AlcatelModem.getBody(method: method, params: userData).data(using: .utf8)
     
        Logger.Log("Wysyłam SMSa")
        let result = HttpClient.sendRequest(request: request)!
        Logger.Log(String(decoding: result, as: UTF8.self))
    }
    
    private func login() {
        let method = "Login"
        
        let url = URL(string: AlcatelModem.rootUrl + method)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request = AlcatelModem.setHeaders(request: request)
        
        let password = Configuration.infoForKey("PASSWORD")!
        
        let userData: [String: JSON] = [
          "UserName": .string(Encoding.encode(value: "admin")),
          "Password": .string(Encoding.encode(value: password))
        ]
            
        request.httpBody = AlcatelModem.getBody(method: method, params: userData).data(using: .utf8)
     
        let result = HttpClient.sendRequest(request: request)
              
        if let result = result {
            if let statusesArray = try? JSONSerialization.jsonObject(with: result, options: .allowFragments) as? [String: Any],
            let result = statusesArray["result"] as? [String: Any],
            let token = result["token"] as? Int64 {
                AlcatelModem.loginToken = Encoding.encode(value: String(token))
            }
        }
    }
    
    private func getSystemStatus() -> SystemStatus? {
        let method = "GetSystemStatus"
        
        let url = URL(string: AlcatelModem.rootUrl + method)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request = AlcatelModem.setHeaders(request: request)
        
        let userData: [String: JSON] = [:]
            
        request.httpBody = AlcatelModem.getBody(method: method, params: userData).data(using: .utf8)
     
        let result = HttpClient.sendRequest(request: request)
        if let result = result {
            
            if let statusesArray = try? JSONSerialization.jsonObject(with: result, options: .allowFragments) as? [String: Any],
            let result = statusesArray["result"] as? [String: Any],
            let batteryCap = result["bat_cap"] as? Int32,
            let batteryLevel = result["bat_level"] as? Int32,
            let chargerState = result["chg_state"] as? Int32 {
                print (batteryCap, batteryLevel, chargerState)
                
                return SystemStatus(
                    batteryCap: batteryCap, batteryLvl: batteryLevel, chargerState: chargerState)
            }
        }
        
        return nil
    }
    
    private func getConnectedDevicesList() -> [ConnectedDevice]! {
        let method = "GetConnectedDeviceList"
        
        let url = URL(string: AlcatelModem.rootUrl + method)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request = AlcatelModem.setHeaders(request: request)
                    
        request.httpBody = AlcatelModem.getBody(method: method, params: [:]).data(using: .utf8)
        
        var connectedDevices: [ConnectedDevice] = []
        
        let result = HttpClient.sendRequest(request: request)
        if let result = result {
            
            if let statusesArray = try? JSONSerialization.jsonObject(with: result, options: .allowFragments) as? [String: Any],
            let result = statusesArray["result"] as? [String: Any],
            let devices = result["ConnectedList"] as? [[String: Any]] {
                for device in devices {
                    connectedDevices.append(ConnectedDevice(name: (device["DeviceName"] as! String), ipAddress: (device["IPAddress"] as! String)))
                }
            }
        }
        
        return connectedDevices
    }
    
    private static func setHeaders(request : URLRequest) -> URLRequest {
        var request = request
        request.addValue("http://192.168.8.1/index.html", forHTTPHeaderField: "Referer")
        request.addValue("KSDHSDFOGQ5WERYTUIQWERTYUISDFG1HJZXCVCXBN2GDSMNDHKVKFsVBNf", forHTTPHeaderField: "_TclRequestVerificationKey")
        
        if loginToken != nil {
            request.addValue(loginToken ?? "null", forHTTPHeaderField: "_TclRequestVerificationToken")
        }
        
        return request
    }
    
    private static func getBody(method: String, params: [String: JSON]) -> String {
        
        let body: [String: JSON] = [
            "jsonrpc": .string("2.0"),
            "method": .string(method),
            "id": .string("1.1"),
            "params": .object(params)
        ]
        
        return try! String(decoding: JSONEncoder().encode(body), as: UTF8.self)
    }
}
