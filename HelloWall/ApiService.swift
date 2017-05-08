//
//  ApiService.swift
//  Fetching posts, beacons and locations from API
//
//  Created by Tünde Taba on 1.5.2017.
//  Copyright © 2017 Tünde Taba. All rights reserved.
//

import UIKit
import CoreLocation

class ApiService: NSObject {
    
    // Singleton
    static let sharedInstance = ApiService()
    var locationIdArray: [String: Int]
    
    override init() {
        self.locationIdArray = [String: Int]()
    }
    
    // Method for getting posts from API by giving the path as a param
    // and creating an array of posts
    func fetchPosts(path: String, completion: @escaping ([Post]) -> ()){
        let url = NSURL(string: "https://irot-hello-wall.othnet.ga/\(path)")
        URLSession.shared.dataTask(with: url! as URL){
            (data, response, error) in
            
            if error != nil {
                print(error as Any)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                
                var posts = [Post]()
                
                if let jsondict = json["data"]{
                    posts = [Post]()
                    
                    for dictionary in jsondict as! [[String: AnyObject]]{
                        let post = Post()
                        post.id = dictionary["id"] as? Int
                        post.imageUrl = dictionary["image_url"] as? String
                        posts.append(post)
                    }
                }
                //Asynchronous queue in main thread.
                DispatchQueue.main.async {
                    completion(posts)
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            
        }.resume()
    }
    
//    //method for getting all the beacons from API and creating an array of them
//    func fetchBeacons(completion: @escaping ([Beacon]) -> ()){
//        let url = NSURL(string: "https://irot-hello-wall.othnet.ga/beacons")
//        URLSession.shared.dataTask(with: url! as URL){
//            (data, response, error) in
//            
//            if error != nil {
//                print(error as Any)
//                return
//            }
//            
//            do {
//                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
//                
//                var beacons = [Beacon]()
//                
//                if let jsondict = json["data"]{
//                    
//                    for dictionary in jsondict as! [[String: AnyObject]]{
//                        let beacon = Beacon()
//                        beacon.location_id = dictionary["location_id"] as? Int
//                        beacon.uuid = dictionary["uuid"] as? String
//                        beacons.append(beacon)
//                    }
//                }
//                
//                DispatchQueue.main.async {
//                    completion(beacons)
//                }
//        
//            } catch let jsonError {
//                print(jsonError)
//            }
//            
//        }.resume()
//        
//    }
    
    //method for getting all the locations and creating an array of them
    func fetchLocations(completion: @escaping ([Location]) -> ()){
        let url = NSURL(string: "https://irot-hello-wall.othnet.ga/locations")
        URLSession.shared.dataTask(with: url! as URL){
            (data, response, error) in
            
            if error != nil {
                print(error as Any)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                
                var locations = [Location]()
                
                if let jsondict = json["data"]{
                    
                    for dictionary in jsondict as! [[String: AnyObject]]{
                        let location = Location()
                        location.id = dictionary["id"] as? Int
                        location.name = dictionary["name"] as? String
                        location.desc = dictionary["description"] as? String
                        let longitude = dictionary["longitude"] as? String
                        let latitude = dictionary["latitude"] as? String
                        location.coordinates = CLLocationCoordinate2DMake(CLLocationDegrees(latitude!)!, CLLocationDegrees(longitude!)!)
                        location.logo_url = NSURL(string: dictionary["style"]?["logo_url"] as! String)
                        
                        if let beacondict = dictionary["beacons"]{
                            var beacons = [Beacon]()
                            for b in beacondict as! [[String: AnyObject]]{
                                let beacon = Beacon()
                                beacon.uuid = b["uuid"] as? String
                                beacon.location_id = b["location_id"] as? Int
                                self.locationIdArray.updateValue(beacon.location_id!, forKey: beacon.uuid!)
                                beacons.append(beacon)
                            }
                            location.beacons = beacons
                        }
                        locations.append(location)
                    }
                }
                //Asynchronous queue in main thread.
                DispatchQueue.main.async {
                    completion(locations)
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            
        }.resume()
        
    }
    
}
