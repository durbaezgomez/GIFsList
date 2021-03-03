//
//  ListViewController.swift
//  GifsList_DemoApp
//
//  Created by Dominik Urbaez Gomez on 26/02/2021.
//

import UIKit
import EasyPeasy

class ListViewController: UIViewController, BookmarkDelegate {
    
    let container = UIView()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        let screenWidth = UIScreen.main.bounds.width
        let sideLength = screenWidth / 2.5
        layout.itemSize = CGSize(width: sideLength, height: sideLength)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    var viewModel: ListViewModel
    var bookmarked = [GifViewModel]()
    var presentedViewModels = [GifViewModel]()
    var isShowingBookmarked = false
    
    init() {
        self.viewModel = ListViewModel()
        super.init(nibName: nil, bundle: nil)
        bindToViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presentedViewModels = viewModel.gifViewModels
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshView()
    }
    
    private func setupView() {
        view.accessibilityIdentifier = "listView"
        
        setupNavigationBar(title: "Trending")
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "suit.heart"), style: .plain, target: self, action: #selector(bookmarksTapped))
        rightButton.tintColor = UIColor.primary
        rightButton.accessibilityIdentifier = "bookmarksButton"
        navigationItem.rightBarButtonItem = rightButton
        
        view.addSubview(container)
        container.easy.layout(Edges())
        container.backgroundColor = UIColor.secondary
        container.addSubview(collectionView)
        
        collectionView.easy.layout(Top(), Left(5), Right(5), Bottom())
        collectionView.backgroundColor = UIColor.secondary
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GifCollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
    }
    
    private func bindToViewModel() {
        viewModel.bindViewModelsData = { [weak self] in
            self?.presentedViewModels = self?.viewModel.gifViewModels ?? [GifViewModel]()
            DispatchQueue.main.async {
                self?.collectionView.performBatchUpdates {
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
    @objc private func bookmarksTapped() {
        if isShowingBookmarked {
            view.accessibilityIdentifier = "listView"
            presentedViewModels = viewModel.gifViewModels
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "suit.heart")
        }
        else {
            view.accessibilityIdentifier = "bookmarksView"
            bookmarked = viewModel.gifViewModels.filter { $0.isBookmarked() }
            presentedViewModels = bookmarked
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "suit.heart.fill")
        }
        isShowingBookmarked.toggle()
        self.collectionView.performBatchUpdates {
            self.collectionView.reloadData()
        }
    }
    
    func refreshView(sender: UICollectionViewCell? = nil) {
        bookmarked = viewModel.bookmarkedViewModels()
        presentedViewModels = isShowingBookmarked ? bookmarked : viewModel.gifViewModels
        if let cell = sender, let indexPath = collectionView.indexPath(for: cell) {
            if isShowingBookmarked {
                self.collectionView.performBatchUpdates {
                    self.collectionView.deleteItems(at: [indexPath])
                }
            }
        }
        else {
            self.collectionView.reloadData()
        }
    }
}

extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presentedViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath as IndexPath) as? GifCollectionViewCell else {
            let cell = UICollectionViewCell()
            return cell
        }
        let cellViewModel = presentedViewModels[indexPath.row]
        cell.configure(viewModel: cellViewModel)
        cell.delegate = self
        viewModel.checkIfIsLastFetchedItem(viewModel: cellViewModel)
        if indexPath.row == 0 {
            cell.accessibilityIdentifier = "firstCell"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(DetailGifViewController(viewModel: presentedViewModels[indexPath.row]), animated: true)
    }
}
