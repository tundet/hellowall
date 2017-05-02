//
//  HSBColorPickerDelegate.swift
//  HelloWall
//
//  Created by Tünde Taba on 10.4.2017.
//  Copyright © 2017 Tünde Taba. All rights reserved.
//
import

internal protocol HSBColorPickerDelegate : NSObjectProtocol {
    func HSBColorColorPickerTouched(sender:HSBColorPicker, color:UIColor, point:CGPoint, state:UIGestureRecognizerState)
}
