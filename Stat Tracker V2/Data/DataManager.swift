// Stat Tracker V2 Code Rewritten with Improvements

import SwiftUI
import SwiftData
import UserNotifications

// MARK: - DataManager
struct DataManager {

    // MARK: - Preload Categories
    static func preloadCategories(context: ModelContext) {
        do {
            let descriptor = FetchDescriptor<Category>()
            let existingCategories = try context.fetch(descriptor)

            if existingCategories.isEmpty {
                let initialCategories = ["SCOPE Events", "Other Public Events", "Chamber Events", "DCSO Website", "DCSO App"]
                for name in initialCategories {
                    let category = Category(name: name)
                    context.insert(category)
                }
                try context.save() // Save changes
                print("Categories preloaded successfully.")
            }
        } catch {
            handleError(error, message: "Error during preloadCategories")
        }
    }

    // MARK: - Add Daily Input
    static func addDailyInput(context: ModelContext, category: Category, value: Int) {
        guard value > 0 else {
            print("Invalid value: \(value). Input must be greater than zero.")
            return
        }

        let input = DailyInput(date: Date(), value: value, category: category)
        context.insert(input)

        // Update the category total
        category.total += value

        do {
            try context.save()
            print("Daily input added successfully.")
        } catch {
            handleError(error, message: "Error saving daily input")
        }
    }

    // MARK: - Reset Monthly Totals
    static func resetMonthlyTotals(context: ModelContext) {
        do {
            let descriptor = FetchDescriptor<Category>()
            let categories = try context.fetch(descriptor)
            for category in categories {
                category.total = 0 // Reset totals
            }
            try context.save()
            print("Monthly totals reset successfully.")
        } catch {
            handleError(error, message: "Error resetting monthly totals")
        }
    }

    // MARK: - Export to CSV
    static func exportToCSV(context: ModelContext) -> URL? {
        do {
            let descriptor = FetchDescriptor<Category>()
            let categories = try context.fetch(descriptor)

            let fileName = "MonthlyTotals.csv"
            let path = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
            var csvString = "Category,Total\n"

            for category in categories {
                csvString += "\(category.name),\(category.total)\n"
            }

            try csvString.write(to: path, atomically: true, encoding: .utf8)
            print("Data exported to: \(path)")
            return path
        } catch {
            handleError(error, message: "Error exporting to CSV")
            return nil
        }
    }

    // MARK: - Error Handler
    static func handleError(_ error: Error, message: String) {
        print("\(message): \(error.localizedDescription)")
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = "Error"
            alert.informativeText = message
            alert.alertStyle = .critical
            alert.runModal()
        }
    }
}




