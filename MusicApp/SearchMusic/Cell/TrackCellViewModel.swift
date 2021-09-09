//
//  TrackCellViewModel.swift
//  MusicApp
//
//  Created by Александр Бисеров on 8/23/21.
//

import Foundation

protocol TrackCellViewModelType {
    var imageURL: String? { get }
    var artistName: String { get }
    var collectionName: String? { get }
    var trackName: String { get }
    var trackPreviewURL: String? { get }
}

struct TrackCellViewModel: TrackCellViewModelType {
    var imageURL: String?
    var artistName: String
    var collectionName: String?
    var trackName: String
    var trackPreviewURL: String?
    
    init(trackModel: TrackModel) {
        self.imageURL = trackModel.artworkUrl60
        self.artistName = trackModel.artistName
        self.collectionName = trackModel.collectionName
        self.trackName = trackModel.trackName
        self.trackPreviewURL = trackModel.previewUrl
    }
    
    init(unarchivedTrack: ArchivableTrack) {
        imageURL = unarchivedTrack.imageURL
        artistName = unarchivedTrack.artistName
        collectionName = unarchivedTrack.collectionName
        trackName = unarchivedTrack.trackName
        trackPreviewURL = unarchivedTrack.previewURL
    }
}
