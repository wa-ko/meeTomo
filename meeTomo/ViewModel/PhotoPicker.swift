//
//  PhotoPicker.swift
//  meeTomo
//
//  Created by 若生優希 on 2024/04/10.
//
// 全ての機能を使ったPhotosPickerの実装まとめ

import SwiftUI
import PhotosUI

struct AllMethodsPhotosPicker: View {
    /// フォトピッカー内で選択したアイテムが保持されるプロパティ
    @State var selectedItems: [PhotosPickerItem] = []
    /// PhotosPickerItem -> UIImageに変換したアイテムを格納するプロパティ
    @State var selectedImages: [UIImage] = []

    var body: some View {

        VStack {
            // 配列内にUIImageデータが存在すれば表示
            if !selectedImages.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(selectedImages, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 300, height: 200)
                        }
                    }
                }
            }
            // ピッカーを表示するビュー
            PhotosPicker(
                selection: $selectedItems,
                maxSelectionCount: 1,
                matching: .images
            ) {
                Text("写真を選択")
            }
        }
        .onChange(of: selectedItems) { items in
            // 複数選択されたアイテムをUIImageに変換してプロパティに格納していく
            Task {
                selectedImages = []
                for item in items {
                    guard let data = try await item.loadTransferable(type: Data.self) else { continue }
                    guard let uiImage = UIImage(data: data) else { continue }
                    selectedImages.append(uiImage)
                }
            }
        }
    }
}

#Preview {
    AllMethodsPhotosPicker()
}
