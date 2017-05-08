//
//  OwnPostCell.swift
//  Model for posts on profile.
//
//  Created by Tünde Taba on 23.4.2017.
//  Copyright © 2017 Tünde Taba. All rights reserved.
//


import UIKit

class OwnPostCell: BaseCell {
    
    // Place post image to imageview
    var post: Post? {
        didSet {
            imageView.image = UIImage(named: (post?.imageUrl)!)
        }
    }
    
    // Setup UIImageView for post image
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.white
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // Black line to separate posts
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        return view
    }()
    
    // Add the image and separator to view
    override func setupViews() {
        addSubview(imageView)
        addSubview(separatorView)
        
        addConstraints(withFormat: "H:|[v0]|", views: imageView)
        addConstraints(withFormat: "V:|[v0]-8-[v1(1)]|", views: imageView, separatorView)
        addConstraints(withFormat: "H:|[v0]|", views: separatorView)
    }
}
