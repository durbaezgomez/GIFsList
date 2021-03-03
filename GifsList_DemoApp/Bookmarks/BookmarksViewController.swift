//
//  BookmarksViewController.swift
//  GifsList_DemoApp
//
//  Created by Dominik Urbaez Gomez on 26/02/2021.
//

import UIKit
import EasyPeasy

class BookmarksViewController: UIViewController {
    
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
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        setupNavigationBar(title: "Favourite GIFs")
        view.addSubview(container)
        container.easy.layout(Edges())
        container.backgroundColor = UIColor.secondary
        
        collectionView.easy.layout(Top(), Left(5), Right(5), Bottom())
        collectionView.backgroundColor = UIColor.secondary
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GifCollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
    }
}

extension BookmarksViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.gifViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath as IndexPath) as? GifCollectionViewCell else {
            let cell = UICollectionViewCell()
            return cell
        }
        cell.configure(viewModel: viewModel.gifViewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(DetailGifViewController(viewModel: viewModel.gifViewModels[indexPath.row]), animated: true)
    }
}
