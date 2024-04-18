//
//  AddFriendView.swift
//  meeTomo
//
//  Created by 若生優希 on 2024/04/09.
//
import SwiftUI
import PhotosUI

struct AddFriendView:View {
    @State private var selectedFriend = ""
    //テスト用変数
    @State var friends: [Friends] = []
    @State private var date = Date()
    @State private var image = UIImage()
    @State private var isShowPhotoLibrary = false
    @Binding var isShowAdd: Bool
    @State var isAddNewFriend = false
    @State private var text = ""
    @State var selectedItem: PhotosPickerItem?

    var body: some View {
        VStack{
            Spacer()
            HStack{
                Picker("友達選択", selection: $selectedFriend) {
                    ForEach(friends) { friend in
                        Text(friend.name).tag(friend.id)
                    }
                }
                Button(action: {
                    isAddNewFriend.toggle()
                }, label: {
                    Image(systemName: "plus")
                })
                .alert("名前を入力してください", isPresented: $isAddNewFriend) {
                    TextField("名前を入力してください", text: $text)
                    Button {
                        friends.append(Friends(name: text, photos: nil))
                        text = ""
                    } label: {
                        Text("OK")
                    }
                    Button(role: .cancel) {
                        text = ""
                    } label: {
                        Text("cancel")
                    }
                }
            }
            Spacer()
            DatePicker("日にち", selection: $date,
                       displayedComponents: [.date]
            )
            .labelsHidden()
            Spacer()
            SinglePhotoPicker(selectedItem: PhotosPickerItem?)
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
