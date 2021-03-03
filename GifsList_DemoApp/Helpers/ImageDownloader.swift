//
//  ImageDownloader.swift
//  GifsList_DemoApp
//
//  Created by Dominik Urbaez Gomez on 27/02/2021.
//

import Foundation
import UIKit

class ImageDownloader {
    static func fetchImage(from url: URL, onComplete: @escaping(UIImage?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                onComplete(UIImage(data: data))
            }
        }.resume()
    }
}
