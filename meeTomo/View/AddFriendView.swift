//
//  AddFriendView.swift
//  meeTomo
//
//  Created by 若生優希 on 2024/04/09.
//
import SwiftUI
import PhotosUI

struct AddFriendView:View {
    @State private var selectedFriendName = ""
    @State private var date = Date()
    @State private var image = UIImage()
    @State private var text = ""
    @State var isAddNewFriend = false
    @State var selectedImage: UIImage?
    //テスト用変数
    @Binding var friends: [Friend]
    @Binding var isShowAdd: Bool

    var body: some View {
        VStack{
            Spacer()
            HStack{
                Picker("友達選択", selection: $selectedFriendName) {
                    ForEach(friends) { friend in
                        Text(friend.name).tag(friend.name)
                    }
                }
                Text(selectedFriendName)
                Button(action: {
                    isAddNewFriend.toggle()
                }, label: {
                    Image(systemName: "plus")
                })
                .alert("名前を入力してください", isPresented: $isAddNewFriend) {
                    TextField("名前を入力してください", text: $text)
                    Button {
                        if text.isEmpty {
                            return print("名前が入力されていません")
                        } else {
                            friends.append(Friend(name: text, photos: []))
                            text = ""
                        }
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
            SinglePhotoPicker(selectedImage: $selectedImage)
            Spacer()
            Button(action: {
                if selectedFriendName.isEmpty || selectedImage == nil {
                    return print("データが存在しません")
                } else {
                    // 選択された日付と画像から写真データを作成
                    let photo = Friend.Photo(date: date, image: selectedImage?.pngData() ?? Data())
                    friends = friends.map { friend in
                        var friend = friend
                        if friend.name == selectedFriendName {
                            friend.photos.append(photo)
                        }
                        return friend
                    }
                    // 選択された友達の写真リストに写真データを追加
                    print(friends)
    //                 データを追加した後は、選択された画像と日付をリセット
                    selectedImage = nil
                    date = Date()
                    isShowAdd.toggle()
                }

            }, label: {
                Text("追加")
            })
            Spacer()
//            UIImage(data: friends.first?.photos.first?.image ?? Data())?
            processFriends() // 友達の情報を表示するメソッドを呼び出す
        }
    }
    // 友達の情報を表示するメソッド
    @ViewBuilder
    private func processFriends() -> some View {
        VStack(alignment: .leading) {
            ForEach(friends, id: \.id) { friend in
                Text("Friend Name: \(friend.name)")
                Text("Friend id: \(friend.id)")
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
    AddFriendView(friends: .constant([]), isShowAdd: .constant(true))
}
