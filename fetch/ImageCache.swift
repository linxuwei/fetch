import Foundation
import UIKit

class ImageCache {
    static let shared = ImageCache()
    
    private var cache = NSCache<NSURL, UIImage>()
    
    private init() {} // 防止外部初始化
    
    func save(image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
    
    func image(for url: URL) -> UIImage? {
        return cache.object(forKey: url as NSURL)
    }
}
