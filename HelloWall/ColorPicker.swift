//
//  ColorPicker.swift
//  UIView that shows a variety of colors to pick from and gives
//  the picked color to DrawViewController.
//
//  Created by Tünde Taba on 10.4.2017.
//  Copyright © 2017 Tünde Taba. All rights reserved.
//

import UIKit

// Giving selected UIColor of brush to DrawViewController
internal protocol ColorPickerDelegate : NSObjectProtocol {
    func ColorPickerTouched(sender:ColorPicker, color:UIColor)
}


@IBDesignable
class ColorPicker: UIView {

    var delegate: ColorPickerDelegate?
    
    //setting up saturation
    let saturationExponentTop:Float = 1.0
    let saturationExponentBottom:Float = 1.0
    
    //setting up size of colors (the bigger the less colors to choose from)
    @IBInspectable var elementSize: CGFloat = 12.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private func initialize() {
        self.clipsToBounds = true
        let touchGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.touchedColor(gestureRecognizer:)))
        touchGesture.minimumPressDuration = 0
        touchGesture.allowableMovement = CGFloat.greatestFiniteMagnitude
        self.addGestureRecognizer(touchGesture)
    }
    
    // Setting up frame
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    // Setting up encoder
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    // Drawing the colors
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        for y in stride(from: (0 as CGFloat), to: rect.height, by: elementSize) {
            
            var saturation = y < rect.height / 2.0 ? CGFloat(2 * y) / rect.height : 2.0 * CGFloat(rect.height - y) / rect.height
            saturation = CGFloat(powf(Float(saturation), y < rect.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
            let brightness = y < rect.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(rect.height - y) / rect.height
            
            for x in stride(from: (0 as CGFloat), to: rect.width, by: elementSize) {
                let hue = x / rect.width
                let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
                context!.setFillColor(color.cgColor)
                context!.fill(CGRect(x:x, y:y, width:elementSize,height:elementSize))
            }
        }
    }
    
    // Get UIColor according to point
    func getColorAtPoint(point:CGPoint) -> UIColor {
        let roundedPoint = CGPoint(x:elementSize * CGFloat(Int(point.x / elementSize)),
                                   y:elementSize * CGFloat(Int(point.y / elementSize)))
        var saturation = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(2 * roundedPoint.y) / self.bounds.height
            : 2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
        saturation = CGFloat(powf(Float(saturation), roundedPoint.y < self.bounds.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
        let brightness = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
        let hue = roundedPoint.x / self.bounds.width
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
    
    // Recognize gesture and give delegate the selected color
    func touchedColor(gestureRecognizer: UILongPressGestureRecognizer){
        let point = gestureRecognizer.location(in: self)
        let color = getColorAtPoint(point: point)
        
        self.delegate?.ColorPickerTouched(sender: self, color: color)
    }
    
}
