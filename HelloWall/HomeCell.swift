//
//  HomeCell.swift
//  First cell of HomeViewController's CollectionView.
//
//  Created by Tünde Taba on 2.5.2017.
//  Copyright © 2017 Tünde Taba. All rights reserved.
//

import UIKit

class HomeCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    //CollectionView inside the HomeCell
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.dataSource = self    //reason for lazy var & accessing self
        cv.delegate = self      //reason for lazy var
        return cv
    }()
    
    var posts: [Post]?
    let cellId = "cellId"
    
    // Get posts from API according to currenct location and current date.
    func fetchPosts(){
        let today = setDate()
        let id = BeaconManager.sharedInstance.location_id
        ApiService.sharedInstance.fetchPosts(path: "locations/\(id)/posts?date=\(today)") { (posts: [Post]) in
            self.posts = posts.reversed()
            self.collectionView.reloadData()
        }
    }
    
    override func setupViews(){
        super.setupViews()
        
        fetchPosts()
        
        addSubview(collectionView)
        addConstraints(withFormat: "H:|[v0]|", views: collectionView)
        addConstraints(withFormat: "V:|[v0]|", views: collectionView)
        
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    // Get today's date in correct form
    func setDate() -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: date)
        return today
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PostCell
        cell.post = posts?[indexPath.item]
        
        return cell
    }
    
    // Zoom into post and out with gesture recognizing.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PostCell
        cell.post = posts?[indexPath.item]
        let imageView = cell.thumbnailImageView
        imageView.frame = collectionView.frame
        imageView.contentMode = .center
        imageView.isUserInteractionEnabled = true
        
        imageView.center = CGPoint(x: collectionView.bounds.width / 2, y: collectionView.bounds.height / 2)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        imageView.addGestureRecognizer(tap)
        
        addSubview(imageView)
    }
    
    // Use to back from full mode
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 3, height: frame.width * 0.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}
