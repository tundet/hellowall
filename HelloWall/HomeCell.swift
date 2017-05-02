//
//  HomeCell.swift
//  HelloWall
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
    
    func fetchPosts(){
        ApiService.sharedInstance.fetchPosts { (posts: [Post]) in
            self.posts = posts
            self.collectionView.reloadData()
        }
    }
    
    override func setupViews(){
        super.setupViews()
        
        fetchPosts()
        
        backgroundColor = UIColor.brown
        
        addSubview(collectionView)
        addConstraints(withFormat: "H:|[v0]|", views: collectionView)
        addConstraints(withFormat: "V:|[v0]|", views: collectionView)
        
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("posts.count \(posts?.count)")
        return posts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PostCell
        
        print("cell.post from \(indexPath.item): \(posts![indexPath.item].thumbnailImageName)")
        cell.post = posts?[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let screenSize = UIScreen.main.bounds
        return CGSize(width: frame.width / 3, height: frame.width * 0.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}
