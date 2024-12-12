//
//  ContentView.swift
//  Stat Tracker V2
//
//  Created by TJ jaglinski on 12/10/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CategoriesView()
                .tabItem {
                    Label("Categories", systemImage: "list.bullet")
                }

            DailyInputView()
                .tabItem {
                    Label("Daily Input", systemImage: "pencil")
                }

            MonthlySummaryView()
                .tabItem {
                    Label("Summary", systemImage: "chart.bar")
                }
        }
        .tabViewStyle(DefaultTabViewStyle()) // Default style for consistent look
    }
}
#Preview {
    ContentView()
        .modelContainer(for: Category.self, inMemory: true)
}
