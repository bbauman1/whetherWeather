//
//  ImageLoader.swift
//  whetherWeather
//
//  Created by Brett Bauman on 6/13/21.
//

import Combine
import Foundation
import UIKit

class ImageLoader {
    
    static let shared = ImageLoader()
    
    private let backgroundQueue = DispatchQueue(label: "wp.imageLoading", qos: .userInteractive, attributes: .concurrent)
    private let session = URLSession.shared
    private var cache = NSCache<NSURL, UIImage>()
    
    func load(_ url: URL) -> AnyPublisher<UIImage?, Never> {
        let key = url as NSURL
        
        if let cachedImage = cache.object(forKey: key) {
            return Just(cachedImage).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .map(UIImage.init)
            .replaceError(with: nil)
            .handleEvents(
                receiveOutput: { [weak self] image in
                    if let image = image {
                        self?.cache.setObject(image, forKey: key)
                    } else {
                        self?.cache.removeObject(forKey: key)
                    }
            }, receiveCancel: { [weak self] in
                self?.cache.removeObject(forKey: key)
            })
            .subscribe(on: backgroundQueue)
            .eraseToAnyPublisher()
    }
}

