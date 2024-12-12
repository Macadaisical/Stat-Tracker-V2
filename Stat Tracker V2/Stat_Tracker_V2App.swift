//
//  Stat_Tracker_V2App.swift
//  Stat Tracker V2
//
//  Created by TJ jaglinski on 12/10/24.
//

import SwiftUI
import SwiftData

@main
struct StatTrackerV2App: App {
   
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Category.self, DailyInput.self])
        }
    }
    
}
