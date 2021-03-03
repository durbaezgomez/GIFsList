//
//  GifViewModelTests.swift
//  GifsList_DemoAppTests
//
//  Created by Dominik Urbaez Gomez on 01/03/2021.
//

import XCTest
@testable import GifsList_DemoApp

class GifViewModelTests: XCTestCase {
    
    private var viewModel: GifViewModel!
    private var gif: Gif!
    private var gifDTO: GifDTO!

    override func setUp() {
        gif = Gif(id: "", url: "", username: "", title: "", images: Dictionary<String, GifImage>())
        
        gifDTO = GifDTO(object: gif)
        viewModel = GifViewModel(dto: gifDTO)
        UserDefaults.standard.removeObject(forKey: "Bookmarks")
    }

    func testGettingAnimatedURL() {
        let urlString = "urlString"
        let image = GifImage(height: "1", width: "1", url: urlString)
        
        gif.images?["original"] = image
        
        gifDTO = GifDTO(object: gif)
        viewModel = GifViewModel(dto: gifDTO)
        
        let urlFromViewModel = viewModel.getAnimatedGifURL()
        let assumedUrl = URL(string: urlString)
        
        XCTAssertEqual(urlFromViewModel, assumedUrl)
        
        let imageWithNilUrl =
            GifImage(height: "1", width: "1")
        
        gif.images?["original"] = imageWithNilUrl
        
        gifDTO = GifDTO(object: gif)
        viewModel = GifViewModel(dto: gifDTO)
        
        let urlOrNilFromViewModel = viewModel.getAnimatedGifURL()
        
        XCTAssertNil(urlOrNilFromViewModel)
    }
    
    func testLoopingURL() throws {
        let urlString = "urlString"
        let mp4 = GifImage(height: "303", width: "303", url: "url3", mp4: urlString)

        gif.images?["looping"] = mp4
        
        gifDTO = GifDTO(object: gif)
        viewModel = GifViewModel(dto: gifDTO)
        
        let urlFromViewModel = viewModel.getLoopingUrl() ?? nil
        let assumedUrl = URL(string: urlString) ?? nil
        
        XCTAssertEqual(urlFromViewModel, assumedUrl)
    }
    
    func testTogglingBookmarks() {
        XCTAssertFalse(viewModel.isBookmarked())
        viewModel.toggleBookmark()
        XCTAssertTrue(viewModel.isBookmarked())
    }
}


