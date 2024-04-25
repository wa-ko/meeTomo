//
//  FriendStructure.swift
//  meeTomo
//
//  Created by 若生優希 on 2024/04/10.
//

import Foundation

struct Friends: Identifiable, Codable {
    var id = UUID()
    var name: String
    var photos: [Photo]

    struct Photo: Codable {
            var date: Date
            var image: Data
    }
}
//
//extension Friends: RawRepresentable {
//    typealias RawValue = String
//
//    init?(rawValue: RawValue) {
//        self.name = rawValue
//        // Initialize other properties as needed
//        self.photos = nil // Assuming photos will be fetched separately
//    }
//
//    var rawValue: RawValue {
//        return name
//    }
//}
