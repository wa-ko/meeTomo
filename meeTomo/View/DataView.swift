//
//  DataView.swift
//  meeTomo
//
//  Created by 若生優希 on 2024/04/27.
//

import SwiftUI
import SwiftData

struct DataView: View {
    //SwiftData
    @Environment(\.modelContext) private var context
    @Query private var friends: [Friend]
    var body: some View {
        processFriends() // 友達の情報を表示するメソッドを呼び出す
    }

    @ViewBuilder
    private func processFriends() -> some View {
        VStack(alignment: .leading) {
            ForEach(friends, id: \.id) { friend in
                Text("Friend Name: \(friend.name)")
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(friend.photos, id: \.date) { photo in
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Photo Date: \(photo.date)")
                            if let uiImage = UIImage(data: photo.image) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                            }
                        }
                    }
                }
                .padding(.vertical, 8)
                .border(Color.gray) // 友達ごとの区切りを明示するために境界線を追加
            }
        }
    }
}

#Preview {
    DataView()
        .modelContainer(for: Friend.self)
}
