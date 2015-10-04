//
//  CGFloat+Extension.swift
//  CompletedRainbowRun
//
//  Created by Alexander Saleh on 5/20/15.
//  Copyright (c) 2015 Moonwalk Studios. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGFloat {
    
    /**
    * Returns a random floating point number between 0.0 and 1.0, inclusive.
    */
    static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    /**
    * Returns a random floating point number in the range min...max, inclusive.
    */
    static func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        assert(min < max)
        return CGFloat.random() * (max - min) + min
    }
    
}
