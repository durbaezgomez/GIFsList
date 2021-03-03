//
//  GifImage.swift
//  GifsList_DemoApp
//
//  Created by Dominik Urbaez Gomez on 26/02/2021.
//

import Foundation

struct GifImage: Codable {
    
    var height: String?
    var width: String?
    var url: String?
    var mp4: String?
    
    init(height: String, width: String, url: String? = nil, mp4: String? = nil) {
        self.height = height
        self.width = width
        self.url = url
        self.mp4 = mp4
    }
}
