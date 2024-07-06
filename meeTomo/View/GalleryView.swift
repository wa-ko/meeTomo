//
//  GalleryView.swift
//  meeTomo
//
//  Created by Satya on 2024/05/16.
//
import SwiftUI
import SwiftData

struct GalleryView: View {
    @Environment(\.modelContext) private var context
    @State private var editMode = false
    var friend: Friend
    var animationNamespace: Namespace.ID
    var dismiss: () -> Void
    
    var body: some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
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

//#Preview {
//    let samplePhotos = [
//        Photo(date: Date(), image: UIImage(named: "sampleImag")!.pngData()!),
//        Photo(date: Date().addingTimeInterval(-86400), image: UIImage(named: "sampleImage")!.pngData()!)
//    ]
//    
//    let sampleFriend = Friend(name: "Satya", photos: samplePhotos)
//    
//    return GalleryView(friend: sampleFriend, animationNamespace: Namespace().wrappedValue, dismiss: {})
//        .modelContainer(for: Friend.self)
//}

