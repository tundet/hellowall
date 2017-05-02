//
//  MapViewController.swift
//  HelloWall
//
//  Created by Tünde Taba on 14.4.2017.
//  Copyright © 2017 Tünde Taba. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let locationManager = BeaconManager.shared()
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        let koululocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(60.220835, 24.805561)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = koululocation
        annotation.title = "Metropolia AMK"
        mapView.addAnnotation(annotation)
        
        fetchLocations()
        
    }
    
    func fetchLocations(){
        
        //let url = NSURL(string: "https://users.metropolia.fi/~tundet/web/home.json")
        let url = NSURL(string: "https://irot-hello-wall.othnet.ga/locations")
        URLSession.shared.dataTask(with: url! as URL){
            (data, response, error) in
            
            if error != nil {
                print(error as Any)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                if let jsondict = json["data"]{
                    
                    for dictionary in jsondict as! [[String: AnyObject]]{
                        let annotation = CustomPointAnnotation()
                        print(dictionary["name"] as! String)
                        annotation.title = dictionary["name"] as? String
                        annotation.subtitle = dictionary["description"] as? String
                        let longitude = dictionary["longitude"] as? String
                        let latitude = dictionary["latitude"] as? String
                        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(longitude!)!, CLLocationDegrees(latitude!)!)
                        if let imgurl = NSURL(string: dictionary["style"]?["logo_url"] as! String){
                            print(imgurl)
                            let imgdata = NSData(contentsOf: imgurl as URL)
                            annotation.logo = UIImage(data: imgdata as! Data)
                        }
                        annotation.coordinate = location
                        self.mapView.addAnnotation(annotation)
                        print("\(annotation.title) added")
                    }
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        let location = locations.last as! CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        var region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        region.center = mapView.userLocation.coordinate
        mapView.setRegion(region, animated: true)
        
    }
    
    //Custom annotation
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
