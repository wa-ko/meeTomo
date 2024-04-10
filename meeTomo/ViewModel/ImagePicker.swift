//
//  ImagePicker.swift
//  meeTomo
//
//  Created by 若生優希 on 2024/04/10.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    // MARK: - Working with UIViewControllerRepresentable
    var sourceType: UIImagePickerController.SourceType = .photoLibrary

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator  // Coordinater to adopt UIImagePickerControllerDelegate Protcol.
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

    // MARK: - Using Coordinator to Adopt the UIImagePickerControllerDelegate Protocol
    @Binding var selectedImage: UIImage
    @Environment(\.presentationMode) private var presentationMode

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }

            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}


struct ImagePickerView: View {
    @State private var image = UIImage()
    @State private var isShowPhotoLibrary = false

    var body: some View {
        VStack {
            Image(uiImage: self.image)
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity)
                .edgesIgnoringSafeArea(.all)
            Button(action: {
                self.isShowPhotoLibrary = true
            }, label: {
                Text("Photo Library")
                    .padding()
            })
        }
        .sheet(isPresented: $isShowPhotoLibrary, content: {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
        })
    }
}

#Preview {
    ImagePickerView()
}
