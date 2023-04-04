//
//  ImageDownloader.swift
//  AvenCodingChallenge
//
//  Created by Krishna Kumar on 4/4/23.
//

import Foundation
import UIKit

final class ImageDownloader {
    static let shared = ImageDownloader()
    private init() {}
    private lazy var imageCache: NSCache<NSString, UIImage> = {
          let cache = NSCache<NSString, UIImage>()
          return cache
      }()
    
    func downloadImage(url: String, completion: @escaping (UIImage?) -> Void) {
        if let image = imageCache.object(forKey: url as NSString) {
            return completion(image)
        }
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            if let _ = error {
                completion(nil)
                return
            }
            if let _ = response {
                let image = UIImage(data: data!)!
                self.imageCache.setObject(image, forKey: url as NSString)
                completion(image)
            }
        }
        
        task.resume()
    }
    
}
