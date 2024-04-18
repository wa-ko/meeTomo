import SwiftUI
import PhotosUI

struct SinglePhotoPicker: View {
    /// フォトピッカー内で選択したアイテムが保持されるプロパティ
    @Binding var selectedItem: PhotosPickerItem?
    /// PhotosPickerItem -> UIImageに変換したアイテムを格納するプロパティ
    @State private var selectedImage: UIImage?

    var body: some View {

        VStack {
            // UIImageデータが存在すれば表示
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 200)
            }
            // ピッカーを表示するビュー
            PhotosPicker(
                selection: $selectedItem,
                matching: .images
            ) {
                Text("写真を選択")
            }
        }
        .onChange(of: selectedItem) {
            // 選択されたアイテムがあればUIImageに変換してプロパティに格納する
            Task {
                selectedImage = nil
                if let item = selectedItem {
                    guard let data = try await item.loadTransferable(type: Data.self) else { return }
                    guard let uiImage = UIImage(data: data) else { return }
                    selectedImage = uiImage
                }
            }
        }
    }
}
//
//#Preview {
//    SinglePhotoPicker()
//}
