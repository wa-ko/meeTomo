//
//  FriendStructure.swift
//  meeTomo
//
//  Created by 若生優希 on 2024/04/10.
//

import Foundation
import SwiftData

@Model
class Friend: Identifiable {
    var id = UUID()
    var name: String
    var photos: [Photo]

    init(name: String, photos: [Photo]) {
        self.name = name
        self.photos = photos
    }
}

@Model
class Photo {
    @Relationship(deleteRule: .cascade, inverse: \Friend.photos) var date: Date
    @Relationship(deleteRule: .cascade, inverse: \Friend.photos) var image: Data

    init(date: Date, image:Data) {
        self.date = date
        self.image = image
    }
}

