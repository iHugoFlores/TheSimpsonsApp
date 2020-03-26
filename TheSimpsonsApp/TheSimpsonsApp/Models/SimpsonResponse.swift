//
//  SimpsonResponse.swift
//  TheSimpsonsApp
//
//  Created by Field Employee on 3/26/20.
//  Copyright © 2020 Hugo Flores. All rights reserved.
//

import Foundation

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

class SimpsonResponse {
    func loadJson(filename fileName: String) -> MainResponse? {
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
}
