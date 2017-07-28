//
//  GestureAction.swift
//  GestureRecognize
//
//  Created by Vasudevan Seshadri on 7/17/17.
//  Copyright © 2017 Vasudevan Seshadri. All rights reserved.
//

import Foundation
import CoreMotion


var startedLeftTilt     = false
var startedRightTilt    = false
var dateLastShake       = NSDate(timeIntervalSinceNow: -1)
var dateStartedTilt     = NSDate(timeIntervalSinceNow: -1)
let tresholdFirstMove   = 5.0
let tresholdBackMove    = 0.75

private func handleGyroData(rotation: CMRotationRate) {
    
    if fabs(rotation.z) > tresholdFirstMove && fabs(dateLastShake.timeIntervalSinceNow) > 0.2
    {
        if !startedRightTilt && !startedLeftTilt
        {
            dateStartedTilt = NSDate()
            if (rotation.z > 0)
            {
                startedLeftTilt = true
                startedRightTilt = false
            }
            else
            {
                startedRightTilt = true
                startedLeftTilt = false
            }
        }
    }
    
    if fabs(dateStartedTilt.timeIntervalSinceNow) >= 0.2
    {
        startedRightTilt = false
        startedLeftTilt = false
    }
    else
    {
        if (fabs(rotation.z) > tresholdBackMove)
        {
            if startedLeftTilt && rotation.z < 0
            {
                NSLog("Left")
                dateLastShake = NSDate()
                startedRightTilt = false
                startedLeftTilt = false
                paintRedColor()
                performAction(likeStock: false)
                getSymbol(isNextSymbol: true)
                
                
            }
            else if startedRightTilt && rotation.z > 0
            {
                NSLog("Right")
                dateLastShake = NSDate()
                startedRightTilt = false
                startedLeftTilt = false
                paintGreenColor()
                performAction(likeStock: true)
                getSymbol(isNextSymbol: true)
            }
        }
    }
    
}
