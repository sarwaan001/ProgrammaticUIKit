//
//  Cell.swift
//  ProgrammaticUIKit
//
//  Created by Sarwaan Ansari on 3/14/21.
//

import UIKit

class Cell: UICollectionViewCell {
    
    weak var activity: UIActivityIndicatorView!
    weak var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height))
        
        self.activity = activity
        self.contentView.addSubview(activity)
        
        DispatchQueue.main.async {
            self.activity.startAnimating()
        }
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height))
        imageView.contentMode = .scaleToFill
        imageView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleHeight.rawValue | UIView.AutoresizingMask.flexibleWidth.rawValue)
        self.contentView.addSubview(imageView)
        self.contentView.autoresizesSubviews = true
        self.imageView = imageView
        
        self.contentView.backgroundColor = .tertiarySystemBackground
        
        
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView?.image = nil
        DispatchQueue.main.async {
            self.activity?.startAnimating()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Interface Builder is not supported!")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        fatalError("Interface Builder is not supported!")
    }
    
}
