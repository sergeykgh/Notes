
//
//  NotesTests.swift
//  NotesTests
//
//  Created by Sergey Korotkevich on 28/09/2019.
//  Copyright © 2019 Sergey Korotkevich. All rights reserved.
//

import XCTest
@testable import Notes

class NotesTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_parseGetNotesReponse_count_1() {
        let data = "[{\"id\":1, \"title\":\"test\"}]".data(using: .utf8)
        let notes = NotesAPI.parseGetNotesReponse(data: data!)
        XCTAssertEqual(notes?.count, 1, "Count of parsed notes is wrong")
    }

    func test_parseGetNotesReponse_count_2() {
        let data = "[{\"id\":1, \"title\":\"test\"}, {\"id\":2, \"title\":\"test\"}]".data(using: .utf8)
        let notes = NotesAPI.parseGetNotesReponse(data: data!)
        XCTAssertEqual(notes?.count, 2, "Count of parsed notes is wrong")
    }
    
    func test_parseGetNotesReponse_missing_id() {
        let data = "[{\"title\":\"test\"}]".data(using: .utf8)
        let notes = NotesAPI.parseGetNotesReponse(data: data!)
        XCTAssertNil(notes, "Missing id property, notes array should be nil")
    }
    
    func test_parseGetNotesReponse_missing_title() {
        let data = "[{\"id\":1}]".data(using: .utf8)
        let notes = NotesAPI.parseGetNotesReponse(data: data!)
        XCTAssertNil(notes, "Missing title property, notes array should be nil")
    }
    
    func test_parseGetNotesReponse_wrong_type() {
        let data = "[{\"id\":1, \"title\":2}]".data(using: .utf8)
        let notes = NotesAPI.parseGetNotesReponse(data: data!)
        XCTAssertNil(notes, "title property is of wrong type, notes array should be nil")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
