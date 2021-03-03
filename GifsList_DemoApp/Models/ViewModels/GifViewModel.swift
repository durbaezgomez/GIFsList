//
//  GifViewModel.swift
//  GifsList_DemoApp
//
//  Created by Dominik Urbaez Gomez on 27/02/2021.
//

import Foundation
import UIKit
import Photos

enum GifImageType: String {
    case original
    case thumbnail
}

class GifViewModel {
    
    var gifDTO: GifDTO
    let bookmarkManager = BookmarksManager()
    
    var handleDownloadSucess: () -> () = {}
    var handleDownloadFailure: () -> () = {}
    
    init(dto: GifDTO) {
        self.gifDTO = dto
    }
    
    func getImage(type: GifImageType, onComplete: @escaping(UIImage) -> ()) {
        var urlFromDTO: String? = nil
        switch type {
        case .original:
            urlFromDTO = gifDTO.originalImage?.url
        case .thumbnail:
            urlFromDTO = gifDTO.thumbnail?.url
        }
        guard let urlString = urlFromDTO, let url = URL(string: urlString) else {
            onComplete(UIImage())
            return
        }
        ImageDownloader.fetchImage(from: url) { image in
            if let imageUnwrapped = image {
                onComplete(imageUnwrapped)
            }
            else {
                onComplete(UIImage())
            }
        }
    }
    
    func getAnimatedGifURL() -> URL? {
        let urlString = gifDTO.originalImage?.url ?? ""
        guard let url = URL(string: urlString) else { return nil }
        return url
    }
    
    func getLoopingUrl() -> URL? {
        let urlString = gifDTO.loopingUrl
        guard let url = URL(string: urlString) else { return nil }
        return url
    }
    
    private func getOriginalHeight() -> CGFloat {
        let height = gifDTO.originalImage?.height ?? "0"
        let intValue = Int(height) ?? 0
        
        return CGFloat(intValue)
    }
    
    private func getOriginalWidth() -> CGFloat {
        let width = gifDTO.originalImage?.width ?? "0"
        let intValue = Int(width) ?? 0
        return CGFloat(intValue)
    }
    
    func scaledSize() -> CGSize {
        let originalHeight = getOriginalHeight()
        let originalWidth = getOriginalWidth()
        
        var scaledWidth: CGFloat = 0
        var scaledHeight: CGFloat = 0
        if originalWidth > UIScreen.main.bounds.size.width {
            scaledWidth = originalWidth * 0.8
            let ratio = scaledWidth / originalWidth
            scaledHeight = originalHeight * ratio
        }
        else if originalHeight > UIScreen.main.bounds.size.height {
            scaledHeight = originalHeight * 0.8
            let ratio = scaledHeight / originalHeight
            scaledWidth = originalWidth * ratio
        }
        
        return CGSize(width: scaledWidth, height: scaledHeight)
    }
    
    func getTitle() -> String {
        return gifDTO.title
    }
    
    func getAuthor() -> String {
        return gifDTO.username
    }
    
    func getId() -> String {
        return gifDTO.id
    }
    
    func isBookmarked() -> Bool {
        return  bookmarkManager.contains(getId())
    }
    
    func toggleBookmark() {
        isBookmarked() ? bookmarkManager.remove(getId()) : bookmarkManager.add(getId())
    }
    
    func trySavingGifToDevice() {
        guard let url = getLoopingUrl() else {
            handleDownloadFailure()
            return
        }
        DispatchQueue.global(qos: .background).async { [weak self] in
            if let urlData = NSData(contentsOf: url) {
                let galleryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                let filePath="\(galleryPath)/\(String(describing: self?.getAuthor()))_\(String(describing: self?.getTitle())).mp4"
                    urlData.write(toFile: filePath, atomically: true)
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
                    }) {
                        success, error in
                        if success {
                            self?.handleDownloadSucess()
                        } else {
                            self?.handleDownloadFailure()
                        }
                    }
            }
        }
    }
}
