//
//  Slot.swift
//  CompletedRainbowRun
//
//  Created by Alexander Saleh on 5/20/15.
//  Copyright (c) 2015 Moonwalk Studios. All rights reserved.
//

import Foundation

class Slot:Equatable{
    
    var x:Float
    var id:UInt32
    var used:Bool = false
    
    init (x:Float){
        
        self.x = x
        self.id = arc4random_uniform(200)
        
    }
    
}

func ==(lhs: Slot, rhs: Slot) -> Bool{
    
    return lhs.id == rhs.id && lhs.x == rhs.x
    
}