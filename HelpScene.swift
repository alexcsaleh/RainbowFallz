//
//  HelpScene.swift
//  CompletedRainbowRun
//
//  Created by Alexander Saleh on 5/20/15.
//  Copyright (c) 2015 Moonwalk Studios. All rights reserved.
//

import SpriteKit
import Foundation
import AudioToolbox
import AVFoundation

class HelpScene: SKScene {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var background: SKSpriteNode
    var backButton: SKSpriteNode
    var backButtonTextures = [SKTexture]()
    var backButtonTexturesIphone6Plus = [SKTexture]()
    
    let floor = SKSpriteNode(imageNamed: "floor") // The floor image that is placed infront of the background
    var playButtonSound = SKAction.playSoundFileNamed("RainbowRunButton.caf", waitForCompletion: false)
    var hero: SKSpriteNode
    var heroBaseline = CGFloat(0)
    let transitionDoors = SKTransition.doorsOpenVerticalWithDuration(1.565)
    
    // The maximum left x value of the screen
    var frameMaxLeft:CGFloat?
    var frameMaxRight:CGFloat?
    
    // Array for running hero textures
    var runningHeroTextures = [SKTexture]()
    var runningHeroTexturesIphone6Plus = [SKTexture]()
    
    // Movement of hero left
    var heroMovingLeft = false
    // Movement of hero right
    var heroMovingRight = false
    
    // Hero walking Speed
    var heroSpeed:CGFloat = 0.62
    
    var musicLoop: AVAudioPlayer!
    //let transitionSound = SKAction.playSoundFileNamed("rweind2.caf", waitForCompletion: false)

    override init(size: CGSize) {
        self.backButton = SKSpriteNode(texture: SKTexture(imageNamed: "backButt0"))
        self.hero = SKSpriteNode(texture: SKTexture(imageNamed: "left_0"))
        self.background = SKSpriteNode(imageNamed: "HelpSceneBackground")
        
        
        
        if DeviceType.IS_IPHONE_6 {
            self.hero = SKSpriteNode(texture: SKTexture(imageNamed: "left_0"))
            self.backButton = SKSpriteNode(texture: SKTexture(imageNamed: "backButton"))
            self.floor.size.width = self.floor.size.width * 1.172
            self.floor.size.height = self.floor.size.height * 1.174
            self.background.size.width = background.size.width * 1.172
            self.background.size.height = background.size.height * 1.174
            self.backButton.size.width = backButton.size.width * 1.172
            self.backButton.size.height = backButton.size.height * 1.174
            self.hero.size.width = hero.size.width * 1.172
            self.hero.size.height = hero.size.height * 1.174
        }
        if DeviceType.IS_IPHONE_5 {
            self.hero = SKSpriteNode(texture: SKTexture(imageNamed: "left_0"))
            self.backButton = SKSpriteNode(texture: SKTexture(imageNamed: "backButton"))
        }
        if DeviceType.IS_IPHONE_6P {
           self.hero = SKSpriteNode(texture: SKTexture(imageNamed: "walkleft_0"))
            self.backButton = SKSpriteNode(texture: SKTexture(imageNamed: "backButt0"))
            self.hero.size.width = self.hero.size.width / 3
            self.hero.size.height = self.hero.size.height / 3
            self.backButton.size.width = self.backButton.size.width / 3
            self.backButton.size.height = self.backButton.size.height / 3
        }
        if DeviceType.IS_IPAD {
            self.backButton = SKSpriteNode(texture: SKTexture(imageNamed: "backButton"))
            
        }
        
        self.hero.name = "hero"
        
        let halfHero =  hero.size.width / 2
        super.init(size: size)
    }
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        determineTextureHeroAtlas()
        moveHero("left")
        loadHeroMovement()
        determineHeroSize()
        determineButtonAnimation()
        
        //playMusicLoop("menu.caf")
      
        var diff:CGFloat = 30.0
        if DeviceType.IS_IPHONE_6P{
            diff = 165.8
        }
        if DeviceType.IS_IPHONE_5{
            diff = 127.5
        }
        if DeviceType.IS_IPAD{
            diff = 230
        }
        if DeviceType.IS_IPHONE_6{
            diff = 148.9
        }
        
