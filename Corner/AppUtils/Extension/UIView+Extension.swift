//
//  UIView+Extension.swift
//  Corner
//
//  Created by manish singh on 02/10/24.
//

import UIKit

extension UIView {
    func addShadow(
        color: UIColor = .black,
        opacity: Float = 0.3,
        radius: CGFloat = 8,
        offset: CGSize = CGSize(width: 0, height: 2)
    ) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = offset
        self.layer.masksToBounds = false 
    }
}

extension UIView {
    func addFullSizeSubview(_ childView: UIView) {
        self.addSubview(childView)
        childView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            childView.topAnchor.constraint(equalTo: self.topAnchor),
            childView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            childView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            childView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
