//
//  SearchMusicInteractor.swift
//  MusicApp
//
//  Created by Александр Бисеров on 8/22/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchMusicBusinessLogic {
    func makeRequest(request: SearchMusic.Model.Request.RequestType)
}

class SearchMusicInteractor: SearchMusicBusinessLogic {
    
    var presenter: SearchMusicPresentationLogic?
    var service: SearchMusicService?
    
    func makeRequest(request: SearchMusic.Model.Request.RequestType) {
        switch request {
        case .requestTracks(let searchText):
            presenter?.presentData(response: .presentFooter)
            NetwokrService.shared.fetchMusic(searchText: searchText) { [weak self] responseModel in
                self?.presenter?.presentData(response: .presentTracks(responseModes: responseModel))
            }
        }
    }
}
