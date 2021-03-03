//
//  Gif.swift
//  GifsList_DemoApp
//
//  Created by Dominik Urbaez Gomez on 26/02/2021.
//

import Foundation

struct Gif: Codable {
    
    var id: String? = ""
    var url: String? = ""
    var username: String? = ""
    var title: String? = ""
    var images: Dictionary<String, GifImage>? = Dictionary<String, GifImage>()
    
    init(id: String, url: String, username: String, title: String, images: Dictionary<String, GifImage>) {
        self.id = id
        self.url = url
        self.username = username
        self.title = title
        self.images = images 
    }
}
