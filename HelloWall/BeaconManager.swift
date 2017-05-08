//
//  BeaconManager.swift
//  Model for the location manager BeaconManager.
//  Creates a list of beacon regions and starts ranging for each of them.
//  Informs the HomeViewController of changes when ranging for beacons and gives the current location's name.
//  Notificating the user when entering beacon areaused to be in use when 
//  there was only one beacon, but hasn't been updated for many beacons and 
//  thus is not in use at the moment.
//
//  Created by Tünde Taba on 26.4.2017.
//  Copyright © 2017 Tünde Taba. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

// Protocol for giving location's name
internal protocol BeaconManagerDelegate : NSObjectProtocol {
    func BeaconChanged(sender: BeaconManager, title: String)
}

class BeaconManager: NSObject, CLLocationManagerDelegate, UNUserNotificationCenterDelegate{
    
    let locationManager: CLLocationManager!
    var locations: [Location]?
    var beacons: [Beacon]?
    var beaconRegions: [CLBeaconRegion]?
    var wallname: String?
    var location_id: Int
    weak var delegate: BeaconManagerDelegate?
    
    // Singleton
    static let sharedInstance = BeaconManager()
    private static var sharedNetworkManager: BeaconManager = {
        let beaconmanager = BeaconManager()
        
        return beaconmanager
    }()
    class func shared() -> BeaconManager {
        return sharedNetworkManager
    }
    
    override init() {
        self.locationManager = CLLocationManager()
        self.location_id = 0
    }
    
    // Setup for the location manager and notifications
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //Check whether notifications are granted
        let options: UNAuthorizationOptions = [.alert,.sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                debugPrint("No notifications")
            } else {
                debugPrint("Notifications granted")
            }
        }
        //UNUserNotificationCenter.current().delegate = self
    }
    
    // Set up list of regions by fetching locations' beacons' UUID through ApiService
    func fetchBeacons(){
        ApiService.sharedInstance.fetchLocations{ (locations: [Location]) in
            self.locations = locations
            var regions = [CLBeaconRegion]()
            for location in self.locations!{
                for beacon in location.beacons!{
                    let uuid = UUID(uuidString: beacon.uuid!)
                    let region = CLBeaconRegion(proximityUUID: uuid!, identifier: location.name!)
                    regions.append(region)
                }
            }
            
            self.beaconRegions = regions
            self.beaconRegions?.forEach(self.locationManager.startRangingBeacons)
            self.locationManager.startUpdatingLocation()
        }
    }
    
    // Method for returning the current location's id
    func getLocationId(uuid: String) -> Int{
        let location_id = ApiService.sharedInstance.locationIdArray[uuid]
        return location_id ?? 0
    }
    
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .authorizedAlways {
                if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                    if CLLocationManager.isRangingAvailable() {
                        fetchBeacons()
                    }
                }
            }
        }
    
    // Ranging for beacons and informing HomeViewController about current location name.
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        if beacons.count > 0 {
            if self.wallname == nil{
                self.wallname = region.identifier
                self.location_id = getLocationId(uuid: beacons[0].proximityUUID.uuidString)
            }
            self.delegate?.BeaconChanged(sender: self, title: self.wallname ?? "Home")
            
        } else {
            self.wallname = nil
        }
    }
    
    // Entering region
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        debugPrint("Entered Region \(region.identifier)")
    }
    
    // Leaving region
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        debugPrint("Exited Region \(region.identifier)")
    }
    
    //    func setupTrigger(){
    //        let content = UNMutableNotificationContent()
    //        content.title = "Hello Wall"
    //        content.body = "You have entered a Wall area"
    //        let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
    //        let identifier = "BeaconLocationIdentifier"
    //        let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
    //        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    //        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
    //            })
    //    }
    
    //    // When the notification has been swiped or tapped by the user
    //    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    //        completionHandler()
    //    }
    //
    //    // When the app is in the foreground
    //    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    //        completionHandler([.alert, .sound])
    //    }
    
    //    func updateDistance(_ distance: CLProximity) {
    //        UIView.animate(withDuration: 0.8) {
    //            switch distance {
    //            case .unknown:
    //                print("unknown")
    //            case .far:
    //                print("far")
    //
    //            case .near:
    //                print("near")
    //                
    //            case .immediate:
    //                print("close")
    //            }
    //        }
    //    }
    
}
