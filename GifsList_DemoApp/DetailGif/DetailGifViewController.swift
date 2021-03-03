//
//  DetailGifViewController.swift
//  GifsList_DemoApp
//
//  Created by Dominik Urbaez Gomez on 27/02/2021.
//

import UIKit
import EasyPeasy
import SwiftyGif

class DetailGifViewController: UIViewController {
    let container = UIView()
    let blackoutView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return bView
    }()
    let loaderBlackout = UIActivityIndicatorView(style: .large)
    
    let bookmarksManager = BookmarksManager()
    
    let gif = UIImageView()
    let authorLabel = UILabel()
    let titleLabel = UILabel()
    
    var viewModel: GifViewModel
    
    init(viewModel: GifViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindToViewModel()
    }
    
    func bindToViewModel() {
        viewModel.handleDownloadFailure = {
            self.handleImageSavingResult(successful: false)
        }
        viewModel.handleDownloadSucess = {
            self.handleImageSavingResult(successful: true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.accessibilityIdentifier = "detailView"
        
        setupNavigationBar(title: viewModel.getTitle())
        let downloadButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down"),style: .plain, target: self, action: #selector(downloadTapped))
        let bookmarkButton = UIBarButtonItem(image: UIImage(systemName: "suit.heart"), style: .plain, target: self, action: #selector(bookmarkButtonTapped))
        bookmarkButton.tintColor = .primary
        bookmarkButton.tag = 1
        bookmarkButton.accessibilityIdentifier = "bookmarksButtonDetailView"
        downloadButton.tintColor = .primary
        navigationItem.rightBarButtonItems = [bookmarkButton, downloadButton]
        setBookmarkButtonIcon()
        
        view.addSubview(container)
        container.easy.layout(Edges())
        container.backgroundColor = .secondary
        container.addSubviews([blackoutView, gif, authorLabel, titleLabel])
            
        loaderBlackout.translatesAutoresizingMaskIntoConstraints = false
        loaderBlackout.color = UIColor.white
        blackoutView.easy.layout(Edges())
        blackoutView.addSubview(loaderBlackout)
        loaderBlackout.easy.layout(Center())
        blackoutView.isHidden = true
        
        let size = viewModel.scaledSize()
        gif.easy.layout(Top(100), CenterX(), Height(size.height), Width(size.width))
        gif.backgroundColor = .secondary
        
        let loader = UIActivityIndicatorView(style: .medium)
        if let url = viewModel.getAnimatedGifURL() {
            gif.setGifFromURL(url, customLoader: loader)
        }
        
        authorLabel.easy.layout(Top(10).to(gif), Right(10), Left(10))
        titleLabel.easy.layout(Top(10).to(authorLabel), Right(10), Left(10))
        
        authorLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 26)
        titleLabel.numberOfLines = 2
        
        authorLabel.text = viewModel.getAuthor()
        titleLabel.text = viewModel.getTitle()
    }
    
    private func handleImageSavingResult(successful: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.blackoutView.isHidden = true
            self?.loaderBlackout.stopAnimating()
            if successful {
                let ac = UIAlertController(title: "All done!", message: "The GIF was successfully saved to your library.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(ac, animated: true)
            }
            else {
                let ac = UIAlertController(title: "Oops! Something went wrong...", message: "Please, try again later.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(ac, animated: true)
            }
        }
    }
    
    @objc private func downloadTapped() {
        blackoutView.isHidden = false
        loaderBlackout.startAnimating()
        viewModel.trySavingGifToDevice()
    }
    
    @objc private func bookmarkButtonTapped() {
        viewModel.toggleBookmark()
        setBookmarkButtonIcon()
    }
    
    private func setBookmarkButtonIcon() {
        navigationItem.rightBarButtonItems?.first(where: { $0.tag == 1 })?.image = viewModel.isBookmarked() ? UIImage(systemName: "suit.heart.fill") : UIImage(systemName: "suit.heart")
    }
}
