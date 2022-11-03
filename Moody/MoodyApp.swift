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
    
    init() {
        let mind = Mind.shared
        _mind = StateObject(wrappedValue: mind)
    }

    var body: some Scene {
        WindowGroup {
            TodayView()
                .environment(\.managedObjectContext, mind.container.viewContext)
                .environmentObject(mind)
        }
    }
}
