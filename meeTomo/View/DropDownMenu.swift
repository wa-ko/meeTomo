import SwiftUI

struct DropdownMenu: View {
    @Binding var selectedFriendName: String
    var friends: [Friend]
    
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Select Friend")
                .foregroundColor(.white)
                .font(.headline)
            
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(selectedFriendName.isEmpty ? "Choose a friend" : selectedFriendName)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
            }
            
            if isExpanded {
                VStack(alignment: .center, spacing: 10) {
                    ScrollView {
                        ForEach(friends.prefix(5), id: \.id) { friend in
                            Button(action: {
                                selectedFriendName = friend.name
                                isExpanded = false
                            }) {
                                Text(friend.name)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(10)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                    .frame(maxHeight: 250)
                }
                .background(BlurView(style: .systemUltraThinMaterialDark).cornerRadius(10))
            }
        }
    }
}
//
//#Preview {
//    DropdownMenu(selectedFriendName: .constant("Choose a friend"), friends: [
//        Friend(name: "Alice", photos: []),
//        Friend(name: "Bob", photos: []),
//        Friend(name: "Charlie", photos: []),
//        Friend(name: "David", photos: []),
//        Friend(name: "Eve", photos: []),
//        Friend(name: "Frank", photos: [])
//    ])
//}
