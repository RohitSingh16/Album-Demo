//
//  AlbumViewModelTests.swift
//  Album
//
//  Created by Rohit Kumar on 26/08/20.
//  Copyright © 2020 Rohit Kumar. All rights reserved.
//

import XCTest

class AlbumViewModelTests: XCTestCase {
    
    var viewModel: AlbumViewModel!
    var testModel: [Album] = []
    
    override func setUp() {
        super.setUp()
        viewModel = AlbumViewModel(model: testModel)
    }
    
    func testSuccessfulInit(){
        let testSuccessfulDict: [String: Any] = ["trackName": "Test",
                                                 "artistName": "Rohit",
                                                 "collectionName": "Altimetrik",
                                                 "releaseDate": "2010-05-26T18:56:29Z",
                                                 "collectionPrice": 3.21,
                                                 "artworkUrl100": ""]
        XCTAssertNotNil(AlbumViewModel(model: [Album(testSuccessfulDict)]))
    }
    
    func testFetchAlbumSuccess() {
        let expect = XCTestExpectation(description: "callback")

        viewModel.fetchAlbums(completionHandler: { (albums) in
            expect.fulfill()
            XCTAssertNotNil(albums)
            for album in albums {
                XCTAssertNotNil(album.trackName)
                XCTAssertNotNil(album.artistName)
                XCTAssertNotNil(album.collectionName)
                XCTAssertNotNil(album.collectionPrice)
                XCTAssertNotNil(album.releaseDate)
                XCTAssertNotNil(album.artworkUrl100)
            }
        })
        wait(for: [expect], timeout: 3.1)
    }
}
