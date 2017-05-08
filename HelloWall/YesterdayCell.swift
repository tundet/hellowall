//
//  YesterdayCell.swift
//  Second cell in HomeViewController's CollectionView.
//
//  Created by Tünde Taba on 3.5.2017.
//  Copyright © 2017 Tünde Taba. All rights reserved.
//

import UIKit

class YesterdayCell: HomeCell {
    
    // Fetch posts from API according to current location and yesterdays' date.
    override func fetchPosts(){
        let yesterday = setDate()
        let id = BeaconManager.sharedInstance.location_id
        ApiService.sharedInstance.fetchPosts(path: "locations/\(id)/posts?date=\(yesterday)") { (posts: [Post]) in
            self.posts = posts.reversed()
            self.collectionView.reloadData()
        }
    }
    
    // Get yesterday's date
    override func setDate() -> String{
        //set date
        let date = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let yesterday = formatter.string(from: date!)
        return yesterday
    }
    
    
}
