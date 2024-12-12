import SwiftUI
import SwiftData

struct EditCategoryView: View {
    @Bindable var category: Category
    @Environment(\.dismiss) private var dismiss
    var onDelete: (Category) -> Void

    @State private var showDeleteConfirmation = false

    var body: some View {
        VStack {
            Form {
                TextField("Category Name", text: $category.name)
                    .textFieldStyle(.roundedBorder)
            }
            HStack {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                Button("Save") {
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
                Button("Delete") {
                    showDeleteConfirmation = true
                }
                .foregroundColor(.red)
            }
            .padding()
        }
        .frame(width: 300, height: 200)
        .navigationTitle("Edit Category")
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("Delete Category"),
                message: Text("Are you sure you want to delete the category \"\(category.name)\"?"),
                primaryButton: .destructive(Text("Delete")) {
                    onDelete(category)
                    dismiss()
                },
                secondaryButton: .cancel()
            )
        }
    }
}
