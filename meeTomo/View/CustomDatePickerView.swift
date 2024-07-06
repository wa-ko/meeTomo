import SwiftUI

struct CustomDatePickerView: View {
    @Binding var selectedDate: Date
    @Binding var showDatePicker: Bool
    @State private var currentDate: Date
    
    init(selectedDate: Binding<Date>, showDatePicker: Binding<Bool>) {
        self._selectedDate = selectedDate
        self._showDatePicker = showDatePicker
        self._currentDate = State(initialValue: selectedDate.wrappedValue)
    }
    
    var body: some View {
        VStack {
            DatePicker("", selection: $currentDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .labelsHidden()
                .background(BlurView(style: .systemUltraThinMaterialLight))
                .cornerRadius(10)
                .padding()
                .onChange(of: currentDate) { newDate in
                    selectedDate = newDate
                    withAnimation {
                        showDatePicker = false
                    }
                }
                .environment(\.colorScheme, .dark)
                .accentColor(.customAccentColor) // Change the selected date color
        }
        .background(Color.white.opacity(0.2))
        .cornerRadius(10)
        .padding()
    }
}

#Preview {
    CustomDatePickerView(selectedDate: .constant(Date()), showDatePicker: .constant(true))
}
