//
//  GameScene.swift
//  CompletedRainbowRun
//
//  Created by Alexander Saleh on 5/20/15.
//  Copyright (c) 2015 Moonwalk Studios. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var background = SKSpriteNode(imageNamed: "LaunchScreen")
    var timer = NSTimer()
    var counter: Double = 0
    var transitionFade = SKTransition.fadeWithDuration(1.46)
    
    
    override func didMoveToView(view: SKView) {
        viewLaunch()
        updateCounter()
        
        background.size.width = self.frame.size.width
        background.size.height = self.frame.size.height
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.addChild(self.background)
    }
    
    func viewLaunch() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("updateCounter"), userInfo: nil, repeats: true)
    }
    
    func updateCounter() {
        counter++
        if counter == 2 {
            let scene = MainMenu(size: self.size)
            let skView = self.view as SKView!
            skView.ignoresSiblingOrder = true
            scene.scaleMode = .AspectFill
            scene.size = skView.bounds.size
            skView.presentScene(scene, transition: transitionFade)
            
        }
    }
    
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