        self.floor.anchorPoint = CGPointMake(0, 0.5) // Placing the anchorpoint for the floor image
        self.floor.position = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame) + (self.floor.size.height / 2)) // positioning the floor
        
        
        self.backButton.position = CGPointMake(CGRectGetMidX(self.frame) - (self.frame.size.width / 4) - 5, CGRectGetMinY(self.frame) + (self.backButton.size.height / 2) * 2.4)
        
        
        
        
        self.background.size.width = self.frame.size.width
        self.background.size.height = self.frame.size.height
        self.background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        
        
        // Position of the baseline(where the hero walk on top of)
        self.heroBaseline = self.floor.position.y + self.floor.size.height
        
        self.frameMaxLeft = CGRectGetMidX(self.frame) + (self.frame.width / 2.80) - (self.hero.size.width * 1.57)
        self.frameMaxRight = CGRectGetMidX(self.frame) + (self.frame.width / 2) - self.hero.size.width / 1.7
        
        // Starting position of the hero
        self.hero.zPosition = 10
        self.hero.anchorPoint = CGPointMake(0.5, 0)
        //self.hero.position = CGPointMake(CGRectGetMaxX((self.frame)) * 0.85,
        self.hero.position = CGPointMake(CGRectGetMidX((self.frame)) + self.floor.size.width / 2.5, CGRectGetMidY(self.frame) - diff/* - self.floor.size.height / 2*/)
        self.addChild(self.background)
        self.addChild(self.hero)
        self.addChild(self.backButton)
    }
    
    func playMusicLoop(filename: String) {
        let url = NSBundle.mainBundle().URLForResource(filename, withExtension: nil)
        if(url == nil) {
            println("could not find file: \(filename)")
            return
        }
        var error: NSError? = nil
        musicLoop = AVAudioPlayer(contentsOfURL: url, error: &error)
        if musicLoop == nil {
            println("Could not create audio player: \(error!)")
            return
        }
        
        self.musicLoop.numberOfLoops = -1
        self.musicLoop.prepareToPlay()
        self.musicLoop.volume = 0.4
        self.musicLoop.play()
        
    }
    
    func determineButtonAnimation() {
        if DeviceType.IS_IPHONE_5 {
          loadBackButtonTextures()
        }
        if DeviceType.IS_IPHONE_6 {
            loadBackButtonTextures()
        }
        if DeviceType.IS_IPAD {
            loadBackButtonTextures()
        }
        if DeviceType.IS_IPHONE_6P {
            loadBackButtonTexturesIphone6Plus()
        }
        
    }
    
    
    func determineHeroSize() {
        if DeviceType.IS_IPHONE_5 {
            runHero()
        }
        if DeviceType.IS_IPHONE_6 {
            runHero()
        }
        if DeviceType.IS_IPAD {
            runHero()
        }
        if DeviceType.IS_IPHONE_6P {
            runHeroIphone6P()
        }
    }
    
    func determineTextureHeroAtlas() {
        if DeviceType.IS_IPHONE_5 {
            loadHeroTextures()
        }
        if DeviceType.IS_IPHONE_6 {
            loadHeroTextures()
        }
        if DeviceType.IS_IPHONE_6P {
            loadHeroTexturesIphone6Plus()
        }
        if DeviceType.IS_IPAD {
            loadHeroTextures()
        }
    }
    
    func loadBackButtonTextures() {
        var buttonAtlas = SKTextureAtlas(named: "BackButtonAnimations")
        
        for i in 1...1 {
            var textureName = "backButton\(i)"
            var temp = buttonAtlas.textureNamed(textureName)
            self.backButtonTextures.append(temp)
        }
    }
    func loadBackButtonTexturesIphone6Plus() {
        var buttonAtlas = SKTextureAtlas(named: "BackButtonAnimationsIphone6Plus")
        
        for i in 1...1 {
            var textureName = "backButt\(i)"
            var temp = buttonAtlas.textureNamed(textureName)
            self.backButtonTexturesIphone6Plus.append(temp)
        }
    }
    
    
    func backAnimation() {
        backButton.runAction(SKAction.animateWithTextures(backButtonTextures, timePerFrame: 0.72, resize: false, restore: true), withKey: "Back")
    }
    func backAnimationIphone6Plus() {
        backButton.runAction(SKAction.animateWithTextures(backButtonTexturesIphone6Plus, timePerFrame: 0.72, resize: false, restore: true), withKey: "BackIphone6Plus")
    }
    
    
    
    
    enum UIUserInterfaceIdiom : Int
    {
        case Unspecified
        case Phone
        case Pad
    }
    
    struct ScreenSize
    {
        static let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
        static let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
        static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
    
    struct DeviceType
    {
        static let IS_IPHONE_4_OR_LESS =  UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
        static let IS_IPHONE_5 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
        static let IS_IPHONE_6 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
        static let IS_IPHONE_6P = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
        static let IS_IPAD = UIDevice.currentDevice().userInterfaceIdiom == .Pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
        
    }
    
    
    
    
    
    /* Looping the animation of the hero*/
    func loadHeroTextures() {
        var runningLeftAtlas = SKTextureAtlas(named: "MovingLeft")
        
        for i in 1...9 {
            var textureName = "left_\(i)"
            var temp = runningLeftAtlas.textureNamed(textureName)
            self.runningHeroTextures.append(temp)
        }
    }
    func loadHeroTexturesIphone6Plus() {
        var runningLeftAtlas = SKTextureAtlas(named: "MovingLeftOnIphone6Plus")
        
        for i in 1...9 {
            var textureName = "walkleft_\(i)"
            var temp = runningLeftAtlas.textureNamed(textureName)
            self.runningHeroTexturesIphone6Plus.append(temp)
        }
    }

    // This will start running the run loop
    func runHero() {
        hero.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(runningHeroTextures, timePerFrame: 0.136, resize: false, restore: true)), withKey: "runHero")
    }
    
    func runHeroIphone6P() {
        hero.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(runningHeroTexturesIphone6Plus, timePerFrame: 0.099, resize: false, restore: true)), withKey: "runHeroIphone6P")
    }
    
    /* this loads the hero movement-animations*/
    func loadHeroMovement() {
        hero.position.y -= hero.size.height / 2
        hero.position.x = -(scene!.size.width / 2)  + hero.size.width * 2
    }
    
    
    /* The function that makes the hero move into a certain direction*/
    func moveHero(direction: String) {
        if direction == "right" {
            heroMovingLeft = true
            hero.xScale = -1
            heroMovingRight = false
        } else {
            heroMovingRight = true
            hero.xScale = 1
            heroMovingLeft = false
        }
    }
    
    
    /* function that passes bounds to the screen*/
    func updateHeroPosition() {
        if hero.position.x < frameMaxLeft {
            moveHero("left")
        }
        
        if hero.position.x > frameMaxRight {
            moveHero("right")
        }
        
        switch true {
            
        case heroMovingLeft:
            hero.position.x -= heroSpeed
            
        case heroMovingRight:
            hero.position.x += heroSpeed
            
        default:
            hero.position.x += 0
            
        }
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.backButton {
                if DeviceType.IS_IPHONE_6 {
                  backAnimation()
                }
                if DeviceType.IS_IPHONE_5 {
                    backAnimation()
                }
                if DeviceType.IS_IPHONE_6P {
                    backAnimationIphone6Plus()
                }
                if DeviceType.IS_IPAD {
                    backAnimation()
                }
                runAction(playButtonSound)
            }
            
        }
    }
    
    override func  touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.backButton {
                //musicLoop.stop()
                //runAction(transitionSound)
                var scene = MainMenu(size: self.size)
                let skView = self.view as SKView!
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .ResizeFill
                scene.size = skView.bounds.size
                skView.presentScene(scene, transition: transitionDoors)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func update(currentTime: NSTimeInterval) {
        updateHeroPosition()
    }
    
    
}


