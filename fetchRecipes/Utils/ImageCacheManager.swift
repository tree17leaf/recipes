//
//  ImageCacheManager.swift
//  fetchRecipes
//
//  Created by Choonghun Lee on 2/10/25.
//

import SwiftUI

class ImageCacheManager {
    static let shared = ImageCacheManager()

    private let cache = NSCache<NSString, UIImage>()

    private init() {}

    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }

    func setImage(_ image: UIImage?, forKey key: String) {
        if let image = image {
            cache.setObject(image, forKey: key as NSString)
        } else {
            cache.removeObject(forKey: key as NSString)
        }
    }
}
