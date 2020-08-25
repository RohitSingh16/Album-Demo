//
//  Albums.swift
//  Album
//
//  Created by Rohit Kumar on 25/08/20.
//  Copyright © 2020 Rohit Kumar. All rights reserved.
//

import Foundation

struct Album: Codable {
    var trackName: String
    var artistName: String
    var collectionName: String
    var releaseDate: String
    var collectionPrice: Double
    var artworkUrl100: String
    
    init(_ dictionary: [String: Any]) {
        self.trackName = dictionary["trackName"] as? String ?? ""
        self.artistName = dictionary["artistName"] as? String ?? ""
        self.collectionName = dictionary["collectionName"] as? String ?? ""
        self.collectionPrice = dictionary["collectionPrice"] as? Double ?? 0
        self.releaseDate = dictionary["releaseDate"] as? String ?? ""
        self.artworkUrl100 = dictionary["artworkUrl100"] as? String ?? ""
    }
    
}
