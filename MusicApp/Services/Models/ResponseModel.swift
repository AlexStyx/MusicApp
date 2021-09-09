//
//  ResponseModel.swift
//  MusicApp
//
//  Created by Александр Бисеров on 8/23/21.
//

import Foundation

struct ResponseModel: Codable {
    let resultCount: Int
    let results: [TrackModel]
}

struct TrackModel: Codable {
    let artistName: String
    let collectionName: String?
    let trackName: String
    let artworkUrl60: String?
    let previewUrl: String?
}
