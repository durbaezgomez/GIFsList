//
//  GifCollectionViewCell.swift
//  GifsList_DemoApp
//
//  Created by Dominik Urbaez Gomez on 27/02/2021.
//

import UIKit
import EasyPeasy

class GifCollectionViewCell: UICollectionViewCell {
    let container = UIView()
    let gifView = UIImageView()
    let bookmarkButton: UIButton = {
        let button = UIButton()
        let imageDeselected = UIImage(systemName: "suit.heart", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        button.setImage(imageDeselected, for: .normal)
        let imageSelected = UIImage(systemName: "suit.heart.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        button.setImage(imageSelected, for: .selected)
        button.tintColor = UIColor.primary
        return button
    }()
        
    var delegate: BookmarkDelegate?
    var viewModel: GifViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(container)
        container.easy.layout(Edges())
        container.backgroundColor = .primary
        container.addSubviews([gifView, bookmarkButton])
        gifView.easy.layout(Edges())
        bookmarkButton.easy.layout(Top(5), Right(5), Size(self.frame.size.height / 5))
        bookmarkButton.addTarget(self, action: #selector(bookmarkTapped), for: .touchUpInside)
        bookmarkButton.accessibilityIdentifier = "bookmarkCellButton"
        gifView.layer.masksToBounds = true
        gifView.layer.cornerRadius = 10
        container.layer.cornerRadius = 10
    }
    
    func configure(viewModel: GifViewModel) {
        self.viewModel = viewModel
        bookmarkButton.isSelected = viewModel.isBookmarked()
        viewModel.getImage(type: .thumbnail) { [weak self] image in
            self?.gifView.image = image
        }
    }
    
    @objc func bookmarkTapped() {
        viewModel?.toggleBookmark()
        bookmarkButton.isSelected = viewModel?.isBookmarked() ?? false
        delegate?.refreshView(sender: self)
    }
}
