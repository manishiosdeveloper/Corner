//
//  NibLoadable.swift
//  Corner
//
//  Created by manish singh on 02/10/24.
//
import UIKit

protocol NibLoadable: AnyObject {
    static func loadFromNib() -> Self
    func loadViewFromNib() -> UIView
}

extension NibLoadable where Self: UIView {

    static func loadFromNib() -> Self {
        let identifier = Self.getClassName()
        let views = Bundle.main.loadNibNamed(identifier, owner: nil)

        guard let view = views?.first as? Self else {
            fatalError("Error: Unable to load \(identifier) from storyboard")
        }

        return view
    }

    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            fatalError("Cannot get view from nib")
        }

        return view
    }
}
