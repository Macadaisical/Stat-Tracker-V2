import SwiftUI
import SwiftData

struct CategoriesView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Category.name, order: .forward) private var categories: [Category]

    @State private var selectedCategory: Category? = nil {
        didSet {
            if selectedCategory == nil {
                showEditSheet = false
            }
        }
    }
    @State private var showEditSheet: Bool = false
    @State private var showDeleteAllConfirmation: Bool = false


    var body: some View {
        NavigationView {
            VStack {
                if categories.isEmpty {
                    Text("No categories found. Add a new category to get started.")
                        .foregroundColor(.gray)
                        .italic()
                } else {
                    List {
                        ForEach(categories) { category in
                            HStack {
                                Text(category.name)
                                    .onTapGesture {
                                        if selectedCategory != category {
                                            selectedCategory = category
                                            showEditSheet = true
                                        }
                                    }
                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Categories")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(action: addCategory) {
                        Label("Add Category", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .automatic) {
                    Button(action: {
                        showDeleteAllConfirmation = true
                    }) {
                        Label("Delete All", systemImage: "trash")
                    }
                }
            }
            .sheet(isPresented: $showEditSheet, onDismiss: {
                selectedCategory = nil
            }) {
                if let selectedCategory = selectedCategory {
                    EditCategoryView(category: selectedCategory, onDelete: deleteCategory)
                }
            }
            .alert(isPresented: $showDeleteAllConfirmation) {
                Alert(
                    title: Text("Delete All Categories"),
                    message: Text("Are you sure you want to delete all categories? This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete All")) {
                        deleteAllCategories()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }

    private func addCategory() {
        let newCategory = Category(name: "New Category")
        context.insert(newCategory)
        saveContext()
        selectedCategory = newCategory
        showEditSheet = true
    }

    private func deleteCategory(_ category: Category) {
        context.delete(category)
        saveContext()
        selectedCategory = nil
        showEditSheet = false
    }
    
    private func deleteAllCategories() {
        for category in categories {
            context.delete(category)
        }
        saveContext()
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
}
