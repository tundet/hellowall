//
//  MapViewController.swift
//  Map with annotations for locations.
//
//  Created by Tünde Taba on 14.4.2017.
//  Copyright © 2017 Tünde Taba. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let locationManager = BeaconManager.shared()
    var locations = [Location]()
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
    
        fetchLocations()
        
    }
    
    // Get locations from API and add their annotations to map
    func fetchLocations(){
        
        ApiService.sharedInstance.fetchLocations{ (locations: [Location]) in
            self.locations = locations
            for location in self.locations{
                let annotation = CustomPointAnnotation()
                annotation.title = location.name
                annotation.subtitle = location.description
                if let imgurl = location.logo_url{
                    let imgdata = NSData(contentsOf: imgurl as URL)
                    annotation.logo = UIImage(data: imgdata as! Data)
                }
                annotation.coordinate = location.coordinates!
                self.mapView.addAnnotation(annotation)
                }
            }
        }
    
    // Updating user's location
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        let location = locations.last as! CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        var region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        region.center = mapView.userLocation.coordinate
        mapView.setRegion(region, animated: true)
        
    }
    
    //Custom annotation with image
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // If annotation is not of type RestaurantAnnotation (MKUserLocation types for instance), return nil
        if !(annotation is CustomPointAnnotation){
            return nil
        }
        
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "pin")
        
        if annotationView == nil{
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            annotationView?.canShowCallout = true
        }else{
            annotationView?.annotation = annotation
        }
        
        let cpa = annotation as! CustomPointAnnotation
        annotationView?.detailCalloutAccessoryView = UIImageView(image: cpa.logo)
        return annotationView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
