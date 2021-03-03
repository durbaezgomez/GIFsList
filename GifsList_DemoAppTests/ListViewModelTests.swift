//
//  ListViewModelTests.swift
//  ListViewModelTests
//
//  Created by Dominik Urbaez Gomez on 26/02/2021.
//

import XCTest
@testable import GifsList_DemoApp

class ListViewModelTests: XCTestCase {
    
    private var viewModel: ListViewModel!
    private var bookmarkManager: BookmarksManager!

    override func setUp() {
        viewModel = ListViewModel()
        viewModel.gifViewModels = [GifViewModel]()
        bookmarkManager = BookmarksManager()
    }

    func testTranslatingDataToDTO() {
        XCTAssertEqual(viewModel.gifViewModels.count, 0)
        let gifsData = [
            Gif(id: "1", url: "url1", username: "username1", title: "title1", images: Dictionary<String, GifImage>()),
            Gif(id: "2", url: "url2", username: "username2", title: "title2", images: Dictionary<String, GifImage>())
        ]
        viewModel.translateDataToDTO(data: gifsData)
        XCTAssertEqual(viewModel.gifViewModels.count, 2)
    }
    
    func testReturningBookmarkedViewModels() {
        XCTAssertEqual(viewModel.bookmarkedViewModels().count, 0)
        
        let gifId = "1"
        let gifsData = [
            Gif(id: gifId, url: "url1", username: "username1", title: "title1", images: Dictionary<String, GifImage>())
        ]
        viewModel.translateDataToDTO(data: gifsData)
        
        bookmarkManager.add(gifId)
        XCTAssertEqual(viewModel.bookmarkedViewModels().count, 1)
    }
}
