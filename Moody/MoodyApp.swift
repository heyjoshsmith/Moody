//
//  MoodyApp.swift
//  Moody
//
//  Created by Josh Smith on 11/2/22.
//

import SwiftUI

@main
struct MoodyApp: App {
    
    @StateObject var mind: Mind
    @StateObject private var locationManager = LocationManager()
    
    init() {
        let mind = Mind.shared
        _mind = StateObject(wrappedValue: mind)
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, mind.container.viewContext)
                .environmentObject(mind)
                .environmentObject(locationManager)
        }
    }
}
