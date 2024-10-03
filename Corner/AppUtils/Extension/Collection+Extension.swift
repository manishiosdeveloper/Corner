//
//  Collection+Extension.swift
//  Corner
//
//  Created by manish singh on 02/10/24.
//

import Foundation

extension Collection {
    subscript (safe index: Index?) -> Element? {
        guard let safeIndex = index else { return nil }
        return indices.contains(safeIndex) ? self[safeIndex] : nil
    }
}
