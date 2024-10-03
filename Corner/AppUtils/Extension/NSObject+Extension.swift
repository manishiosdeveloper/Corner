//
//  NSObject+Extension.swift
//  Corner
//
//  Created by manish singh on 02/10/24.
//
import Foundation

extension NSObject {
    static func getClassName() -> String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

