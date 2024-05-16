// PolaroidView.swift
import SwiftUI

struct PolaroidView<Destination: View>: View {
    var image: UIImage?
    var rotationDegrees: Double
    var destination: Destination?
    var width: CGFloat
    var height: CGFloat
    var date: String?
    
    var body: some View {
        Group {
            if let destination = destination {
                NavigationLink(destination: destination) {
                    content
                }
            } else {
                content
            }
        }
        .rotationEffect(Angle.degrees(rotationDegrees))
    }
    
    @ViewBuilder
    private var content: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .frame(width: width, height: height)
                .shadow(color: Color.black, radius: 10, x: 0, y: 0)
            
            VStack {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: width - 20, height: height - 100)
                        .padding(.bottom, 10)  // Adjusted bottom margin
                } else {
                    Text("No photo available")
                        .foregroundColor(.gray)
                }
                
                if let date = date {
                    Text(date)
                        .font(.caption)
                        .foregroundColor(.black)
                        .padding(.top, 5)
                }
            }
        }
    }
}

struct PolaroidView_Previews: PreviewProvider {
    static var previews: some View {
        PolaroidView(image: UIImage(named: ""), rotationDegrees: 0, destination: DataView(), width: 300, height: 500, date: "2024-05-16")
    }
}
