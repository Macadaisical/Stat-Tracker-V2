import SwiftUI
import SwiftData

struct MonthlySummaryView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Category.name, order: .forward) private var categories: [Category]

    @State private var showResetConfirmation = false

    var body: some View {
        NavigationView {
            List {
                ForEach(categories) { category in
                    HStack {
                        Text(category.name)
                        Spacer()
                        Text("\(category.total)")
                    }
                }
            }
            .navigationTitle("Monthly Summary")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Reset") {
                        showResetConfirmation = true
                    }
                }
                ToolbarItem(placement: .automatic) {
                    Button("Export") {
                        exportData()
                    }
                }
            }
            .alert(isPresented: $showResetConfirmation) {
                Alert(
                    title: Text("Reset Totals"),
                    message: Text("Are you sure you want to reset all totals?"),
                    primaryButton: .destructive(Text("Reset")) { resetMonthlyTotals() },
                    secondaryButton: .cancel()
                )
            }
        }
    }

    private func resetMonthlyTotals() {
        for category in categories {
            category.total = 0
        }

        do {
            try context.save()
        } catch {
            print("Failed to reset totals: \(error)")
        }
    }

    private func exportData() {
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.commaSeparatedText]
        savePanel.nameFieldStringValue = "MonthlyTotals.csv"

        savePanel.begin { response in
            if response == .OK, let url = savePanel.url {
                saveCSV(to: url)
            }
        }
    }

    private func saveCSV(to url: URL) {
        var csvString = "Category,Total\n"
        for category in categories {
            csvString += "\(category.name),\(category.total)\n"
        }

        do {
            try csvString.write(to: url, atomically: true, encoding: .utf8)
            print("CSV file saved successfully to \(url.path)")
        } catch {
            print("Failed to save CSV file: \(error.localizedDescription)")
        }
    }
}
