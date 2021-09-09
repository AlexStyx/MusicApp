//
//  SearchMusicPresenter.swift
//  MusicApp
//
//  Created by Александр Бисеров on 8/22/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchMusicPresentationLogic {
    func presentData(response: SearchMusic.Model.Response.ResponseType)
}

class SearchMusicPresenter: SearchMusicPresentationLogic {
    weak var viewController: SearchMusicDisplayLogic?
    
    func presentData(response: SearchMusic.Model.Response.ResponseType) {
        switch response {
        case .presentFooter:
            viewController?.displayData(viewModel: .displayFooter)
        case .presentTracks(let responseModel):
            let searchViewModel = generateSearchViewModel(searchResponse: responseModel)
            viewController?.displayData(viewModel: .displeyTracks(viewModel: searchViewModel))
        }
    }
    
    private func generateTrackCellViewModel(for track: TrackModel) -> TrackCellViewModel {
        let trackCellViewModel = TrackCellViewModel(trackModel: track)
        return trackCellViewModel
    }
    
    private func generateSearchViewModel(searchResponse: ResponseModel) -> TracksViewModel {
        let tracks = searchResponse.results
        let cellViewModels = tracks.map { generateTrackCellViewModel(for: $0) }
        let searchViewModel = TracksViewModel(cells: cellViewModels)
        return searchViewModel
    }
    
}
