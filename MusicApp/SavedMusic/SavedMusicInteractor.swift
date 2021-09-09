//
//  SavedMusicInteractor.swift
//  MusicApp
//
//  Created by Александр Бисеров on 8/23/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SavedMusicBusinessLogic {
  func makeRequest(request: SavedMusic.Model.Request.RequestType)
}

class SavedMusicInteractor: SavedMusicBusinessLogic {

  var presenter: SavedMusicPresentationLogic?
  var service: SavedMusicService?
  
  func makeRequest(request: SavedMusic.Model.Request.RequestType) {
    if service == nil {
      service = SavedMusicService()
    }
  }
  
}
