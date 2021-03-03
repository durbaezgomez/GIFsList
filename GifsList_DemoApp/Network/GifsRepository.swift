//
//  GifsRepository.swift
//  GifsList_DemoApp
//
//  Created by Dominik Urbaez Gomez on 26/02/2021.
//

import Foundation

class GifsRepository: BaseAPIManager {
            
    func fetchGifs(offset: Int, limit: Int, onComplete: @escaping([Gif]?) -> ()) {
        
        let endpoint: Endpoint = .trending
        var urlComponent = URLComponents(string: (api + endpoint.rawValue))
        let params = [
            "api_key": String(apiKey),
            "offset": String(offset),
            "limit": String(limit)
        ]
        let items = params.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        urlComponent?.queryItems = items
        
        guard let url = urlComponent?.url else {
            debugPrint("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        perform(request: request, onComplete: { [weak self] result in
            switch result {
            case .success(let data):
                onComplete(data)
            case .failure(let err):
                self?.handleNetworkError(err)
                onComplete(nil)
            }
        })
    }
}
