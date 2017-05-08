//
//  Location.swift
//  Model for Location. 
//  Has an id, name, description, coordinates, logo and array of beacons.
//
//  Created by Tünde Taba on 23.4.2017.
//  Copyright © 2017 Tünde Taba. All rights reserved.
//

import UIKit
import MapKit

class Location: NSObject {
    
    var id: Int?
    var name: String?
    var desc: String?
    var coordinates: CLLocationCoordinate2D?
    var background_color: String?
    var logo_url: NSURL?
    var user_id: Int?
    var beacons: [Beacon]?
    
}
