//
//  PostCell.swift
//  HelloWall
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
    
    
    //let screenSize = UIScreen.main.bounds
    
    func setupThumbnailImage() {
        if let thumbnailImageUrl = post?.thumbnailImageName {
            
            thumbnailImageView.loadImageUsingUrlString(urlString: thumbnailImageUrl)
        }
    }
    
    let thumbnailImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.backgroundColor = UIColor.blue
        imageView.image = UIImage(named: "IMG_0043")
        //imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func setupViews() {
        addSubview(thumbnailImageView)
        
        addConstraints(withFormat: "H:|[v0]|", views: thumbnailImageView)
        addConstraints(withFormat: "V:|[v0]|", views: thumbnailImageView)
    
        
        //thumbnailImageView.frame = CGRect(x: 0, y: 0, width: screenSize.width / 3, height: screenSize.width * 0.5)
    }
}
