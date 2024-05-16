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
    @State private var image: UIImage?
    @State private var currentIndex = 0
    @State private var showGallery = false
    @Namespace private var animationNamespace
    
    var body: some View {
        NavigationView {
            ZStack {
                if showGallery {
                    GalleryView(animationNamespace: animationNamespace)
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
        }
    }
    
    private var topBar: some View {
        HStack {
            Button(action: {
                isShowSetting.toggle()
            }) {
                Image(systemName: "gearshape")
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
                    withAnimation {
                        showGallery.toggle()
                    }
                }
            PolaroidView(image: image, rotationDegrees: -6, destination: nil, width: 300, height: 500, namespace: animationNamespace, id: UUID())
                .onTapGesture {
                    withAnimation {
                        showGallery.toggle()
                    }
                }
            PolaroidView(image: image, rotationDegrees: 0, destination: nil, width: 300, height: 500, namespace: animationNamespace, id: UUID())
                .onTapGesture {
                    withAnimation {
                        showGallery.toggle()
                    }
                }
            if !friends.isEmpty {
                if let latestPhoto = friends[currentIndex % friends.count].latestPhoto(), let image = UIImage(data: latestPhoto.image) {
                    PolaroidView(image: image, rotationDegrees: 0, destination: nil, width: 300, height: 500, namespace: animationNamespace, id: UUID())
                        .onTapGesture {
                            withAnimation {
                                showGallery.toggle()
                            }
                        }
                } else {
                    Text("No photos available")
                }
            } else {
                Text("友達がいません")
            }
        }
    }
    
    private var bottomBar: some View {
        HStack {
            Menu {
                Button {} label: {
                    Label("1つ後ろに", systemImage: "rectangle.stack.badge.plus")
                }
                Button {} label: {
                    Label("半分後ろに", systemImage: "folder.badge.plus")
                }
                Button {} label: {
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
}

#Preview {
    HomeView()
        .modelContainer(for: Friend.self)
}
