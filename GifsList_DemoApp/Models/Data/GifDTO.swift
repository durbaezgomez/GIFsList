//
//  GifDTO.swift
//  GifsList_DemoApp
//
//  Created by Dominik Urbaez Gomez on 27/02/2021.
//

import Foundation

class GifDTO {
    
    var id: String = ""
    var url: String = ""
    var username: String = ""
    var title: String = ""
    var originalImage: GifImage?
    var thumbnail: GifImage?
    var loopingUrl: String = ""
    
    init(object: Gif) {
        if let id = object.id {
            self.id = id
        }
        if let url = object.url {
            self.url = url
        }
        if let username = object.username {
            self.username = username
        }
        if let title = object.title {
            self.title = title
        }
        guard let images = object.images else {
            return }
        if let original = images["original"] {
            self.originalImage = original
        }
        if let thumbnail = images["480w_still"] {
            self.thumbnail = thumbnail
        }
        if let looping = images["looping"]?.mp4 {
            self.loopingUrl = looping
        }
    }
}
