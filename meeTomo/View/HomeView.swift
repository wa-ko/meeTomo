//
//  HomeView.swift
//  meeTomo
//
//  Created by Satya on 2024/05/17.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var context
    @Query private var friends: [Friend]
    @State var isShowAdd = false
    @State private var isShowSetting = false
    @State private var isPresentedCameraView = false
    @State private var isShowTimeGallery = false
    @State private var image: UIImage?
    @State private var currentIndex = 0
    @State private var isShowGallery = false
    @State private var selectedFriend: Friend? = nil
    @Namespace private var animationNamespace

    var body: some View {
        NavigationStack {
            ZStack {
                if isShowGallery, let selectedFriend = selectedFriend {
                    GalleryView(friend: selectedFriend, animationNamespace: animationNamespace) {
                        withAnimation {
                            isShowGallery = false
                        }
                    }
                    .transition(.move(edge: .bottom))
                } else {
                    VStack {
                        topBar
                        Spacer()
                        photoStack
                        Spacer()
                        bottomBar
                    }
                    .padding()
                    .transition(.move(edge: .top))
                }
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [.backgroundGreen, .backgroundOrange]), startPoint: .top, endPoint: .bottom)
                    .opacity(0.95)
            )
            .navigationDestination(isPresented: $isShowTimeGallery) {
                TimeGalleryView()
                    .transition(.move(edge: .trailing))
            }
        }
    }

    private var topBar: some View {
        HStack {
            Button(action: {
                isShowSetting.toggle()
            }) {
                Image(systemName: "person.crop.circle.badge.minus")
                    .foregroundColor(.gray)
                    .font(.title3)
            }
            .sheet(isPresented: $isShowSetting) {
                SettingView()
            }
            Spacer()
            VStack {
                if !friends.isEmpty {
                    Text(friends[currentIndex % friends.count].name)
                        .foregroundColor(.gray)
                } else {
                    Text("友達がいません")
                        .foregroundColor(.gray)
                }
            }
            .foregroundColor(.gray)
            Spacer()
            Button(action: {
                isShowAdd.toggle()
            }) {
                Image(systemName: "plus")
                    .foregroundColor(.gray)
                    .font(.title3)
            }
            .sheet(isPresented: $isShowAdd) {
                AddFriendView(isShowAdd: $isShowAdd)
            }
        }
        .padding()
    }

    private var photoStack: some View {
        ZStack {
            PolaroidView(image: image, rotationDegrees: 4, destination: nil, width: 300, height: 500, namespace: animationNamespace, id: UUID())
                .onTapGesture {
                    selectedFriend = friends[currentIndex % friends.count]
                    withAnimation {
                        isShowGallery.toggle()
                    }
                }
            PolaroidView(image: image, rotationDegrees: -6, destination: nil, width: 300, height: 500, namespace: animationNamespace, id: UUID())
                .onTapGesture {
                    selectedFriend = friends[currentIndex % friends.count]
                    withAnimation {
                        isShowGallery.toggle()
                    }
                }
            PolaroidView(image: image, rotationDegrees: 0, destination: nil, width: 300, height: 500, namespace: animationNamespace, id: UUID())
                .onTapGesture {
                    selectedFriend = friends[currentIndex % friends.count]
                    withAnimation {
                        isShowGallery.toggle()
                    }
                }
            if !friends.isEmpty {
                if let latestPhoto = friends[currentIndex % friends.count].latestPhoto(), let image = UIImage(data: latestPhoto.image) {
                    PolaroidView(image: image, rotationDegrees: 0, destination: nil, width: 300, height: 500, namespace: animationNamespace, id: UUID())
                        .onTapGesture {
                            selectedFriend = friends[currentIndex % friends.count]
                            withAnimation {
                                isShowGallery.toggle()
                            }
                        }
                } else {
                    Text("No photos available")
                        .foregroundColor(.gray)
                }
            } else {
                Text("友達がいません")
                    .foregroundColor(.gray)
            }
        }
    }

    private var bottomBar: some View {
        HStack {
            Button {
                isShowTimeGallery = true
            } label: {
                Image(systemName: "photo.on.rectangle.angled")
                    .foregroundColor(.gray)
                    .font(.title3)
            }
            Spacer()

            VStack {
                if !friends.isEmpty {
                    Button {
                        currentIndex = (currentIndex + 1) % friends.count
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
            }
            .fullScreenCover(isPresented: $isPresentedCameraView) {
                CameraView(image: $image).ignoresSafeArea()
            }
            .onChange(of: image) {
                friends.first{$0.name == friends[currentIndex % friends.count].name}?.photos.append(Photo(date: Date(), image: image?.pngData() ?? Data()))
            }
        }
        .padding()
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Friend.self)
}
