import SwiftUI
import SwiftData

struct GalleryView: View {
    @Environment(\.modelContext) private var context
    @State private var editMode = false
    @State private var selectedPhoto: Photo?
    var friend: Friend
    var animationNamespace: Namespace.ID
    var dismiss: () -> Void
    
    var body: some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        ZStack { // Use ZStack to overlay the enlarged image
            VStack {
                topBar
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(friend.photos, id: \.date) { photo in
                            ZStack(alignment: .topLeading) {
                                if let image = UIImage(data: photo.image) {
                                    PolaroidView(
                                        image: image,
                                        rotationDegrees: 0,
                                        destination: nil,
                                        width: 150,
                                        height: 250,
                                        date: formatDate(photo.date),
                                        namespace: animationNamespace,
                                        id: UUID()
                                    )
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.5, dampingFraction: 0.75, blendDuration: 0.5)) {
                                            selectedPhoto = photo // Set selected photo when tapped
                                        }
                                    }
                                } else {
                                    PolaroidView(
                                        image: nil,
                                        rotationDegrees: 0,
                                        destination: nil,
                                        width: 150,
                                        height: 250,
                                        date: formatDate(photo.date),
                                        namespace: animationNamespace,
                                        id: UUID()
                                    )
                                }
                                if editMode {
                                    Button(action: {
                                        deletePhoto(photo)
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                            .padding(8)
                                            .background(Color.white)
                                            .clipShape(Circle())
                                            .shadow(radius: 4)
                                    }
                                    .padding([.top, .leading], 8)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            
            if let selectedPhoto = selectedPhoto, let image = UIImage(data: selectedPhoto.image) {
                Color.black.opacity(0.5).ignoresSafeArea()
                VStack {
                    Spacer()
                    PolaroidView(
                        image: image,
                        rotationDegrees: 0,
                        destination: nil,
                        width: 300,
                        height: 500,
                        date: formatDate(selectedPhoto.date),
                        namespace: animationNamespace,
                        id: UUID()
                    )
                    Spacer()
                }
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.1), Color.black.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
                        .blur(radius: 20)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.75, blendDuration: 0.5)) {
                                self.selectedPhoto = nil
                            }
                        }
                )
                .transition(.opacity)
            }
        }
    }
    
    private var topBar: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.gray)
                    .font(.title3)
            }
            Spacer()
            Text(friend.name)
                .foregroundColor(.gray)
                .font(.title3)
            Spacer()
            Button(action: {
                editMode.toggle()
            }) {
                Text(editMode ? "Done" : "Edit")
                    .foregroundColor(.gray)
                    .font(.title3)
            }
        }
        .padding()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func deletePhoto(_ photo: Photo) {
        if let index = friend.photos.firstIndex(where: { $0.date == photo.date }) {
            friend.photos.remove(at: index)
            do {
                try context.save()
            } catch {
                print("Failed to delete photo: \(error)")
            }
        }
    }
}

#Preview {
    GalleryView(friend: Friend(name: "Satta", photos: [Photo(date: Date(), image: Data())]), animationNamespace: Namespace().wrappedValue, dismiss: {})
        .modelContainer(for: Friend.self)
}
