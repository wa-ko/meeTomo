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
    @Query private var friends: [Friend]
    @Query(sort: \Photo.date) private var photos: [Photo]
    var animationNamespace: Namespace.ID
    
    var body: some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(friends, id: \.id) { friend in
                    ForEach(friend.photos, id: \.date) { photo in
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
                    }
                }
            }
            .padding()
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView(animationNamespace: Namespace().wrappedValue)
            .modelContainer(for: Friend.self)
    }
}


#Preview {
    GalleryView(animationNamespace: Namespace().wrappedValue)
        .modelContainer(for: Friend.self)
}
