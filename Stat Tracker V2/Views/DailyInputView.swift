//
//  DailyInputView 2.swift
//  Stat Tracker V2
//
//  Created by TJ jaglinski on 12/11/24.
//


import SwiftUI
import SwiftData

struct DailyInputView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Category.name, order: .forward) private var categories: [Category]

    @State private var dailyInputs: [UUID: Int] = [:]
    @State private var showSaveConfirmation = false

    var body: some View {
        NavigationView {
            List {
                ForEach(categories) { category in
                    HStack {
                        Text(category.name)
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.trailing, 10)

                        IncrementableTextField(value: Binding(
                            get: { dailyInputs[category.id] ?? 0 },
                            set: { dailyInputs[category.id] = $0 }
                        ))
                        .frame(width: 80)
                    }
                }
            }
            .navigationTitle("Daily Input")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Save") {
                        saveDailyInputs()
                        showSaveConfirmation = true
                    }
                }
            }
            .alert(isPresented: $showSaveConfirmation) {
                Alert(title: Text("Success"), message: Text("Daily inputs saved successfully."), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func saveDailyInputs() {
        for (categoryID, value) in dailyInputs {
            guard let category = categories.first(where: { $0.id == categoryID }) else { continue }
            category.total += value
        }

        do {
            try context.save()
            dailyInputs.removeAll()
        } catch {
            print("Failed to save daily inputs: \(error)")
        }
    }
}
