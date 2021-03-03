//
//  UIView+Extensions.swift
//  GifsList_DemoApp
//
//  Created by Dominik Urbaez Gomez on 26/02/2021.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
}
