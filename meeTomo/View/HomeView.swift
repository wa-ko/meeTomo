//
//  HomeView.swift
//  meeTomo
//
//  Created by 若生優希 on 2024/04/09.
//

import SwiftUI

struct HomeView: View {
    @State var isShowAdd = false
    @State private var isShowSetting = false
    //カメラ使用
    @State private var isPresentedCameraView = false
    @State private var image: UIImage?
//    @AppStorage("friends") var friends: [Friends] = []
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
                            .presentationDetents([.medium])
                    })
                    Spacer()
                    VStack{
                        Text("吉川花子")
                        Text("2024/03/30")
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
//                            .presentationDetents([.medium])
                    })
                }
                .padding()
                Spacer()
                ZStack{
                    Rectangle()
                        .foregroundColor(.gray)
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
                        Text("山田正一")
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
}
