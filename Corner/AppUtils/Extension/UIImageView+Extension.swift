//
//  UIImageView+Extension.swift
//  Corner
//
//  Created by manish singh on 02/10/24.
//

import UIKit
import SDWebImage

extension UIImageView {
    func setImage(
        url: URL?,
        placeholder: UIImage? = nil,
        completion: SDExternalCompletionBlock? = nil
    ) {
        
        guard let imageURL = url else {
            self.image = placeholder
            return
        }

        self.sd_setImage(
            with: imageURL,
            placeholderImage: placeholder,
            options: .progressiveLoad
        ) { (image, error, cacheType, url) in
            completion?(image, error, cacheType, url)
        }
    }
    
    func cancelImageLoad() {
        sd_cancelCurrentImageLoad()
        sd_setImage(with: nil)
    }
}
