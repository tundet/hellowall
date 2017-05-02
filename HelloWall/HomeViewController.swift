//
//  Home.swift
//  HelloWall
//
//  Created by Tünde Taba on 14.4.2017.
//  Copyright © 2017 Tünde Taba. All rights reserved.
//

import UIKit

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var posts: [Post]?
    //var today: String?
    let cellId = "cellId"
    let beaconmanager = BeaconManager.shared()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPosts()

        navigationItem.title = "Home"
        navigationController?.navigationBar.isTranslucent = false
        
        setupMenuBar()
        setupCollectionView()
        beaconmanager.startScanning()
    }
    
    func setupCollectionView(){
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
        }
        
        collectionView?.backgroundColor = UIColor.white
        
        //collectionView?.register(PostCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        //show view and scroll from under the menubar
        collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
        
        collectionView?.isPagingEnabled = true
        
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
    }
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self    //reason why lazy var
        return mb
    }()
    
    private func setupMenuBar() {
        
        navigationController?.hidesBarsOnSwipe = true
        
        view.addSubview(menuBar)
        view.addConstraints(withFormat: "H:|[v0]|", views: menuBar)
        view.addConstraints(withFormat: "V:[v0(50)]", views: menuBar)
        
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    func fetchPosts(){
        ApiService.sharedInstance.fetchPosts { (posts: [Post]) in
            self.posts = posts
            self.collectionView?.reloadData()
        }
    }
    
    //Menubar item's horizontal bar to match with view
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 3
    }
    
    //Menubar item selected to match view
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        print(targetContentOffset.pointee.x / view.frame.width)
        
        let index = targetContentOffset.pointee.x / view.frame.width
        
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBar.menuView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        let colors: [UIColor] = [.blue, .green, .purple]
        
        cell.backgroundColor = colors[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print("posts.count \(posts?.count)")
//        return posts?.count ?? 0
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PostCell
//        
//        print("cell.post from \(indexPath.item): \(posts![indexPath.item].thumbnailImageName)")
//        cell.post = posts?[indexPath.item]
//        
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        //let screenSize = UIScreen.main.bounds
//        return CGSize(width: view.frame.width / 3, height: view.frame.width * 0.5)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
    
}
