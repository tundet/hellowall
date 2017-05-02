//
//  ApiService.swift
//  HelloWall
//
//  Created by Tünde Taba on 1.5.2017.
//  Copyright © 2017 Tünde Taba. All rights reserved.
//

import UIKit

class ApiService: NSObject {
    
    static let sharedInstance = ApiService()
    
    func fetchPosts(completion: @escaping ([Post]) -> ()){
        let url = NSURL(string: "https://users.metropolia.fi/~tundet/web/home.json")
        //let url = NSURL(string: "https://irot-hello-wall.othnet.ga/posts")
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
                        post.thumbnailImageName = dictionary["image_url"] as? String
                        posts.append(post)
                        
                    }
                    
                }
                
                DispatchQueue.main.async {
                    completion(posts)
                }
                
                
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()

        
    }

}
