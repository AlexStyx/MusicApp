//
//  SearchMusicModels.swift
//  MusicApp
//
//  Created by Александр Бисеров on 8/22/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum SearchMusic {
   
  enum Model {
    struct Request {
      enum RequestType {
        case requestTracks(searchText: String)
      }
    }
    struct Response {
      enum ResponseType {
        case presentTracks(responseModes: ResponseModel)
        case presentFooter
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displeyTracks(viewModel: TracksViewModel)
        case displayFooter
      }
    }
  }
  
}

struct TracksViewModel {
    let cells: [TrackCellViewModelType]
}
