import SwiftUI
import SwiftData

struct AddFriendView: View {
    @Environment(\.modelContext) private var context
    @Query private var friends: [Friend]
    
    @State private var selectedFriendName = ""
    @State private var date = Date()
    @State private var image = UIImage()
    @State private var text = ""
    @State var selectedImage: UIImage?
    @State var isAddNewFriend = false
    @State var showDatePicker = false
    @Binding var isShowAdd: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) { // Set alignment to leading
                header
                
                friendPicker
                
                datePickerButton
                
                if showDatePicker {
                    CustomDatePickerView(selectedDate: $date, showDatePicker: $showDatePicker)
                        .transition(.opacity)
                }
                
                selectImageLabel
                
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 200)
                        .cornerRadius(10)
                }
                
                SinglePhotoPicker(selectedImage: $selectedImage, showImage: false)
                
                addButton
            }
            .padding()
            .padding(.top, 40) // Additional padding for the top part
        }
        .background(LinearGradient(gradient: Gradient(colors: [.darkWarm1, .darkWarm2]), startPoint: .top, endPoint: .bottom)
            .opacity(0.8))
        .shadow(radius: 20)
        .navigationTitle("Add Friend")
    }
    
    private var header: some View {
        HStack {
            Text("Add a New Friend")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Spacer()
        }
    }
    
    private var friendPicker: some View {
        VStack(alignment: .leading, spacing: 10) {
            DropdownMenu(selectedFriendName: $selectedFriendName, friends: friends)
                .padding(.horizontal, 0)
            
            Button(action: {
                isAddNewFriend.toggle()
            }, label: {
                HStack {
                    Image(systemName: "plus")
                    Text("Add New Friend")
                }
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
                .foregroundColor(.white)
            })
            .alert("Enter Friend's Name", isPresented: $isAddNewFriend) {
                TextField("Name", text: $text)
                Button("OK") {
                    if text.isEmpty {
                        print("Name is empty")
                    } else {
                        let newFriend = Friend(name: text, photos: [])
                        context.insert(newFriend)
                        selectedFriendName = newFriend.name  // Automatically select the new friend
                        text = ""
                    }
                }
                Button("Cancel", role: .cancel) {
                    text = ""
                }
            }
        }
    }
    
    private var datePickerButton: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Select Date")
                .foregroundColor(.white)
                .font(.headline)
            
            Button(action: {
                withAnimation {
                    showDatePicker.toggle()
                }
            }) {
                Text(date, style: .date)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
        }
    }
    
    private var selectImageLabel: some View {
        Text("Select Image")
            .foregroundColor(.white)
            .font(.headline)
    }
    
    private var addButton: some View {
        Button(action: {
            if selectedFriendName.isEmpty || selectedImage == nil {
                print("Data is missing")
            } else {
                let selectedFriend = friends.first { $0.name == selectedFriendName }
                if let selectedFriend = selectedFriend {
                    let newPhoto = Photo(date: date, image: selectedImage?.pngData() ?? Data())
                    selectedFriend.photos.append(newPhoto)
                    selectedImage = nil
                    date = Date()
                    isShowAdd.toggle()
                }
            }
        }) {
            Text("Add")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.darkWarm1)
                .cornerRadius(10)
                .foregroundColor(.customLightText)
        }
    }
}

extension Color {
    static let darkWarm1 = Color(red: 36 / 255, green: 16 / 255, blue: 9 / 255)
    static let darkWarm2 = Color(red: 69 / 255, green: 29 / 255, blue: 20 / 255)
    static let customAccentColor = Color(red: 255 / 255, green: 180 / 255, blue: 0 / 255)
    static let customLightText = Color.white
}

#Preview {
    AddFriendView(isShowAdd: .constant(true))
        .modelContainer(for: Friend.self)
}
