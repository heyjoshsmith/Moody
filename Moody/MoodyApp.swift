//
//  MoodyApp.swift
//  Moody
//
//  Created by Josh Smith on 11/2/22.
//

import SwiftUI

@main
struct MoodyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
