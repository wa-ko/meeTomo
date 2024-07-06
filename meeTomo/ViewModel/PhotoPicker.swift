import SwiftUI
import PhotosUI

struct SinglePhotoPicker: View {
    @State private var selectedItem: PhotosPickerItem?
    @Binding var selectedImage: UIImage?
    var showImage: Bool = true
    
    var body: some View {
        VStack {
            if showImage, let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 200)
                    .cornerRadius(10)
            }
            PhotosPicker(
                selection: $selectedItem,
                matching: .images
            ) {
                Text("写真を選択")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
        }
        .onChange(of: selectedItem) { newValue in
            Task {
                selectedImage = nil
                if let item = selectedItem {
                    guard let data = try? await item.loadTransferable(type: Data.self) else { return }
                    guard let uiImage = UIImage(data: data) else { return }
                    selectedImage = uiImage
                }
            }
        }
    }
}

#Preview {
    SinglePhotoPicker(selectedImage: .constant(nil))
}
