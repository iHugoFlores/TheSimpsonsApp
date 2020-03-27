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
    
    func createDummyData() -> MainResponse {
        let data = [
            RelatedTopic(Text: "Apu Nahasapeemapetilon - Apu Nahasapeemapetilon is a recurring character in the animated TV series The Simpsons. He is an Indian-American immigrant proprietor who runs the Kwik-E-Mart, a popular convenience store in Springfield, and is best known for his catchphrase, \"Thank you, come again.\"", Icon: Icon(URL: "https://duckduckgo.com/i/99b04638.png")),
            RelatedTopic(Text: "Barney Gumble - Barnard Arnold \"Barney\" Gumble is a recurring character in the American animated TV series The Simpsons. He is voiced by Dan Castellaneta and first appeared in the series premiere episode \"Simpsons Roasting on an Open Fire\". Barney is the town drunk of Springfield and Homer Simpson's best friend.", Icon: Icon(URL: "")),
            RelatedTopic(Text: "Bart Simpson - Bartholomew JoJo Simpson is a fictional character in the American animated television series The Simpsons and part of the Simpson family. He is voiced by Nancy Cartwright and first appeared on television in The Tracey Ullman Show short \"Good Night\" on April 19, 1987.", Icon: Icon(URL: "https://duckduckgo.com/i/39ce98c0.png"))]
        let res = MainResponse(Heading: "Some Header", RelatedTopics: data);
        return res;
    }
}
