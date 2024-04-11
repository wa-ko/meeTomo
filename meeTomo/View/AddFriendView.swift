//
//  AddFriendView.swift
//  meeTomo
//
//  Created by 若生優希 on 2024/04/09.
//
import SwiftUI

struct AddFriendView:View {
    @State private var selectedFriend = ""
    //テスト用変数
    @State private var friendsTest = ["友達1", "友達2", "友達3"]
    @State var friends: [Friends] = []
    @State private var date = Date()
    @State private var image = UIImage()
    @State private var isShowPhotoLibrary = false
    @Binding var isShowAdd: Bool
    @State var isAddNewFriend = false
    @State private var text = ""
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Picker("友達選択", selection: $selectedFriend) {
                    ForEach(friendsTest, id: \.self) {
                        Text($0).tag($0)
                    }
                }
                Button(action: {
                    isAddNewFriend.toggle()
                }, label: {
                    Image(systemName: "plus")
                })
                .alert("アラート", isPresented: $isAddNewFriend) {
                    TextField("名前を入力してください", text: $text)
                    Button {
                        friendsTest.append(text)
                        text = ""
                    } label: {
                        Text("OK")
                    }
                    Button(role: .cancel) {
                        text = ""
                    } label: {
                        Text("aosdjf")
                    }
                }
            }
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
