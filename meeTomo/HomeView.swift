//
//  HomeView.swift
//  meeTomo
//
//  Created by 若生優希 on 2024/04/09.
//

import SwiftUI

struct HomeView: View {
    @State var howBack: Int = 1
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

                    }, label: {
                        Image(systemName: "plus")
                            .foregroundColor(.gray)
                            .font(.title3)
                    })
                }
                .padding()
                Spacer()
                Rectangle()
                    .foregroundColor(.gray)
                Spacer()
                HStack{
                    Button(action: {
                        Picker("test", selection: $howBack){
                            Text("1つ後ろに").tag(1)
                            Text("半分後ろに").tag(2)
                            Text("一番後ろに").tag(3)
                            Text("戻る").tag(4)
                        }
                    }, label: {
                        Image(systemName: "return")
                            .foregroundColor(.gray)
                            .font(.title3)
                    })
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
