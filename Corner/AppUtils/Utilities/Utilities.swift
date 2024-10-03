//
//  Utilities.swift
//  Corner
//
//  Created by manish singh on 02/10/24.
//

import UIKit

class Utilities {
    static func generateHaptic(
        of style: UIImpactFeedbackGenerator.FeedbackStyle = .medium
    ) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: style)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
    }
}
