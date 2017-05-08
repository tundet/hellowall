//
//  DrawViewController.swift
//  View for drawing something and changing brush settings.
//  After drawing is done user can save it in a custom folder and post it
//  to current location's wall.
//
//  Created by Tünde Taba on 9.4.2017.
//  Copyright © 2017 Tünde Taba. All rights reserved.
//

import UIKit

class DrawViewController: UIViewController, ColorPickerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    @IBOutlet weak var showColor: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var colorPicker: ColorPicker!
    @IBOutlet weak var sizeSlider: UISlider!
    @IBOutlet weak var imageViewBrush: UIImageView!
    
    var lastPoint = CGPoint.zero
    var swiped = false
    var brushcolor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
    var brushsize: CGFloat = 10.0
    var pickershow = false
    var today: String?
    let defaults = UserDefaults.standard
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Disable effect for now
        blurEffect.isHidden = true
        
        //UI Color View setup
        colorView.layer.cornerRadius = 5
        colorView.backgroundColor = UIColor.gray
        colorPicker.delegate = self
        drawPreview()   //draw the brush preview
        
        defaults.set("2017-03-21", forKey: "yesterday")     //For testing
        setDate()
        
        self.tabBarController?.tabBar.isHidden = true   //don't show tab bar for navigation in this scene
        
    }
    
    // Update brush color according to color picked in ColorPicker
    internal func ColorPickerTouched(sender: ColorPicker, color: UIColor) {
        if pickershow == true {
            self.brushcolor = color
            drawPreview()
        }
    }
    
    // Touching started. Save point if ColorPicker is not open.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if pickershow == false {
            swiped = false
            if let touch = touches.first {
                lastPoint = touch.location(in: self.imageView)
                
            }
        }
    }
    
    // Method for drawing line on image view, if ColorPicker is not open.
    func drawLines(fromPoint: CGPoint, toPoint: CGPoint){
            UIGraphicsBeginImageContext(self.imageView.frame.size)
            imageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.imageView.frame.width, height: self.imageView.frame.height))
            let context = UIGraphicsGetCurrentContext()
            
            context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
            context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
            context?.setBlendMode(CGBlendMode.normal)
            context?.setLineCap(CGLineCap.round)
            context?.setLineWidth(self.brushsize)
            context?.setStrokeColor(self.brushcolor.cgColor)
            
            context?.strokePath()
            
            imageView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
    }
    
    // Draw the line from first touch to current
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if pickershow == false {
            swiped = true
            if let touch = touches.first {
                let currentPoint = touch.location(in: self.imageView)
                drawLines(fromPoint: lastPoint, toPoint: currentPoint)
                
                lastPoint = currentPoint
            }
        }
    }
    
    // For drawing a "dot" if ColorPicker is not open
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        if pickershow == false{
            if !swiped {
                drawLines(fromPoint: lastPoint, toPoint: lastPoint)
            }
        }
        
    }
    
    // Save the current image view to custom folder
    func saveImage() {
        if imageView.image != nil{
            let imageData = UIImageJPEGRepresentation(imageView.image!, 1)
            let compressedJPGImage = UIImage(data: imageData!)
            CustomPhotoAlbum.sharedInstance.save(image: compressedJPGImage!)
            
            // create the alert
            let alert = UIAlertController(title: "Saved", message: "What an ugly drawing...", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Thanks", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    // Save image button
    @IBAction func saveImage(_ sender: Any) {
        saveImage()
    }
    
    // Reset canvas button
    @IBAction func resetImage(_ sender: Any) {
        let alert = UIAlertController(title: "Reset", message: "Are you sure you want to start over?", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in self.imageView.image = nil}))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        //imageView.image = nil
    }
    
    // Open ColorPicker button
    @IBAction func setBrush(_ sender: Any) {
        animateIn()
    }
    
    // Selected color button
    @IBAction func setColor(_ sender: Any) {
        animateOut()
    }
    
    //Show color picker in main view
    func animateIn(){
        self.imageView.isUserInteractionEnabled = false
        self.colorView.isUserInteractionEnabled = true
        self.pickershow = true
        self.view.addSubview(colorView)
        colorView.center = self.view.center
        colorView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        colorView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.blurEffect.isHidden = false
            self.colorView.alpha = 1
            self.colorView.transform = CGAffineTransform.identity
        }
    }
    
    //Hide color picker in main view
    func animateOut(){
        self.colorView.isUserInteractionEnabled = false
        self.imageView.isUserInteractionEnabled = true
        self.pickershow = false
        UIView.animate(withDuration: 0.3, animations: {
            self.colorView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.colorView.alpha = 0
            
            self.blurEffect.isHidden = true
            
        }) { (success: Bool) in
            self.colorView.removeFromSuperview()
        }
    }
    
    //Give value to brushpreview
    @IBAction func sliderChanged(_ sender: UISlider) {
        self.brushsize = CGFloat(sender.value)
        
        drawPreview()
    }
    
    
    //Change brush preview
    func drawPreview() {
        UIGraphicsBeginImageContext(imageViewBrush.frame.size)
        var context = UIGraphicsGetCurrentContext()
        
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(self.brushsize)
        context?.setStrokeColor(self.brushcolor.cgColor)
        
        context?.move(to: CGPoint(x: 45.0, y: 45.0))
        context?.addLine(to: CGPoint(x: 45.0, y: 45.0))
        context?.strokePath()
        imageViewBrush.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIGraphicsBeginImageContext(imageViewBrush.frame.size)
        context = UIGraphicsGetCurrentContext()
        
        UIGraphicsEndImageContext()
    }
    
    // Upload post button, only once a day is allowed.
    @IBAction func uploadPost(_ sender: Any) {
        if defaults.object(forKey:"yesterday") as? String  == today {
            let alert = UIAlertController(title: "Sorry", message: "You can only post once a day to this wall", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }else{
        if imageView.image != nil{
            let alert = UIAlertController(title: "Post", message: "Are you ready to upload?", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {
                (alert: UIAlertAction!) in self.postImageRequest()
            }))
            alert.addAction(UIAlertAction(title: "Not yet", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // Post method to current location and save date
    func postImageRequest(){
        let id = BeaconManager.sharedInstance.location_id
        var request  = URLRequest(url: URL(string: "https://irot-hello-wall.othnet.ga/posts")!)
        request.httpMethod = "POST"
        
        let param = [
            "location_id" : id
        ]
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.7)
        
        if(imageData == nil){
            return;
        }
        
        request.httpBody = createBody(parameters: param, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            }.resume()
        
        defaults.set(today, forKey: "yesterday")
        print(defaults.object(forKey: "yesterday") as! String)
        
        let alert = UIAlertController(title: "Posted", message: "Your post has been uploaded", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: { action in self.performSegue(withIdentifier: "gohome", sender: self) }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    // Create body that is posted to API
    func createBody(parameters: [String: Any]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = "drawing.jpg"
        let mimetype = "image/jpg"
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        body.appendString(string: "--\(boundary)--\r\n")
        return body
    }
    
    // Set up current date in right format
    func setDate(){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        today = result
        if defaults.object(forKey: "yesterday") == nil {
            defaults.set("2017-03-21", forKey: "yesterday")
        }
        
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
