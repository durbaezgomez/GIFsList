//
//  UIViewController+Extensions.swift
//  GifsList_DemoApp
//
//  Created by Dominik Urbaez Gomez on 27/02/2021.
//

import Foundation
import UIKit

extension UIViewController {
    func setupNavigationBar(title: String) {
        self.title = title
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.primary]
        navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
        navigationController?.navigationBar.barTintColor = UIColor.secondary
        navigationController?.navigationItem.backBarButtonItem?.tintColor = UIColor.primary
        navigationController?.navigationBar.tintColor = UIColor.primary
        navigationController?.navigationBar.tintColor = UIColor.primary
    }
}
