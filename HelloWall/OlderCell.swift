//
//  OlderCell.swift
//  Third cell in HomeViewController's CollectionView.
//
//  Created by Tünde Taba on 3.5.2017.
//  Copyright © 2017 Tünde Taba. All rights reserved.
//

import UIKit

class OlderCell: HomeCell {
    
    // Get posts from API according to current location and day before yesterday's date.
    override func fetchPosts(){
        let older = setDate()
        let id = BeaconManager.sharedInstance.location_id
        ApiService.sharedInstance.fetchPosts(path: "locations/\(id)/posts?date=\(older)") { (posts: [Post]) in
            self.posts = posts.reversed()
            self.collectionView.reloadData()
        }
    }
    
    // Get date before yesterday in correct form
    override func setDate() -> String{
        //set date
        let date = Calendar.current.date(byAdding: .day, value: -2, to: Date())
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let older = formatter.string(from: date!)
        return older
    }
    
    
}
