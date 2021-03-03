//
//  ListViewModel.swift
//  GifsList_DemoApp
//
//  Created by Dominik Urbaez Gomez on 26/02/2021.
//

import Foundation

class ListViewModel {
    
    let bookmarksManager = BookmarksManager()
    var service: GifsRepository!
    
    var currentPage = 1
    private var defaultFetchLimit = 30
    
    var gifViewModels : [GifViewModel]! {
        didSet {
            self.bindViewModelsData()
        }
    }
    private var bookmarked = [GifViewModel]()
    
    var bindViewModelsData: (() -> ()) = {}
    
    init() {
        service = GifsRepository()
        gifViewModels = [GifViewModel]()

        fetchGifs()
    }
    
    func translateDataToDTO(data: [Gif]) {
        let newFetchedData = data.map { gif -> GifViewModel in
            let viewModel = GifViewModel(dto: GifDTO(object: gif))
            return viewModel
        }
        gifViewModels.append(contentsOf: newFetchedData)
    }
    
    private func fetchGifs() {
        let offset = gifViewModels.count
        service.fetchGifs(offset: (offset * currentPage), limit: defaultFetchLimit) { [weak self] result in
            if let gifs = result {
                self?.translateDataToDTO(data: gifs)
                self?.currentPage += 1
            }
        }
    }
    
    func refreshData() {
        bindViewModelsData()
    }
    
    func refreshedViewModels() -> [GifViewModel] {
        bookmarksManager.retrieve()
        return gifViewModels
    }
    
    func bookmarkedViewModels() -> [GifViewModel] {
        bookmarksManager.retrieve()
        bookmarked = gifViewModels.filter {
            $0.isBookmarked()
        }
        return bookmarked
    }
    
    func checkIfIsLastFetchedItem(viewModel: GifViewModel) {
        if gifViewModels.last?.getId() == viewModel.getId() {
            fetchGifs()
        }
    }
}
