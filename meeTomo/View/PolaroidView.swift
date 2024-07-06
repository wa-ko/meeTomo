//
//  PolaroidView.swift
//  meeTomo
//
//  Created by Satya on 2024/05/16.
//
import SwiftUI

struct PolaroidView: View {
    var image: UIImage?
    var rotationDegrees: Double
    var destination: AnyView?
    var width: CGFloat
    var height: CGFloat
    var date: String?
    var namespace: Namespace.ID
    var id: UUID
    
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
        .matchedGeometryEffect(id: id, in: namespace)
    }
    
    @ViewBuilder
    private var content: some View {
        ZStack {
            Rectangle()
                .fill(Color.polaroidGray)
                .frame(width: width, height: height)
                .shadow(color: Color.black, radius: 10, x: 0, y: 0)
            
            VStack {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: width - 20, height: height - 100)
                        .padding(.bottom, 10)
                }
                
                if let date = date {
                    Text(date)
                        .font(.caption)
                        .foregroundColor(.black)
                        .frame(width: width - 20, alignment: .leading)
                        .padding([.leading, .bottom], 10)
                        
                }
            }
        }
    }
}

#Preview {
    PolaroidView(image: UIImage(named: ""), rotationDegrees: 0, destination: nil, width: 300, height: 500, date: "2024-05-16", namespace: Namespace().wrappedValue, id: UUID())
}
