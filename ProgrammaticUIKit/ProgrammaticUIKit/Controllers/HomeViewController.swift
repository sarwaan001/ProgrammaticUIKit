//
//  ViewController.swift
//  ProgrammaticUIKit
//
//  Created by Sarwaan Ansari on 3/13/21.
//

import UIKit

class HomeViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var searchBar: UISearchBar = UISearchBar()
    
    var collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    var didReachBottomFlag = false
    
    var nextLink: String? = nil
    
    var items: [Item] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Home"
        view.backgroundColor = .systemBackground
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        searchBar = UISearchBar()
        searchBar.placeholder = "Search Query..."
        searchBar.delegate = self
        
        collectionView.register(Cell.self, forCellWithReuseIdentifier: "cell")
        collectionView.keyboardDismissMode = .onDrag
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        
        //added to subview
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        view.frame = CGRect(x: view.frame.minX, y: view.frame.minY, width: view.width, height: view.height+view.safeAreaInsets.top)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchBar.frame = CGRect(x: 20,
                                 y: view.top+view.safeAreaInsets.top,
                                 width: view.width-40,
                                 height: 50)
        
        collectionView.frame = CGRect(x: 20, y: searchBar.frame.maxY+10, width: view.width-40, height: view.height-searchBar.frame.maxY+10)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.didReachBottomFlag = false
        if (!searchText.isEmpty) {
            CallAPI().get(url: "https://images-api.nasa.gov/search", Structure: Welcome.self, headers: nil, parameters: ["q": searchText, "media_type": "image"]) { (Success, Error, data) in
                if (Success) {
                    self.items = data?.collection.items ?? []
                    
                    if let links = data?.collection.links {
                        for link in links {
                            if (link.rel.lowercased() == "next".lowercased()) {
                                self.nextLink = data?.collection.links[0].href
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        self.didReachBottomFlag = false
        if ((searchBar.text) != nil) {
            CallAPI().get(url: "https://images-api.nasa.gov/search", Structure: Welcome.self, headers: nil, parameters: ["q": searchBar.text!, "media_type": "image"]) { (Success, Error, data) in
                if (Success) {
                    self.items = data?.collection.items ?? []
                    
                    if let links = data?.collection.links {
                        for link in links {
                            if (link.rel.lowercased() == "next".lowercased()) {
                                self.nextLink = data?.collection.links[0].href
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.width/3.5, height: view.width/3.5)
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
        
        
        cell.layer.borderWidth = 1
        
        guard let image_url = items[indexPath.item].links?[0].href else {
            return cell
        }
        
        guard let url = URL(string: image_url) else {
            return cell
        }
        
        let image: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.width, height: cell.height))
        
        image.load(url: url) { (success, img) in
            if (success) {
                cell.imageView.image = img
                DispatchQueue.main.async {
                    cell.activity.stopAnimating()
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Clicked: \(indexPath.item)")
        let vc1 = DetailTableViewController()
        vc1.imageTitle = items[indexPath.item].data[0].title
        vc1.details = items[indexPath.item].data[0].datumDescription ?? ""
        vc1.photographer = items[indexPath.item].data[0].photographer ?? ""
        vc1.location = items[indexPath.item].data[0].location ?? ""
        vc1.navigationItem.largeTitleDisplayMode = .never
        
        if let image_url = items[indexPath.item].links?[0].href {
            vc1.imageURL = image_url
        }

        self.navigationController?.pushViewController(vc1, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            if (!self.didReachBottomFlag) {
                self.didReachBottomFlag = true
                if (nextLink != nil) {
                    self.didReachBottomFlag = true
                    
                    CallAPI().get(url: nextLink!, Structure: Welcome.self) { (Success, Error, data) in
                        if (Success) {
                            self.nextLink = nil
                            self.items.append(contentsOf: data?.collection.items ?? [])
                            
                            if let links = data?.collection.links {
                                for link in links {
                                    if (link.rel.lowercased() == "next".lowercased()) {
                                        self.nextLink = data?.collection.links[0].href
                                    }
                                }
                            }
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                                self.didReachBottomFlag = false
                            }
                        }
                        else {
                            self.didReachBottomFlag = false
                        }
                    }
                    
                    print("scrolled to the bottom")
                }
                else {
                    self.didReachBottomFlag = false
                }
            }
        }

        if (scrollView.contentOffset.y < 0){
            //reach top
        }

        if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)){
            //not top and not bottom
        }
    }
}
