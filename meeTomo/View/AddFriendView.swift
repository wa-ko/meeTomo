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
    @State private var image = UIImage()
    @State private var isShowPhotoLibrary = false
    @Binding var isShowAdd: Bool
    var body: some View {
        VStack{
            Spacer()
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
            DatePicker("日にち", selection: $date,
                       displayedComponents: [.date]
            )
            Spacer()
            AllMethodsPhotosPicker()
            Spacer()
            Button(action: {
                isShowAdd.toggle()
            }, label: {
                Text("追加")
            })
        }
    }
}

#Preview {
    AddFriendView(isShowAdd: .constant(true))
}
