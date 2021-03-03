//
//  GifsList_DemoAppUITests.swift
//  GifsList_DemoAppUITests
//
//  Created by Dominik Urbaez Gomez on 26/02/2021.
//

import XCTest

class GifsList_DemoAppUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
    }
    
    func testDisplaysListView() {
        app.launch()
        let collectionView = XCUIApplication().collectionViews.element
        XCTAssert(collectionView.exists)
        XCTAssertTrue(app.isDisplayingListView)
    }
    
    func testDisplaysBookmarks() {
        app.launch()
        XCTAssertTrue(app.isDisplayingListView)
        
        let collectionView = XCUIApplication().collectionViews.element
        XCTAssert(collectionView.exists)
        let bookmarksButton = XCUIApplication().navigationBars.buttons["bookmarksButton"]
        XCTAssert(bookmarksButton.exists)
        bookmarksButton.tap()
        XCTAssertTrue(app.isDisplayingBookmarks)
    }
    
    func testDisplaysDetailView() {
        app.launch()
        XCTAssertTrue(app.isDisplayingListView)
        
        let collectionView = XCUIApplication().collectionViews.element
        XCTAssert(collectionView.exists)
        
        let firstCell = collectionView.cells["firstCell"]
        firstCell.tap()
        
        XCTAssertTrue(app.isDisplayingDetailView)
    }
    
    func testUpdatesBookmarkIconAfterChangeInDetailView() {
        app.launch()
        XCTAssertTrue(app.isDisplayingListView)
        
        let collectionView = XCUIApplication().collectionViews.element
        XCTAssert(collectionView.exists)
        
        var firstCell = app.collectionViews.children(matching: .any).element(boundBy: 0)
        if firstCell.exists {
            firstCell.tap()
        }
        XCTAssertTrue(app.isDisplayingDetailView)
        
        let bookmarksButton = XCUIApplication().navigationBars.buttons["bookmarksButtonDetailView"]
        XCTAssert(bookmarksButton.exists)
        bookmarksButton.tap()
        
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        XCTAssertTrue(app.isDisplayingListView)
        
        firstCell = app.collectionViews.children(matching: .any).element(boundBy: 0)
        let cellBookmarkButton = firstCell.buttons["bookmarkCellButton"]
        XCTAssert(cellBookmarkButton.exists)
        XCTAssertTrue(cellBookmarkButton.isSelected)
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

extension XCUIApplication {
    var isDisplayingListView: Bool {
        return otherElements["listView"].exists
    }
    
    var isDisplayingBookmarks: Bool {
        return otherElements["bookmarksView"].exists
    }
    
    var isDisplayingDetailView: Bool {
        return otherElements["detailView"].exists
    }
}
