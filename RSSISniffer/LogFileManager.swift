//
//  LogFileManager.swift
//  RSSISniffer
//
//  Created by Robert Huston on 7/3/20.
//  Copyright © 2020 Pinpoint Dynamics. All rights reserved.
//

import Foundation

class LogFileManager {

    public static func remove(fileName: String) {
        let documentFileURL = makeDocumentFileURL(fileName: fileName)
        do {
            try FileManager.default.removeItem(at: documentFileURL)
        } catch let error {
            print("remove: error removing \(fileName): \(error)")
        }
    }

    public static func clear(fileName: String) {
        let documentFileURL = makeDocumentFileURL(fileName: fileName)

        let fm = FileManager.default
        if fm.fileExists(atPath: documentFileURL.path) == false {
            if fm.createFile(atPath: documentFileURL.path, contents: nil, attributes: nil) == false {
                print("clear: couldn't create \(documentFileURL.path)")
            }
            return
        }

        do {
            let fh = try FileHandle(forWritingTo: documentFileURL)
            try fh.truncate(atOffset: 0)
            fh.closeFile()
        } catch let error {
            print("clear: error truncating \(fileName): \(error)")
        }
    }

    public static func read(fileName: String) -> String {
        var data = ""

        let documentFileURL = makeDocumentFileURL(fileName: fileName)

        guard FileManager.default.fileExists(atPath: documentFileURL.path) == true else { return data }

        do {
            data = try String(contentsOf: documentFileURL, encoding: .utf8)
        } catch let error as NSError {
            print("read: error reading \(fileName): \(error)")
        }

        return data
    }

    public static func write(fileName: String, text: String) {
        let documentFileURL = makeDocumentFileURL(fileName: fileName)

        let fm = FileManager.default
        if fm.fileExists(atPath: documentFileURL.path) == false {
            if fm.createFile(atPath: documentFileURL.path, contents: nil, attributes: nil) == false {
                print("write: couldn't create \(documentFileURL.path)")
                return
            }
        }

        do {
            let now = Date().timeIntervalSince1970
            let csvText = String(now) + "," + text
            let fh = try FileHandle(forWritingTo: documentFileURL)
            fh.seekToEndOfFile()
            fh.write(csvText.data(using: .utf8)!)
            fh.closeFile()
        } catch let error as NSError {
            print("Error writing \(fileName): \(error)")
        }
    }

    public static func writeLn(fileName: String, text: String) {
        write(fileName: fileName, text: text + "\n")
    }

    public static func makeDocumentFileURL(fileName: String) -> URL {
        return LogFileManager.getDocumentDirectoryURL().appendingPathComponent(fileName)
    }

    private static func getDocumentDirectoryURL() -> URL {
        let documentDirectoryURL = try! FileManager.default.url(
            for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true
        )
        return documentDirectoryURL
    }

}
