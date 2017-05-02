//
//  OwnPostCell.swift
//  HelloWall
//
//  Created by Tünde Taba on 23.4.2017.
//  Copyright © 2017 Tünde Taba. All rights reserved.
//


import UIKit

class OwnPostCell: BaseCell {
    
    var post: Post? {
        didSet {
            imageView.image = UIImage(named: (post?.thumbnailImageName)!)
        }
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.blue
        imageView.image = UIImage(named: "IMG_0046")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        return view
    }()
    
    override func setupViews() {
        addSubview(imageView)
        addSubview(separatorView)
        
        addConstraints(withFormat: "H:|[v0]|", views: imageView)
        //addConstraints(withFormat: "V:|[v0]|", views: thumbnailImageView)
        addConstraints(withFormat: "V:|[v0]-8-[v1(1)]|", views: imageView, separatorView)
        addConstraints(withFormat: "H:|[v0]|", views: separatorView)
        
        
        //thumbnailImageView.frame = CGRect(x: 0, y: 0, width: screenSize.width / 3, height: screenSize.width * 0.5)
    }
}
