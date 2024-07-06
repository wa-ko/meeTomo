//
//  TimeGalleryView.swift
//  meeTomo
//
//  Created by 若生優希 on 2024/07/06.
//

import SwiftUI
import SwiftData

struct TimeGalleryView: View {
    @Query private var friends: [Friend]
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
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 16) {
                ForEach(photosByDate.keys.sorted(by: >), id: \.self) { date in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(date)
                            .font(.headline)
                            .padding(.leading)

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
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
        }
        .navigationTitle("Time Gallery")
    }
}
