//
//  DataArchivator.swift
//  MusicApp
//
//  Created by Александр Бисеров on 9/3/21.
//

import Foundation

class DataArchivator {
    
    private let userDefaults = UserDefaults.standard
    
    func add(track: TrackCellViewModelType) {
        DispatchQueue.global(qos: .userInitiated).async  {
            var tracks = self.getTracksViewModel()?.cells ?? []
            tracks.append(track)
            self.saveTracks(tracks: tracks)
        }
    }
    
    func getTracksViewModel() -> TracksViewModel? {
        let unarchivedTracks: [ArchivableTrack]?
        guard let data = userDefaults.data(forKey: Keys.tracks) else { return nil }
        do {
            unarchivedTracks = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [ArchivableTrack]
            
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
        if let unarchivedTracks = unarchivedTracks {
            let trackCellViewModels = unarchivedTracks.map { TrackCellViewModel(unarchivedTrack: $0) }
            let tracksViewModel = TracksViewModel(cells: trackCellViewModels)
            return tracksViewModel
        } else {
            return nil
        }
    }
    
    private func saveTracks(tracks: [TrackCellViewModelType]) {
        let archivableTracks = tracks.map { ArchivableTrack(viewModel: $0)}
        var trackData: Data
        do {
            trackData = try NSKeyedArchiver.archivedData(withRootObject: archivableTracks, requiringSecureCoding: false)
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
        userDefaults.setValue(trackData, forKey: Keys.tracks)
        userDefaults.synchronize()
    }
}

class ArchivableTrack: NSObject, NSCoding {
    
    func encode(with coder: NSCoder) {
        coder.encode(imageURL, forKey: Keys.Track.imageURL)
        coder.encode(artistName, forKey: Keys.Track.artistName)
        coder.encode(trackName, forKey: Keys.Track.trackName)
        coder.encode(collectionName, forKey: Keys.Track.collectionName)
        coder.encode(previewURL, forKey: Keys.Track.previewURL)
        coder.encode(trackData, forKey: Keys.Track.trackData)
    }
    
    required init?(coder: NSCoder) {
        imageURL = coder.decodeObject(forKey: "imageURL") as? String
        artistName = coder.decodeObject(forKey: Keys.Track.artistName) as? String ?? ""
        trackName = coder.decodeObject(forKey: Keys.Track.trackName) as? String ?? ""
        collectionName = coder.decodeObject(forKey: Keys.Track.trackName) as? String
        previewURL = coder.decodeObject(forKey: Keys.Track.previewURL) as? String
    }
    
    let imageURL: String?
    let artistName: String
    let trackName: String
    let collectionName: String?
    let previewURL: String?
    private var trackData: Data? {
        guard let url = URL(string: previewURL ?? "") else { return nil }
        return try? Data(contentsOf: url)
    }
    
    init(viewModel: TrackCellViewModelType) {
        artistName = viewModel.artistName
        imageURL = viewModel.imageURL
        trackName = viewModel.trackName
        collectionName = viewModel.collectionName
        previewURL = viewModel.trackPreviewURL
    }
    
    
}
