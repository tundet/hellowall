//
//  ColorPickerDelegate.swift
//  HelloWall
//
//  Created by Tünde Taba on 10.4.2017.
//  Copyright © 2017 Tünde Taba. All rights reserved.
//

internal protocol ColorPickerDelegate : NSObjectProtocol {
    func ColorPickerTouched(sender:ColorPicker, color:UIColor, point:CGPoint, state:UIGestureRecognizerState)
}
