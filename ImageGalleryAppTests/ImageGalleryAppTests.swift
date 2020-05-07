//
//  ImageGalleryAppTests.swift
//  ImageGalleryAppTests
//
//  Created by Lucas Menezes on 5/1/20.
//  Copyright © 2020 Lucas Menezes. All rights reserved.
//

import XCTest
@testable import ImageGalleryApp

class ImageGalleryAppTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearch() {
        let exp = XCTestExpectation()
        let api = API()
        api.search(query: "pikachu", completion: { (page) in
            XCTAssert(page != nil)
            exp.fulfill()
        }, page: 1)
        
        wait(for: [exp], timeout: 2)
    }
    func testGetURLs() {
        let exp = XCTestExpectation()
        let api = API()
        api.search(query: "game", completion: { (page) in
            for photo in page?.photo ?? [] {
                let id = photo.id ?? ""
                api.getAllImagesForId(id: id) { (sizes) in
                    XCTAssert(sizes.count > 0)
                    exp.fulfill()
                }
            }
        }, page: 1)
        wait(for: [exp], timeout: 2)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
