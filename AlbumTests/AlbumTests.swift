//
//  AlbumTests.swift
//  AlbumTests
//
//  Created by Rohit Kumar on 24/08/20.
//  Copyright © 2020 Rohit Kumar. All rights reserved.
//

import XCTest
@testable import Album

class AlbumTests: XCTestCase {
    
    func testSuccessfulInit() {
        let testSuccessfulDict: [String: Any] = ["trackName": "Test",
                                                 "artistName": "Rohit",
                                                 "collectionName": "Altimetrik",
                                                 "releaseDate": "2010-05-26T18:56:29Z",
                                                 "collectionPrice": 3.21,
                                                 "artworkUrl100": ""
        ]
        
        XCTAssertNotNil(Album(testSuccessfulDict))
    }
}
