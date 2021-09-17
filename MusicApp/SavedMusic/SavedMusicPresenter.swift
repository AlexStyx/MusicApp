//
//  SavedMusicPresenter.swift
//  MusicApp
//
//  Created by Александр Бисеров on 8/23/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SavedMusicPresentationLogic {
    func presentData(response: SavedMusic.Model.Response.ResponseType)
}

class SavedMusicPresenter: SavedMusicPresentationLogic {
    weak var viewController: SavedMusicDisplayLogic?
    
    func presentData(response: SavedMusic.Model.Response.ResponseType) {
        switch response {
        case .presentTracks(let viewModel):
            viewController?.displayData(viewModel: .displayTracks(viewModel: viewModel))
        }
    }
    
}
