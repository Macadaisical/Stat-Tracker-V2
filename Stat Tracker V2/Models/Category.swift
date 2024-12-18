import Foundation
import SwiftData

// MARK: - Category Model
@Model
final class Category {
    @Attribute(.unique) var id: UUID // Unique identifier
    var name: String // Category name
    var total: Int = 0 // Monthly total for the category

    @Attribute var sortOrder: Int = 0 // Attribute to store category order

    init(name: String, total: Int = 0, sortOrder: Int = 0) {
        self.id = UUID()
        self.name = name.trimmingCharacters(in: .whitespaces)
        self.total = total
        self.sortOrder = sortOrder
    }
}

