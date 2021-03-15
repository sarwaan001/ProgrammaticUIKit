//
//  Extensions.swift
//  ProgrammaticUIKit
//
//  Created by Sarwaan Ansari on 3/13/21.
//

import Foundation
import UIKit

extension UIView {
    var width: CGFloat {
        return frame.size.width
    }
    
    var height: CGFloat {
        return frame.size.height
    }
    
    var left: CGFloat {
        return frame.origin.x
    }
    
    var right: CGFloat {
        return left + width
    }
    
    var top: CGFloat {
        return frame.origin.y
    }
    
    var bottom: CGFloat {
        return top + height
    }
}

extension NSCache {
  @objc class var sharedInstance: NSCache<NSString, AnyObject> {
      let cache = NSCache<NSString, AnyObject>()
      return cache
  }
}

let imageCache = NSCache<AnyObject, AnyObject>.sharedInstance

extension UIImageView {
    func load(url: URL) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            self.image = cachedImage as? UIImage
        }
        else {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.image = image
                            imageCache.setObject(image, forKey: url.absoluteString as NSString)
                        }
                    }
                }
            }
        }
    }
    
    func load(url: URL, completion: @escaping (Bool, UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            self.image = cachedImage as? UIImage
            completion(true, cachedImage as? UIImage)
        }
        else {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.image = image
                            imageCache.setObject(image, forKey: url.absoluteString as NSString)
                            completion(true, image)
                        }
                    }
                    else {
                        completion(false, nil)
                    }
                }
                else {
                    completion(false, nil)
                }
            }
        }
    }
}
