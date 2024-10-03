//
//  StoryboardLoadable.swift
//  Corner
//
//  Created by manish singh on 02/10/24.
//
import Foundation
import UIKit

protocol StoryboardLoadable: AnyObject {
    static func loadFromStoryboard() -> Self
}

extension StoryboardLoadable where Self: UIViewController {

    static func loadFromStoryboard() -> Self {
        let identifier = Self.getClassName()
        let storyboard = UIStoryboard(name: identifier, bundle: nil)

        guard let controller = storyboard.instantiateInitialViewController() as? Self else {
            fatalError("Error: Unable to load \(identifier) from storyboard")
        }

        return controller
    }
}
