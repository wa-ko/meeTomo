//
//  AddFriendView.swift
//  meeTomo
//
//  Created by 若生優希 on 2024/04/09.
//
import SwiftUI

struct AddFriendView:View {
    @State private var selectedFriend = 0
    @State private var friends = ["友達1", "友達2", "友達3"]
    @State private var date = Date()
    var body: some View {
        VStack{
            Spacer()
            Text("名前")
            Picker("友達選択", selection: $selectedFriend) {
                ForEach(friends, id: \.self) {
                    Text($0)
                }
            }
            Button(action: {
                
            }, label: {
                Text("友達追加")
            })
            Spacer()
            DatePicker("日にち",
                       selection: $date,
                       displayedComponents: [.date]
            )
            Spacer()
            Text("写真選択")
            Spacer()
        }
    }
}

struct Friends {
    var name: String
    var date: String
    var photo: String
}

#Preview {
    AddFriendView()
}
