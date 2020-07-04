//
//  LoggerTests.swift
//  RSSISnifferTests
//
//  Created by Robert Huston on 7/3/20.
//  Copyright © 2020 Pinpoint Dynamics. All rights reserved.
//

import XCTest

@testable import RSSISniffer

class LoggerTests: XCTestCase {

    let testFileName = "TestFile.txt"

    var testFileURL: URL!

    override func setUpWithError() throws {
        let sbxHomeDirectory = NSHomeDirectory()
        let sbxDocumentDirectory = sbxHomeDirectory + "/Documents"
        print("sbxDocumentDirectory = \(sbxDocumentDirectory)")
        testFileURL = URL(fileURLWithPath: sbxDocumentDirectory + "/\(testFileName)")

        // Make sure we start with no file existing from any previous tests
        if FileManager.default.fileExists(atPath: testFileURL.path) {
            try! FileManager.default.removeItem(at: testFileURL)
        }
        XCTAssert( !FileManager.default.fileExists(atPath: testFileURL.path) )
    }

    override func tearDownWithError() throws {
        testFileURL = nil
    }

    func testReturnsDocumentDirectoryURL() throws {
        let actual = Logger.makeDocumentFileURL(fileName: testFileName)

        XCTAssertEqual(actual, testFileURL)
    }

    func testRemovesExistingFile() {
        let fileData = "hello, world".data(using: .utf8)
        var success = FileManager.default.createFile(atPath: testFileURL.path, contents: fileData, attributes: nil)
        XCTAssert(success)
        XCTAssert( FileManager.default.fileExists(atPath: testFileURL.path) )

        Logger.remove(fileName: testFileName)

        success = FileManager.default.fileExists(atPath: testFileURL.path)
        XCTAssert(!success)
    }

    func testClearsExistingFile() {
        let fileData = "hello, there".data(using: .utf8)
        let success = FileManager.default.createFile(atPath: testFileURL.path, contents: fileData, attributes: nil)
        XCTAssert(success)
        XCTAssert( FileManager.default.fileExists(atPath: testFileURL.path) )

        Logger.clear(fileName: testFileName)

        XCTAssert( FileManager.default.fileExists(atPath: testFileURL.path) )
        let fh = try! FileHandle(forReadingFrom: testFileURL)
        fh.seek(toFileOffset: 0)
        let fileDataRead = fh.availableData
        fh.closeFile()
        let dataRead = String(data: fileDataRead, encoding: .utf8)!
        XCTAssertEqual(dataRead, "")
    }

    func testClearCreatesEmptyFileWhenNotYetExisting() {
        XCTAssert( !FileManager.default.fileExists(atPath: testFileURL.path) )
        
        Logger.clear(fileName: testFileName)

        XCTAssert( FileManager.default.fileExists(atPath: testFileURL.path) )
        let fh = try! FileHandle(forReadingFrom: testFileURL)
        fh.seek(toFileOffset: 0)
        let fileDataRead = fh.availableData
        fh.closeFile()
        let dataRead = String(data: fileDataRead, encoding: .utf8)!
        XCTAssertEqual(dataRead, "")
    }

    func testReadRetrievesFileData() {
        let fileText = "A hollow voice says \"Plugh!\""

        let fileData = fileText.data(using: .utf8)
        let success = FileManager.default.createFile(atPath: testFileURL.path, contents: fileData, attributes: nil)
        XCTAssert(success)
        XCTAssert( FileManager.default.fileExists(atPath: testFileURL.path) )

        let dataRead = Logger.read(fileName: testFileName)

        XCTAssertEqual(dataRead, fileText)
    }

    func testReadReturnsEmptyStringForNonExistingFile() {
        let dataRead = Logger.read(fileName: testFileName)

        XCTAssertEqual(dataRead, "")
    }

    func testWriteCreatesNewFileWhenNotYetExisting() {
        XCTAssert( !FileManager.default.fileExists(atPath: testFileURL.path) )

        let fileText = "A cheerful little bird is sitting here singing."

        Logger.write(fileName: testFileName, text: fileText)

        XCTAssert( FileManager.default.fileExists(atPath: testFileURL.path) )
        let fh = try! FileHandle(forReadingFrom: testFileURL)
        fh.seek(toFileOffset: 0)
        let fileDataRead = fh.availableData
        fh.closeFile()
        let dataRead = String(data: fileDataRead, encoding: .utf8)!
        let parts = dataRead.components(separatedBy: ",")
        let timeValue = TimeInterval(parts[0])
        XCTAssertNotNil(timeValue)
        XCTAssertEqual(parts[1], fileText)
    }

    func testWriteAppendsNewTextToExistingFile() {
        let fileData = "12345,XYZZY,".data(using: .utf8)
        let success = FileManager.default.createFile(atPath: testFileURL.path, contents: fileData, attributes: nil)
        XCTAssert(success)
        XCTAssert( FileManager.default.fileExists(atPath: testFileURL.path) )

        let fileText = "PLUGH"

        Logger.write(fileName: testFileName, text: fileText)

        XCTAssert( FileManager.default.fileExists(atPath: testFileURL.path) )
        let fh = try! FileHandle(forReadingFrom: testFileURL)
        fh.seek(toFileOffset: 0)
        let fileDataRead = fh.availableData
        fh.closeFile()
        let dataRead = String(data: fileDataRead, encoding: .utf8)!
        let parts = dataRead.components(separatedBy: ",")
        XCTAssertEqual(parts[0], "12345")
        XCTAssertEqual(parts[1], "XYZZY")
        let timeValue = TimeInterval(parts[0])
        XCTAssertNotNil(timeValue)
        XCTAssertEqual(parts[3], fileText)
    }

    func testWriteLnAppendsNewTextWithLineFeed() {
        XCTAssert( !FileManager.default.fileExists(atPath: testFileURL.path) )

        Logger.writeLn(fileName: testFileName, text: "XYZZY")
        Logger.writeLn(fileName: testFileName, text: "PLUGH")

        XCTAssert( FileManager.default.fileExists(atPath: testFileURL.path) )
        let fh = try! FileHandle(forReadingFrom: testFileURL)
        fh.seek(toFileOffset: 0)
        let fileDataRead = fh.availableData
        fh.closeFile()
        let dataRead = String(data: fileDataRead, encoding: .utf8)!
        let lines = dataRead.components(separatedBy: "\n")
        // line1
        var parts = lines[0].components(separatedBy: ",")
        var timeValue = TimeInterval(parts[0])
        XCTAssertNotNil(timeValue)
        XCTAssertEqual(parts[1], "XYZZY")
        // line2
        parts = lines[1].components(separatedBy: ",")
        timeValue = TimeInterval(parts[0])
        XCTAssertNotNil(timeValue)
        XCTAssertEqual(parts[1], "PLUGH")
        // line3
        XCTAssertEqual(lines[2], "")
    }

}
