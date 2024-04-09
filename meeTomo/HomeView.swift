//
//  HomeView.swift
//  meeTomo
//
//  Created by 若生優希 on 2024/04/09.
//

import SwiftUI

struct HomeView: View {
    @State private var isShowSheet = false
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.92)
                .ignoresSafeArea()
            VStack{
                HStack{
                    Button(action: {

                    }, label: {
                        Image(systemName: "gearshape")
                            .foregroundColor(.gray)
                            .font(.title3)
                    })
                    Spacer()
                    VStack{
                        Text("吉川花子")
                        Text("2024/03/30")
                    }
                    .foregroundColor(.gray)
                    Spacer()
                    Button(action: {
                        isShowSheet.toggle()
                    }, label: {
                        Image(systemName: "plus")
                            .foregroundColor(.gray)
                            .font(.title3)
                    })
                    .sheet(isPresented: $isShowSheet, content: {
                        AddFriendView()
                    })
                }
                .padding()
                Spacer()
                Rectangle()
                    .foregroundColor(.gray)
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
                    Button(action: {

                    }, label: {
                        Image(systemName: "camera")
                            .foregroundColor(.gray)
                            .font(.title3)
                    })
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
