//
//  Home.swift
//  Main view with a collection view that has 3 cells for today's,
//  yesterday's and the day before yesterday's posts according
//  to current location. There is a menubar for switching between
//  the 3 cells.
//
//  Created by Tünde Taba on 14.4.2017.
//  Copyright © 2017 Tünde Taba. All rights reserved.
//

import UIKit

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, BeaconManagerDelegate {
    
    let cellId = "cellId"
    let yesterdayCellId = "yesterdayCellId"
    let olderCellId = "olderCellId"
    let homeCellId = "homeCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Home"
        navigationController?.navigationBar.isTranslucent = false
        self.automaticallyAdjustsScrollViewInsets = false;
        tabBarController!.tabBar.items![1].isEnabled = false
        setupMenuBar()
        setupCollectionView()
        BeaconManager.sharedInstance.setupLocationManager()
        BeaconManager.sharedInstance.fetchBeacons()
        BeaconManager.sharedInstance.delegate = self
    }
    
    // Change title when beacon changed and allow drawing
    internal func BeaconChanged(sender: BeaconManager, title: String) {
        navigationItem.title = title
        collectionView?.reloadData()
        
//        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
//        loadingIndicator.hidesWhenStopped = true
//        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
//        loadingIndicator.startAnimating();
        
        if navigationItem.title != "Home" {
            tabBarController!.tabBar.items![1].isEnabled = true
        }
    }
    
    // Setup the cells in the collection view
    func setupCollectionView(){
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
        }
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(HomeCell.self, forCellWithReuseIdentifier: homeCellId)
        collectionView?.register(YesterdayCell.self, forCellWithReuseIdentifier: yesterdayCellId)
        collectionView?.register(OlderCell.self, forCellWithReuseIdentifier: olderCellId)
        
        //show view and scroll from under the menubar
        collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
        
        collectionView?.isPagingEnabled = true
    }
    
    // Scroll to correct cell when menu item is tapped
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
    }
    
    // Create Menu bar
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self    //reason why lazy var
        return mb
    }()
    
    // Setup menu bar
    private func setupMenuBar() {
        
        view.addSubview(menuBar)
        view.addConstraints(withFormat: "H:|[v0]|", views: menuBar)
        view.addConstraints(withFormat: "V:[v0(50)]", views: menuBar)
        
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    //Menubar item's horizontal bar to match with view
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 3
    }
    
    //Menubar item selected to match view
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let index = targetContentOffset.pointee.x / view.frame.width
        
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBar.menuView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    // Setup three cells in view and make them match with index
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if navigationItem.title != "Home" {
            if indexPath.item == 1 {
                return collectionView.dequeueReusableCell(withReuseIdentifier: yesterdayCellId, for: indexPath)
            }else if indexPath.item == 2 {
                return collectionView.dequeueReusableCell(withReuseIdentifier: olderCellId, for: indexPath)
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeCellId, for: indexPath)
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height - 50)
    }
    
}
