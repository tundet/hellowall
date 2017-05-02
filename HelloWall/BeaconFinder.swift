//
//  BeaconFinder.swift
//  HelloWall
//
//  Created by Tünde Taba on 9.4.2017.
//  Copyright © 2017 Tünde Taba. All rights reserved.
//

import Foundation
import CoreLocation
import UserNotifications

class BeaconFinder: CLLocationManagerDelegate, UNUserNotificationCenterDelegate{
    
    var locationManager = CLLocationManager()
    

        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        let options: UNAuthorizationOptions = [.alert,.sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                debugPrint("Something went wrong")
            } else {
                debugPrint("Notifications granted")
                
            }
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
    
    func startScanning() {
        let uuid = UUID(uuidString: "61C16BAA-AB2D-4B54-829F-CC456704F319")! //iRot
        //let uuid = UUID(uuidString: "6231F718-1494-47F5-809C-8E86C4360D76")! //peterBeacon
        //let uuid = UUID(uuidString: "824EDFBF-874E-4D14-A8B6-065D8730E867")! //mikko
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "iRot")
        beaconRegion.notifyOnEntry = true
        beaconRegion.notifyOnExit = true
        beaconRegion.notifyEntryStateOnDisplay = true
        
        let content = UNMutableNotificationContent()
        content.title = "Entered beacon"
        content.body = "notification"
        
        let trigger = UNLocationNotificationTrigger(region: beaconRegion, repeats: true)
        
        let identifier = "BeaconLocationIdentifier"
        let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            
        })
        
        
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
        locationManager.startUpdatingLocation()
        
        
        
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
        print("Entered Region \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exited Region \(region.identifier)")
    }
    
    func updateDistance(_ distance: CLProximity) {
        UIView.animate(withDuration: 0.8) {
            switch distance {
            case .unknown:
                self.view.backgroundColor = UIColor.gray
                
            case .far:
                self.view.backgroundColor = UIColor.blue
                
            case .near:
                self.view.backgroundColor = UIColor.orange
                
            case .immediate:
                self.view.backgroundColor = UIColor.red
            }
        }
    }
}
