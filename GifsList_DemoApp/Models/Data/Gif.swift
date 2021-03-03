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
}
