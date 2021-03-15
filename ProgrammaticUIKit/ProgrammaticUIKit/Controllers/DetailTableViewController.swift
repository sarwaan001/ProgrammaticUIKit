//
//  DetailTableViewController.swift
//  ProgrammaticUIKit
//
//  Created by Sarwaan Ansari on 3/13/21.
//

import UIKit

class DetailTableViewController: UIViewController {
    
    weak private var scrollView: UIScrollView!
    weak private var activity: UIActivityIndicatorView!
    weak private var imageView: UIImageView!
    weak private var titleLabel: UILabel!
    weak private var detailsLabel: UILabel!
    weak private var photographerLabel: UILabel!
    weak private var locationLabel: UILabel!
    
    var imageTitle: String = ""
    var imageURL: String = ""
    var details: String = ""
    var photographer: String = ""
    var location: String = ""
    
    var data: [String] = []
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        super.viewDidLoad()
        
        // MARK: - SCROLL VIEW
        //Init ScrollView
        let scrollView = DetailScrollView(frame: CGRect(x: 0, y: view.top+view.safeAreaInsets.top, width: view.width-5, height: view.height))
        scrollView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleHeight.rawValue | UIView.AutoresizingMask.flexibleWidth.rawValue)
        self.scrollView = scrollView
        view.addSubview(self.scrollView)
        
        // MARK: - IMAGE VIEW
        let imageView = UIImageView(frame: CGRect(x: view.frame.minX, y: view.top+view.safeAreaInsets.top, width: view.width-5, height: view.width-5))
        imageView.clipsToBounds = true
        if let imageURL = URL(string: self.imageURL) {
            imageView.load(url: imageURL) {Success,Image in
                
                DispatchQueue.main.async {
                    self.activity?.stopAnimating()
                }
                if (Success) {
                    imageView.image = Image
                }
            }
        }
        imageView.contentMode = .scaleAspectFit
        imageView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleHeight.rawValue | UIView.AutoresizingMask.flexibleWidth.rawValue)
        self.imageView = imageView
        imageView.backgroundColor = .secondarySystemBackground
        self.scrollView.addSubview(self.imageView)
        
        // MARK: - ACTIVITY VIEW
        let activity = UIActivityIndicatorView(frame: CGRect(x: view.frame.minX, y: view.top+view.safeAreaInsets.top, width: view.width-5, height: view.width-5))
        self.activity = activity
        view.addSubview(self.activity)
        
        DispatchQueue.main.async {
            self.activity?.startAnimating()
        }
        
        // MARK: - TITLE LABEL VIEW
        let titleLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.width-5, height: 9999))
        titleLabel.numberOfLines = 0
        titleLabel.text = imageTitle
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        titleLabel.autoresizingMask = .flexibleHeight
        self.titleLabel = titleLabel
        self.scrollView.addSubview(self.titleLabel)
        
        // MARK: - LOCATION LABEL VIEW
        let locationLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.width-5, height: 9999))
        locationLabel.numberOfLines = 0
        locationLabel.text = location
        locationLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        locationLabel.autoresizingMask = .flexibleHeight
        self.locationLabel = locationLabel
        self.scrollView.addSubview(self.locationLabel)
        
        // MARK: - PHOTOGRAPHER LABEL VIEW
        let photographerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.width-5, height: 9999))
        photographerLabel.numberOfLines = 0
        photographerLabel.text = photographer
        photographerLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        photographerLabel.autoresizingMask = .flexibleHeight
        self.photographerLabel = photographerLabel
        self.scrollView.addSubview(self.photographerLabel)
        
        // MARK: - DETAILS LABEL VIEW
        let detailsLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.width-5, height: 9999))
        detailsLabel.text = details
        detailsLabel.font = UIFont.preferredFont(forTextStyle: .body)
        detailsLabel.numberOfLines = 0
        detailsLabel.autoresizingMask = .flexibleHeight
        self.detailsLabel = detailsLabel
        self.scrollView.addSubview(self.detailsLabel)
        
        
        
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = imageTitle
        
    }
    
    override func viewDidLayoutSubviews() {
        DispatchQueue.main.async {
            self.activity?.startAnimating()
        }
        
        scrollView.contentOffset.x = 0
        
        imageView?.frame = CGRect(x: self.scrollView.left+5, y: self.scrollView.top, width: self.scrollView.width-10, height: self.scrollView.width-10)
        
        //Title Label
        let titleLabelSize: CGSize = self.titleLabel.sizeThatFits(CGSize(width: self.titleLabel.width, height: self.titleLabel.height))
        self.titleLabel?.frame = CGRect(x: self.scrollView.left+5, y: self.imageView.bottom+5, width: self.scrollView.width-10, height: titleLabelSize.height)
        
        //Location Label
        let locationLabelSize: CGSize = self.locationLabel.sizeThatFits(CGSize(width: self.locationLabel.width, height: self.locationLabel.height))
        self.locationLabel?.frame = CGRect(x: self.scrollView.left+5, y: self.titleLabel.bottom+5, width: self.scrollView.width-5, height: locationLabelSize.height)
        
        //Photographer
        let photographerLabelSize: CGSize = self.photographerLabel.sizeThatFits(CGSize(width: self.photographerLabel.width, height: self.photographerLabel.height))
        self.photographerLabel?.frame = CGRect(x: self.scrollView.left+5, y: self.locationLabel.bottom+5, width: self.scrollView.width-10, height: photographerLabelSize.height)
        
        //Details
        let detailsLabelSize: CGSize = self.detailsLabel.sizeThatFits(CGSize(width: self.detailsLabel.width, height: self.detailsLabel.height))
        self.detailsLabel?.frame = CGRect(x: self.scrollView.left+5,
                                          y: self.photographerLabel.bottom+5, width: self.scrollView.width-10, height: detailsLabelSize.height)
        
        DispatchQueue.main.async {
                var contentRect = CGRect.zero

                for view in self.scrollView.subviews {
                   contentRect = contentRect.union(view.frame)
                }

                self.scrollView.contentSize = contentRect.size
        }
        DispatchQueue.main.async {
            self.activity?.stopAnimating()
        }
        
        
//        imageView?.frame = CGRect(x: view.frame.minX, y: view.frame.minY, width: view.width-5, height: view.width-5)
//        scrollView.contentSize = CGSize(width: scrollview.width-5, height: max(imageView.height, view.height+view.safeAreaInsets.top))
    }
    
}
