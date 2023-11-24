//
//  ImageCache.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 24.11.2023.
//

import UIKit


protocol Cache {
    func load(for key: String) -> UIImage?
    func save(_ image: UIImage, for key: String)
}

class ImageCache: Cache {
    
    private let cache = NSCache<NSString, UIImage>()
    
    func load(for key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func save(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
