//
//  String+Extension.swift
//  Corner
//
//  Created by manish singh on 02/10/24.
//

import UIKit

extension String {
    func width(for font: UIFont) -> CGFloat {
        let boundingRect = NSString(string: self).boundingRect(
            with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: NSStringDrawingContext())
        return ceil(boundingRect.size.width)
    }
}

extension String {
    func getImageForEmoji(_ size: CGSize = CGSize(width: 50, height: 50)) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 40)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
