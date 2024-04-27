//
//  SettingView.swift
//  meeTomo
//
//  Created by 若生優希 on 2024/04/10.
//
import SwiftUI
import SwiftData

struct SettingView: View {
    //SwiftData
    @Environment(\.modelContext) private var context
    @Query private var friends: [Friend]
//    @Query(sort: \Photo.date) private var photos: [Photo]
    @State var isDeleteAlert:Bool = false

    var body: some View {
        List() {
            ForEach(friends) { friend in
                Text(friend.name)
            }
            .onDelete(perform: { indexSet in
                indexSet.forEach { index in
                    context.delete(friends[index])
                }
            })
        }
        EditButton()
    }
}

#Preview {
    SettingView()
        .modelContainer(for: Friend.self)

}
