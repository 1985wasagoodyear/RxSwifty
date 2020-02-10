//
//  DDGCharacter.swift
//  RxSwifty
//
//  Created by Kevin Yu on 1/21/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import Foundation

struct DDGResponse: Decodable {
    var entries: [DDGEntry] = []
    
    enum CodingKeys: String, CodingKey {
        case entries = "RelatedTopics"
    }
}

struct DDGEntry: Decodable {
    var icon: DDGIcon
    var url: String
    var text: String
    
    enum CodingKeys: String, CodingKey {
        case icon = "Icon"
        case url = "FirstURL"
        case text = "Text"
    }
}

struct DDGIcon: Decodable {
    var url: String
    
    enum CodingKeys: String, CodingKey {
        case url = "URL"
    }
}

