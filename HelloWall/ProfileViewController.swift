//
//  ViewController.swift
//  Profile for viewing own posts fetched from custom folder.
//  Custom folder exists but currently getting fixed posts as test.
//
//  Created by Tünde Taba on 23.4.2017.
//  Copyright © 2017 Tünde Taba. All rights reserved.
//

import UIKit

class ProfileViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    var posts: [Post] = {
     var testPost = Post()
     testPost.id = 1
     testPost.imageUrl = "IMG_0043"
     
     var catPost = Post()
     catPost.id = 2
     catPost.imageUrl = "IMG_0033"
     
     var pepePost = Post()
     pepePost.id = 3
     pepePost.imageUrl = "IMG_0046"
     
     var saltPost = Post()
     saltPost.id = 4
     saltPost.imageUrl = "IMG_0048"
     
     var testPost2 = Post()
     testPost2.id = 5
     testPost2.imageUrl = "IMG_0049"
     
     var kanatoPost = Post()
     kanatoPost.id = 6
     kanatoPost.imageUrl = "IMG_0051"
     
     return [testPost, catPost, pepePost, saltPost, testPost2, kanatoPost]
     }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.register(OwnPostCell.self, forCellWithReuseIdentifier: "cellId")
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count 
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! OwnPostCell
        
        cell.post = posts[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let screenSize = UIScreen.main.bounds
        return CGSize(width: view.frame.width, height: view.frame.width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

