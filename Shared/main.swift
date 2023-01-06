//
//  main.swift
//  AlcatelApp
//
//  Created by Kamil Szymeczko on 09/04/2022.
//

import Foundation
import SwiftUI


let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
