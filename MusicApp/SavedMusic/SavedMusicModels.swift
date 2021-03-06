//
//  SavedMusicModels.swift
//  MusicApp
//
//  Created by Александр Бисеров on 8/23/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum SavedMusic {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getTracks
      }
    }
    struct Response {
      enum ResponseType {
        case presentTracks(viewModel: TracksViewModel)
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displayTracks(viewModel: TracksViewModel)
      }
    }
  }
  
}
