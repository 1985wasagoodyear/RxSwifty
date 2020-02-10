//
//  GBEntry.swift
//  RxSwifty
//
//  Created by K Y on 11/13/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import Foundation

struct GBResponse: Decodable {
    let items: [GBEntry]
}

struct GBEntry: Decodable {
    let volumeInfo: GBVolumeInfo
}

struct GBVolumeInfo: Decodable {
    let title: String
}
