//
//  copwatchApp.swift
//  copwatch
//
//  Created by Ramy on 2/23/23.
//

import SwiftUI
import FirebaseCore

@main
struct CopWatchNYCApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
