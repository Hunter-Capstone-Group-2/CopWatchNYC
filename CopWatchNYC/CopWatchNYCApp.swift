//
//  CopWatchNYCApp.swift
//  CopWatchNYC
//
//  Created by Sachin Panayil on 3/17/23.
//

import SwiftUI

@main
struct CopWatchNYCApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
