//
//  NetworkService.swift
//  MusicApp
//
//  Created by Александр Бисеров on 8/22/21.
//

import Alamofire



class NetwokrService {
    private init() {}
    
    static let shared = NetwokrService()
    
    func fetchMusic(searchText: String, completion: @escaping (ResponseModel) -> ()) {
        let url = "https://itunes.apple.com/search?term=jack+johnson"
        let parameters = [
            "term": searchText,
            "media": "music",
            "limit": "25"
        ]
        AF.request(url, method: .get, parameters: parameters).responseData { [weak self] responseData in
            guard
                responseData.error == nil,
                let data = responseData.data
            else {
                fatalError("Cannot get data from this request")
            }
            guard let responseModel = self?.parseJSON(data: data) else { fatalError("Cannot get responseModel") }
            completion(responseModel)
        }
    }
    
    private func parseJSON(data: Data) -> ResponseModel {
        let decoder = JSONDecoder()
        do {
            let responseModel = try decoder.decode(ResponseModel.self, from: data)
            return responseModel
        } catch {
            fatalError("Cannot get data")
        }
    }
}
