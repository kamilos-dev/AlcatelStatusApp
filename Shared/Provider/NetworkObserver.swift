//
//  NetworkObserver.swift
//  AlcatelApp
//
//  Created by Kamil Szymeczko on 09/04/2022.
//

import Foundation

class NetworkObserver {
    static let instance = NetworkObserver()
    
    private var timer: Timer
    
    var onSsidChange: ((String?) -> Void)?
    
    var currentSsidName: String? = nil
    
    init() {
        Logger.Log("NetworkObserver zainicjalizowany.")
        timer = Timer()
    }
    
    deinit {
        timer.invalidate()
        Logger.Log("NetworkObserver dekonstruktor.")
    }
    
    func changeCurrentSsidName(newName: String?) {
        if currentSsidName == newName {
            return
        }
        
        Logger.Log("Nazwa SSID uległa zmianie.")
        currentSsidName = newName
        onSsidChange?(currentSsidName)
    }
    
    func start() {
        Logger.Log("NetworkObserver - startuje timer.")
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { _ in
            self.changeCurrentSsidName(newName: NetworkHelper.GetSsidName())
        })
        Logger.Log("NetworkObserver - wystartowano timer.")
    }
}
