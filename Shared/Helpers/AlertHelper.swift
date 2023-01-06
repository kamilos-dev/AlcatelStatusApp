//
//  AlertHelper.swift
//  AlcatelApp (macOS)
//
//  Created by Kamil Szymeczko on 13/04/2022.
//

import Foundation
import SwiftUI

class AlertHelper {
    public static func showWarning(_ title: String, _ description: String) -> Void {

        let alert = NSAlert()

        alert.messageText = title
        alert.informativeText = description
        alert.addButton(withTitle: "OK")
        alert.alertStyle = .warning

        alert.runModal()
    }
}
