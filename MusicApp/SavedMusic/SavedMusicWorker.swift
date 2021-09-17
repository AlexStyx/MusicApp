//
//  SavedMusicWorker.swift
//  MusicApp
//
//  Created by Александр Бисеров on 8/23/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class SavedMusicService {
    
    private let archivator = DataArchivator()

    func getTracksViewModel() -> TracksViewModel? {
        archivator.getTracksViewModel()
    }
}
