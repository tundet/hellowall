//
//  MenuBar.swift
//  A menubar placed under the navigation bar with a custom cell.
//  Navigates through the collection views.
//
//  Created by Tünde Taba on 15.4.2017.
//  Copyright © 2017 Tünde Taba. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // Setup menu
    lazy var menuView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()

    let cellId = "cellId"
    let imageNames = ["today200", "yesterday200", "older200"]
    
    var homeController: HomeViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        menuView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(menuView)
        addConstraints(withFormat: "H:|[v0]|", views: menuView)
        addConstraints(withFormat: "V:|[v0]|", views: menuView)
        
        // First menu item selected
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        menuView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: UICollectionViewScrollPosition())
        
        setupHorizontalBar()
        
    }
    
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    
    // Horizontal bar under icon
    func setupHorizontalBar(){
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = UIColor.rgb(red: 99, green: 197, blue: 146, alpha: 1)
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)
        
        horizontalBarLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarLeftAnchorConstraint?.isActive = true
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        
    }
    
    // Animate horizontal bar to match with selected item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        homeController?.scrollToMenuIndex(menuIndex: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        
        cell.imageView.image = UIImage(named: imageNames[indexPath.item])?.withRenderingMode(.alwaysTemplate)
        cell.tintColor = UIColor.rgb(red: 99, green: 197, blue: 146, alpha: 1)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 3, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder aDecoder:NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MenuCell: BaseCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "today200")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = UIColor.lightGray
        return iv
    }()
    
    override var isHighlighted: Bool {
        didSet{
            imageView.tintColor = isHighlighted ? UIColor.rgb(red: 99, green: 197, blue: 146, alpha: 1) : UIColor.lightGray
        }
    }
    
    override var isSelected: Bool {
        didSet{
            imageView.tintColor = isSelected ? UIColor.rgb(red: 99, green: 197, blue: 146, alpha: 1) : UIColor.lightGray
        }
    }

    override func setupViews(){
        super.setupViews()
        
        addSubview(imageView)
        addConstraints(withFormat: "H:[v0(80)]", views: imageView)
        addConstraints(withFormat: "V:[v0(50)]", views: imageView)
        
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}

