//
//  FriendStructure.swift
//  meeTomo
//
//  Created by 若生優希 on 2024/04/10.
//

import Foundation

struct Friends: Identifiable{
    var id = UUID()
    var name: String
    var photos: [Photo]?

    struct Photo {
        var date: Date
        var image: Data
    }
}
