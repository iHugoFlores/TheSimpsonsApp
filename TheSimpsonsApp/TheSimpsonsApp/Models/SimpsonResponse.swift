//
//  SimpsonResponse.swift
//  TheSimpsonsApp
//
//  Created by Field Employee on 3/26/20.
//  Copyright © 2020 Hugo Flores. All rights reserved.
//

import Foundation
import UIKit

struct Icon: Decodable {
    enum Category: String, Decodable {
        case swift, combine, debugging, xcode
    }
    
    let URL: String
}

struct RelatedTopic: Decodable {
    enum Category: String, Decodable {
        case swift, combine, debugging, xcode
    }

    var charImg: Data?
    var charName: String {
        return self.Text.components(separatedBy: " - ")[0]
    }
    var charDescription: String {
        return self.Text.components(separatedBy: " - ")[1]
    }
    let Text: String
    let Icon: Icon
}

struct MainResponse: Decodable {
    enum Category: String, Decodable {
        case swift, combine, debugging, xcode
    }

    let Heading: String
    let RelatedTopics: [RelatedTopic]
}

class Character: NSCoder, NSCoding {
    var charName: String
    var charDescription: String
    var imageURL: String
    var imageData: Data?

    func encode(with coder: NSCoder) {
        coder.encode(charName, forKey: "charName")
        coder.encode(charDescription, forKey: "charDescription")
        coder.encode(imageURL, forKey: "imageURL")
        coder.encode(imageData, forKey: "imageData")
    }
    
    required init?(coder aDecoder: NSCoder) {
        if  let charName = aDecoder.decodeObject(forKey: "charName") as? String,
            let charDescription = aDecoder.decodeObject(forKey: "charDescription") as? String,
            let imageURL = aDecoder.decodeObject(forKey: "imageURL") as? String {
            self.charName = charName
            self.charDescription = charDescription
            self.imageURL = imageURL
            self.imageData = aDecoder.decodeObject(forKey: "imageData") as? Data
        } else { return nil }
    }
    
    init(charName: String, charDescription: String, imageURL: String, imageData: Data?) {
        self.charName = charName
        self.charDescription = charDescription
        self.imageURL = imageURL
        self.imageData = imageData
    }
}

class SimpsonResponse {
    static let endpoint = "http://api.duckduckgo.com/?q=simpsons+characters&format=json"
    static let staticJson = "simpsons"
    
    static func loadJson(filename fileName: String) -> MainResponse? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(MainResponse.self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
    static func getData() -> [Character]? {
        do {
            // Try to load from persistence
            return try [Character].readFromPersistence()
        } catch let error as NSError {
            if error.domain == NSCocoaErrorDomain && error.code == NSFileReadNoSuchFileError {
                NSLog("No persistence file found, not necesserially an error...")
            } else {
                NSLog("Error loading from persistence: \(error.localizedDescription)")
            }
        }
        return getMockData()
    }
    
    static func getData(onDone handler: @escaping ([Character]?) -> ()) {
        do {
            // Try to load from persistence
            let res = try [Character].readFromPersistence()
            DispatchQueue.main.async() {
                print("Reading from storage")
                handler(res)
            }
        } catch let error as NSError {
            if error.domain == NSCocoaErrorDomain && error.code == NSFileReadNoSuchFileError {
                NSLog("No persistence file found, not necesserially an error...")
            } else {
                NSLog("Error loading from persistence: \(error.localizedDescription)")
            }
            downloadJsonData(fromURL: URL(string: endpoint)!, onDone: handler)
        }
    }
    
    static func downloadData() -> [Character]? {
        return getMockData()
    }
    
    static func getMockData() -> [Character]? {
        let stored: [RelatedTopic] = loadJson(filename: staticJson)!.RelatedTopics
        return stored.map{ rt in
            Character(charName: rt.charName, charDescription: rt.charDescription, imageURL: rt.Icon.URL, imageData: nil)
        }
    }
    
    static func downloadJsonData(fromURL url: URL, onDone doneHandler: @escaping ([Character]?) -> ()) {
        downloadData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let mainResponse : MainResponse = try JSONDecoder().decode(MainResponse.self, from: data)
                let res = mainResponse.RelatedTopics.map{ rt in
                    Character(charName: rt.charName, charDescription: rt.charDescription, imageURL: rt.Icon.URL, imageData: nil)
                }
                DispatchQueue.main.async() {
                    doneHandler(res)
                }
            } catch {
                DispatchQueue.main.async() {
                    doneHandler(nil)
                }
            }
        }
    }
    
    static func downloadData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    static func downloadImage(fromURL url: URL, onDone doneHandler: @escaping (Data?) -> ()) {
        downloadData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                doneHandler(data)
            }
        }
    }
}

extension Collection where Iterator.Element == Character {
    private static func persistencePath() -> URL? {
        let url = try? FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true)

        return url?.appendingPathComponent("simpsonsData.bin")
    }
    
    // Write the array to persistence
    func writeToPersistence() throws {
        print("Wiriting items to storage")
        if let url = Self.persistencePath(), let array = self as? NSArray {
            let data = NSKeyedArchiver.archivedData(withRootObject: array)
            try data.write(to: url)
        } else {
            throw NSError(domain: "com.example.MyToDo", code: 10, userInfo: nil)
        }
    }
    
    // Read the array from persistence
    static func readFromPersistence() throws -> [Character] {
        if let url = persistencePath(), let data = (try Data(contentsOf: url) as Data?) {
            if let array = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Character] {
                return array
            } else {
                throw NSError(domain: "com.example.MyToDo", code: 11, userInfo: nil)
            }
        } else  {
            throw NSError(domain: "com.example.MyToDo", code: 12, userInfo: nil)
        }
    }
}
