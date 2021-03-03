//
//  BaseAPIManager.swift
//  GifsList_DemoApp
//
//  Created by Dominik Urbaez Gomez on 26/02/2021.
//

import Foundation

enum NetworkError: Error {
    case networkError
    case clientError
    case serverError
}

struct Response: Codable {
    var data: [Gif]
}

enum Endpoint: String {
    case trending = "trending"
}

class BaseAPIManager {
        
    internal var api: String {
      get {
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
          fatalError("Couldn't find file 'Info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API") as? String else {
          fatalError("Couldn't find key 'API' in 'Info.plist'.")
        }
        return value
      }
    }
    
    internal var apiKey: String {
      get {
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
          fatalError("Couldn't find file 'Info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
          fatalError("Couldn't find key 'API_KEY' in 'Info.plist'.")
        }
        return value
      }
    }
    
    internal func handleNetworkError(_ error: NetworkError) {
        switch error {
        case .networkError:
            debugPrint("ERROR: Network error occurred.")
        case .clientError:
            debugPrint("ERROR: Client error occurred.")
        case .serverError:
            debugPrint("ERROR: Server error occurred.")
        }
    }
    
    func perform(request: URLRequest, onComplete: @escaping(Result<[Gif], NetworkError>) -> Void) {
        
        URLSession.shared.dataTask(with: request) { data, resp, err in
            guard let response = resp as? HTTPURLResponse else {
                onComplete(.failure(.networkError))
                return
            }
            print("Status Code: \(response.statusCode)")

            if response.statusCode == 200, let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(Response.self, from: data)
                    onComplete(.success(decodedResponse.data))
                    return
                } catch { print(error) }
            }
            else if response.statusCode >= 400 && response.statusCode  <= 499 {
                onComplete(.failure(.clientError))
            }
            else if response.statusCode >= 500 && response.statusCode  <= 599 {
                onComplete(.failure(.serverError))
            }
        }.resume()
    }
}
