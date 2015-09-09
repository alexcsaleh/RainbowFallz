//
//  Rainbow.swift
//  CompletedRainbowRun
//
//  Created by Alexander Saleh on 5/20/15.
//  Copyright (c) 2015 Moonwalk Studios. All rights reserved.
//

import Foundation
import SpriteKit

class Rainbow: SKSpriteNode {
    
    var direction = CGPointZero
    var index:Int = 0
    var colliding = false
    var currentSlot:Slot?
    
    init(position: CGPoint, texture: SKTexture, index:Int) {
        
        super.init(texture: texture, color: SKColor.whiteColor(), size: texture.size())
        
        self.anchorPoint = CGPointMake(0.5, 0)
        
        self.position = position
        self.index = index
        self.name = "Rainbow_" + index.description
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        //println("test \(target)")
        
    }
    
    func fadeOut(duration:NSTimeInterval){
        
        runAction(SKAction.sequence([
            SKAction.fadeOutWithDuration(duration),
            SKAction.runBlock({ self.freeItem()}),
            SKAction.removeFromParent()]))
        
    }
    
    private func freeItem(){
        
        colliding = false
        
    }
    
    var slot:Slot {
        
        get {
            return currentSlot!
        }
        set{
            currentSlot = newValue
        }
        
    }
    var isBlack: Bool {
        get {
            return texture?.description.rangeOfString("Black") != nil
        }
        
    }
}
