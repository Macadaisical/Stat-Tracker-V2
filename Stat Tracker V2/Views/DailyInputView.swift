//
//  DailyInputView 2.swift
//  Stat Tracker V2
//
//  Created by TJ jaglinski on 12/11/24.
//


import SwiftUI
import SwiftData

// MARK: - DailyInputView
struct DailyInputView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Category.sortOrder, order: .forward) private var categories: [Category]

    @State private var dailyInputs: [UUID: Int] = [:]
    @State private var showSaveConfirmation = false
    @State private var isEditing = false

    var body: some View {
        NavigationView {
            VStack {
                if isEditing {
                    Text("Drag to reorder categories")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding()
                }

                List {
                    ForEach(categories) { category in
                        HStack {
                            Text(category.name)
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.trailing, 10)
                                .accessibilityLabel("Category: \(category.name)")

                            IncrementableTextField(value: Binding(
                                get: { dailyInputs[category.id] ?? 0 },
                                set: { dailyInputs[category.id] = $0 }
                            ))
                            .frame(width: 80)
                            .accessibilityLabel("Input value for \(category.name)")
                        }
                    }
                    .onMove(perform: isEditing ? moveCategory : nil)
                }
            }
            .navigationTitle("Daily Input")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(isEditing ? "Done" : "Reorder") {
                        isEditing.toggle()
                    }
                }
                ToolbarItem(placement: .automatic) {
                    Button("Save") {
                        saveDailyInputs()
                        showSaveConfirmation = true
                    }
                    .accessibilityLabel("Save inputs")
                }
            }
            .alert(isPresented: $showSaveConfirmation) {
                Alert(
                    title: Text("Success"),
                    message: Text("Daily inputs saved successfully."),
                    dismissButton: .default(Text("OK"))
                )
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
            DataManager.handleError(error, message: "Failed to save daily inputs")
        }
    }

    private func moveCategory(from source: IndexSet, to destination: Int) {
        var reorderedCategories = categories
        reorderedCategories.move(fromOffsets: source, toOffset: destination)

        for (index, category) in reorderedCategories.enumerated() {
            category.sortOrder = index
        }

        do {
            try context.save()
        } catch {
            DataManager.handleError(error, message: "Failed to reorder categories")
        }
    }
}
