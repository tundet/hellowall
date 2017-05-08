//
//  PostCell.swift
//  Model for collectionView's BaseCell, which is each cell's base.
//  Model for PostCell, which is base for a post's cell.
//
//  Created by Tünde Taba on 14.4.2017.
//  Copyright © 2017 Tünde Taba. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
}

class PostCell: BaseCell {
    
    var post: Post?{
        didSet{
            setupThumbnailImage()
        }
    }
    
    // Setup cell's image by loading it from post's imageUrl.
    func setupThumbnailImage() {
        if let thumbnailImageUrl = post?.imageUrl {
            
            thumbnailImageView.loadImageUsingUrlString(urlString: thumbnailImageUrl)
        }
    }
    
    // Setup CustomImageView
    let thumbnailImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.backgroundColor = UIColor.white
        return imageView
    }()
    
    // Add CustomImageView to view without padding.
    override func setupViews() {
        addSubview(thumbnailImageView)
        
        addConstraints(withFormat: "H:|[v0]|", views: thumbnailImageView)
        addConstraints(withFormat: "V:|[v0]|", views: thumbnailImageView)
    }
}
