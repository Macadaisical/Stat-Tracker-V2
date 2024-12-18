import Foundation
import SwiftData

// MARK: - DailyInput Model
@Model
final class DailyInput {
    @Attribute(.unique) var id: UUID // Unique identifier
    var date: Date // Date of the input
    var value: Int // Value entered for the category
    var category: Category? // Relationship to a Category

    init(date: Date, value: Int, category: Category) {
        self.id = UUID()
        self.date = date
        self.value = max(0, value) // Ensure non-negative
        self.category = category
    }

    // Helper Method: Check if the input belongs to the current month
    func isCurrentMonth() -> Bool {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        let inputMonth = calendar.component(.month, from: date)
        return currentMonth == inputMonth
    }
}

