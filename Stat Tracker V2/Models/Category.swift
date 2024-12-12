import Foundation
import SwiftData

@Model
final class Category {
    @Attribute(.unique) var id: UUID // Unique identifier
    var name: String // Category name
    var total: Int = 0 // Monthly total for the category

    init(name: String, total: Int = 0) {
        self.id = UUID()
        self.name = name.trimmingCharacters(in: .whitespaces)
        self.total = total
    }
}
