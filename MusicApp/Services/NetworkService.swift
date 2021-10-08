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
        guard let url = configureURL() else { fatalError("Cannot configure url") }
        AF.request(url, method: .get, parameters: params(searchTerm: searchText)).responseData { [weak self] responseData in
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
    
    private func params(searchTerm: String)  -> [String: String] {
        [
            "term": searchTerm,
            "media": "music",
            "limit": "25"
        ]
    }
    
    private func configureURL() -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "itunes.apple.com"
        components.path = "/search"
        return components.url
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
