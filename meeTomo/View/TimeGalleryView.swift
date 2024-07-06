import SwiftUI
import SwiftData

struct TimeGalleryView: View {
    @Query private var friends: [Friend]
    @State private var selectedPhoto: Photo?
    @Namespace private var animationNamespace
    
    private var photosByDate: [String: [Photo]] {
        Dictionary(grouping: friends.flatMap { $0.photos }.sorted { $0.date > $1.date }) { photo in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: photo.date)
        }
    }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(photosByDate.keys.sorted(by: >), id: \.self) { date in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(date)
                                .font(.headline)
                                .padding(.leading)
                                .foregroundColor(.white)
                            
                            Divider()
                                .background(Color.gray)
                            
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(photosByDate[date] ?? [], id: \.date) { photo in
                                    if let uiImage = UIImage(data: photo.image) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 100, height: 100)
                                            .clipped()
                                            .cornerRadius(8)
                                            .onTapGesture {
                                                withAnimation(.spring(response: 0.5, dampingFraction: 0.75, blendDuration: 0.5)) {
                                                    selectedPhoto = photo
                                                }
                                            }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [.backgroundGreen, .backgroundOrange]), startPoint: .top, endPoint: .bottom)
                    .opacity(0.95)
                    .edgesIgnoringSafeArea(.all)
            )
            
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
        .navigationTitle("Time Gallery")
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    TimeGalleryView()
        .modelContainer(for: Friend.self)
}
