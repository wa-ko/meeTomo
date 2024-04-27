//
//  HomeView.swift
//  meeTomo
//
//  Created by 若生優希 on 2024/04/09.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    //SwiftData
    @Environment(\.modelContext) private var context
    @Query private var friends: [Friend]
//    @Query(sort: \Photo.date) private var photos: [Photo]

    @State var isShowAdd = false
    @State private var isShowSetting = false
    //カメラ使用
    @State private var isPresentedCameraView = false
    @State private var image: UIImage?
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.92)
                .ignoresSafeArea()
            VStack{
                HStack{
                    Button(action: {
                        isShowSetting.toggle()
                    }, label: {
                        Image(systemName: "gearshape")
                            .foregroundColor(.gray)
                            .font(.title3)
                    })
                    .sheet(isPresented: $isShowSetting, content: {
                        SettingView()
                    })
                    Spacer()
                    VStack{
                        Text("\(friends.first?.name ?? "友達がいません")")
                            .foregroundColor(.gray)
                        VStack{
                            let formatter = DateFormatter()
                            formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
                            return Text(formatter.string(from: friends.first?.photos.first?.date ?? Date()))
                                .foregroundColor(.gray)
                        }
                    }
                    .foregroundColor(.gray)
                    Spacer()
                    Button(action: {
                        isShowAdd.toggle()
                    }, label: {
                        Image(systemName: "plus")
                            .foregroundColor(.gray)
                            .font(.title3)
                    })
                    .sheet(isPresented: $isShowAdd, content: {
                        AddFriendView(isShowAdd: $isShowAdd)
                    })
                }
                .padding()
                Spacer()
                ZStack{
                    Rectangle()
                        .fill(.gray)
                        .frame(width: 300, height: 500)
                    ForEach(friends.first?.photos ?? [], id: \.date) { photo in
                        Image(uiImage: UIImage(data: photo.image) ?? UIImage())
                            .resizable()
                            .scaledToFit()
                    }
                }
                Spacer()
                HStack{
                    Menu{
                        Button{
                        } label: {
                            Label("1つ後ろに", systemImage: "rectangle.stack.badge.plus")
                        }
                        Button{
                        } label: {
                            Label("半分後ろに", systemImage: "folder.badge.plus")
                        }
                        Button{
                        } label: {
                            Label("1番後ろに", systemImage: "rectangle.stack.badge.person.crop")
                        }
                    } label: {
                        Image(systemName: "return")
                            .foregroundColor(.gray)
                            .font(.title3)
                    }
                    Spacer()

                    VStack {
                        Text("next →")
                        if (1 < friends.count) {
                            Text("\(friends[1].name)")
                        } else {
                            Text("友達がいません")
                        }
                    }
                        .foregroundColor(.gray)
                    Spacer()
                    VStack {
                        Button {
                            isPresentedCameraView = true
                        } label: {
                            Image(systemName: "camera")
                                .foregroundColor(.gray)
                                .font(.title3)
                        }
                        if let image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300)
                        }
                    }
                    .fullScreenCover(isPresented: $isPresentedCameraView) {
                        CameraView(image: $image).ignoresSafeArea()
                    }
                }
                .padding()
            }
            .padding()
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Friend.self)
}
