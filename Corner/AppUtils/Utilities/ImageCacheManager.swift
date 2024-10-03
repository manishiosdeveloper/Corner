//
//  ImageCacheManager.swift
//  Corner
//
//  Created by manish singh on 03/10/24.
//

import UIKit
import SDWebImage

class ImageCacheManager {
    
    static func cache(images: [String], from currentIndex: Int) {
        guard !images.isEmpty else {
            print("Images array is empty. Nothing to cache.")
            return
        }
        
        if currentIndex >= 0 && currentIndex < images.count {
            print("Cached current image at index \(currentIndex)")
        }
        
        var urlsString: [String] = []
        
        if currentIndex > 0 {
            let previousIndex = currentIndex - 1
            urlsString.append(images[previousIndex])
        } else {
            print("No previous image to cache, at index \(currentIndex)")
        }
        
        if currentIndex < images.count - 1 {
            let nextIndex = currentIndex + 1
            urlsString.append(images[nextIndex])
        } else {
            print("No next image to cache, at index \(currentIndex)")
        }
        
        let urls = urlsString.compactMap({URL(string: $0)})
        SDWebImagePrefetcher.shared.prefetchURLs(urls)
    }
}
