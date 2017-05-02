//
//  BeaconManager.swift
//  HelloWall
//
//  Created by Tünde Taba on 26.4.2017.
//  Copyright © 2017 Tünde Taba. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

class BeaconManager: NSObject, CLLocationManagerDelegate, UNUserNotificationCenterDelegate{
    
    let locationManager: CLLocationManager!
    
    override init() {
        self.locationManager = CLLocationManager()
    }
    
    private static var sharedNetworkManager: BeaconManager = {
        let beaconmanager = BeaconManager()
        
        return beaconmanager
    }()
    
    func startScanning(){
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let options: UNAuthorizationOptions = [.alert,.sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                debugPrint("Something went wrong")
            } else {
                debugPrint("Notifications granted")
                
            }
        }
        
        let uuid = UUID(uuidString: "61C16BAA-AB2D-4B54-829F-CC456704F319")! //iRot
        //let uuid = UUID(uuidString: "FF896073-0D64-4EC9-8AE8-8E443C7DB8FB")! // iRotII
        //let uuid = UUID(uuidString: "6231F718-1494-47F5-809C-8E86C4360D76")! //peterBeacon
        //let uuid = UUID(uuidString: "824EDFBF-874E-4D14-A8B6-065D8730E867")! //mikko
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "iRot")
        beaconRegion.notifyOnEntry = true
        beaconRegion.notifyOnExit = false
        beaconRegion.notifyEntryStateOnDisplay = false
        
        let content = UNMutableNotificationContent()
        content.title = "Hello Wall"
        content.body = "You have entered a Wall area"
        
        let trigger = UNLocationNotificationTrigger(region: beaconRegion, repeats: false)
        
        let identifier = "BeaconLocationIdentifier"
        let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            
        })
        

        DispatchQueue.main.async {
            self.locationManager.startMonitoring(for: beaconRegion)
            self.locationManager.startRangingBeacons(in: beaconRegion)
            self.locationManager.startUpdatingLocation()
        }
        
        
    }
    
    class func shared() -> BeaconManager {
        return sharedNetworkManager
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Called when the notification has been swiped or tapped by the user
        
        // Do something with the response here
        
        // Make sure you call the completion handler
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Called when the app is in the foreground
        
        // Do something with the notification here
        
        // Make sure you call the completion handler
        completionHandler([.alert, .sound])
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            updateDistance(beacons[0].proximity)
        } else {
            updateDistance(.unknown)        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        debugPrint("Entered Region \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        debugPrint("Exited Region \(region.identifier)")
    }
    
    func updateDistance(_ distance: CLProximity) {
        UIView.animate(withDuration: 0.8) {
            switch distance {
            case .unknown:
                print("disconnected")
                
            case .far:
                print("far")
                
            case .near:
                print("near")
                
            case .immediate:
                print("close")
            }
        }
    }

}
