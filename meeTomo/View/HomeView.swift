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
    @State private var currentIndex = 0

    var body: some View {
        NavigationView {
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
                            if !friends.isEmpty {
                                Text(friends[currentIndex % friends.count].name)
                                    .foregroundColor(.gray)
//                                if let latestPhoto = friends[currentIndex % friends.count].latestPhoto() {
//                                    let formatter = DateFormatter()
//                                    formatter.dateFormat = "yyyy/MM/dd"  // Or any other format you prefer
//                                    let dateString = formatter.string(from: latestPhoto.date)
//                                    Text(dateString)
//                                        .foregroundColor(.gray)
                            } else {
                                Text("友達がいません")
                                    .foregroundColor(.gray)
                            }
//                            VStack {
//                                let formatter = DateFormatter()
//                                formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
//                                return Text(formatter.string(from:friends[currentIndex % friends.count].latestPhoto()?.date ?? Date()))
//                                    .foregroundColor(.gray)
//                            }
//                            .foregroundColor(.gray)
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
                            .fill(Color.gray)
                            .rectangleStyle(rotationDegrees: 4)
                        Rectangle()
                            .fill(Color.gray)
                            .rectangleStyle(rotationDegrees: -6)
                        NavigationLink(destination: DataView()) {
                            Rectangle()
                                .fill(Color.gray)
                                .rectangleStyle(rotationDegrees: 0)
                        }
                        if !friends.isEmpty {
                            if let latestPhoto = friends[currentIndex % friends.count].latestPhoto(), let image = UIImage(data: latestPhoto.image) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 300, height: 500)
                            } else {
                                Text("No photos available")
                            }
                        } else {
                            Text("友達がいません")
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
                            if !friends.isEmpty {
                                Button {
                                    currentIndex = (currentIndex + 1) % (friends.count)
                                } label: {
                                    Text("next →")
                                        .foregroundColor(.gray)
                                        .font(.title3)
                                }
                                Text(friends.isEmpty ? "友達がいません" : "\(friends[(currentIndex + 1) % friends.count].name)")
                            } else {
                                Text("next →")
                                    .foregroundColor(.gray)
                                    .font(.title3)
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
}

#Preview {
    HomeView()
        .modelContainer(for: Friend.self)
}
