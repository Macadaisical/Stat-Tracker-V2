import SwiftUI

struct IncrementableTextField: View {
    @Binding var value: Int

    var body: some View {
        HStack(spacing: 20) {
            // TextField for manual number entry
            TextField("", value: $value, formatter: numberFormatter())
                .textFieldStyle(.automatic)
                .multilineTextAlignment(.center)
                .onSubmit {
                    if value < 0 { value = 0 } // Prevent negative values
                }
                .frame(width: 60)
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
            // Up and Down Arrow Buttons
            VStack(spacing: 0) {
                Button(action: { value += 1 }) {
                    Image(systemName: "chevron.up")
                        .frame(maxWidth: .infinity, maxHeight: 5)
                }
                Button(action: { value = max(0, value - 1) }) {
                    Image(systemName: "chevron.down")
                        .frame(maxWidth: .infinity, maxHeight: 5)
                }
            }
            .frame(width: 10)
        }
        .gesture(DragGesture()
            .onChanged { gesture in
                handleScrollGesture(gesture)
            })
    }

    // MARK: - Helper Methods
    private func handleScrollGesture(_ gesture: DragGesture.Value) {
        if gesture.translation.height > 0 {
            value = max(0, value - 1) // Dragging down decreases the value
        } else if gesture.translation.height < 0 {
            value += 1 // Dragging up increases the value
        }
    }

    private func numberFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimum = 0
        return formatter
    }
}
