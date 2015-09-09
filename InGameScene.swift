//
//  InGameScene.swift
//  CompletedRainbowRun
//
//  Created by Alexander Saleh on 5/20/15.
//  Copyright (c) 2015 Moonwalk Studios. All rights reserved.
//

import SpriteKit
import UIKit
import Foundation
import AudioToolbox
import AVFoundation




class InGameScene: SKScene, SKPhysicsContactDelegate {
    
    var ifDeathIsTrue = false
    var rainbowDelays:[Int] = [50,60,40,55,54,52,66]
    var delayer = 0
    var availableSlots:Array<Slot> = [Slot(x: -143), Slot(x: -96), Slot(x: -48), Slot(x: 0), Slot(x: 48), Slot(x: 96), Slot(x: 143)] // Spawning positions for the rainbows
    var rainbowHitSounds = []
    let rainbowHit3 = SKAction.playSoundFileNamed("rainbowHit3.caf", waitForCompletion: false)
    let rainbowHit2 = SKAction.playSoundFileNamed("rainbowHit2.caf", waitForCompletion: false)
    let rainbowHit1 = SKAction.playSoundFileNamed("rainbowHit1.caf", waitForCompletion: false)
    let deathSound = SKAction.playSoundFileNamed("gameOver.caf", waitForCompletion: false)
    var musicLoop: AVAudioPlayer!
    
    var timer = NSTimer()
    var counter: Double = 0.0
    var arrowTimer = NSTimer()
    var arrowCounter: Double = 0.0
    var cloudTimer = NSTimer()
    var cloudCounter: Double = 0.0
    var cloudNumber0: Double = 0
    
    var randomIndexRainbowHit: Int
    var currentSound: AnyObject
    var gameOver = false
    var deathPosition: CGPoint
    
    var floor: SKSpriteNode
    var hero: SKSpriteNode
    var background: SKSpriteNode
    var rainbow: SKSpriteNode
    var scoreBox: SKSpriteNode
    var leftArrow: SKSpriteNode
    var rightArrow: SKSpriteNode
    
    let rainbowTextures = SKTexture()
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    
    var cloudAnimation1 = [SKTexture]()
    var cloudAnimation2 = [SKTexture]()
    var cloudAnimation3 = [SKTexture]()
    var cloudAnimation4 = [SKTexture]()
    var cloudAnimation5 = [SKTexture]()
    
    var clouds: SKSpriteNode
    
    // The maximum left and right x value of the screen
    var frameMaxLeft:CGFloat?
    var frameMaxRight:CGFloat?
    
    
    var scoreText = SKLabelNode(fontNamed: "Menlo Bold")
    
    var origRunningFloorPositionXPoint = CGFloat(0)
    
    var maxBarX: CGFloat = CGFloat(0)
    
    var heroBaseline = CGFloat(0)
    
    //array for running wave textures
    var waveTexturesMedium = [SKTexture]()
    var waveTexturesSmall = [SKTexture]()
    var waveTexturesLarge = [SKTexture]()
    
    
    // array for running death animation
    var deathAnimationTextures = [SKTexture]()
    //var velocityY = CGFloat(0)
    let gravity = CGFloat(0.15) // In-game gravity
    // The score of the game
    var score = 0
    
    // Array for running hero textures
    var runningHeroTextures = [SKTexture]()
    var runningHeroTexturesIphone6Plus = [SKTexture]()
    
    // Waves in the ocean
    let waveMedium1: SKSpriteNode
    
    // Movement of hero left
    var heroMovingLeft = false
    // Movement of hero right
    var heroMovingRight = false
    // Hero walking Speed
    var heroSpeed:CGFloat = 0
    
    
    var adScreenTransition: Array <Int> = [/*1,2,3,4,5,*/6]
    var textureCloudArray = []

    

    
    enum ColliderType:UInt32 { // The types of object that can collide
        case Hero = 1
        case Rainbow = 2
        case DarkRainbow = 3
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
    
    
    
    override init(size: CGSize) {
        self.leftArrow = SKSpriteNode(imageNamed: "LeftArrow")
        self.rightArrow = SKSpriteNode(imageNamed: "RightArrow")
        self.scoreBox = SKSpriteNode(imageNamed: "ScoreBox")
        self.rainbow = SKSpriteNode(texture: SKTexture(imageNamed: "Rainbow"))
        self.background = SKSpriteNode(imageNamed: "background")
        self.floor = SKSpriteNode(imageNamed: "floor")
        self.clouds = SKSpriteNode(texture: SKTexture(imageNamed: "cloud0"))
        self.hero = SKSpriteNode(texture: SKTexture(imageNamed: "left_0"))
        self.waveMedium1 = SKSpriteNode(texture: SKTexture(imageNamed: "waveMedium0"))
        if DeviceType.IS_IPHONE_6 {
            self.hero = SKSpriteNode(texture: SKTexture(imageNamed: "left_0"))
            self.clouds.size.width = self.clouds.size.width * 1.172
            self.clouds.size.height = self.clouds.size.height * 1.174
            self.floor.size.width = self.floor.size.width * 1.172
            self.floor.size.height = self.floor.size.height * 1.174
            self.background.size.width = self.background.size.width * 1.172
            self.background.size.height = self.background.size.height * 1.174
            self.rainbow.size.width = self.rainbow.size.width * 1.172
            self.rainbow.size.height = self.rainbow.size.height * 1.174
            self.scoreBox.size.width = self.scoreBox.size.width * 1.172
            self.scoreBox.size.height = self.scoreBox.size.height * 1.174
            self.leftArrow.size.width = self.leftArrow.size.width * 1.172
            self.leftArrow.size.height = self.leftArrow.size.height * 1.174
            self.rightArrow.size.width = self.rightArrow.size.width * 1.172
            self.rightArrow.size.height = self.rightArrow.size.height * 1.174
            self.hero.size.width = self.hero.size.width * 1.172
            self.hero.size.height = self.hero.size.height * 1.174
        }
        if DeviceType.IS_IPHONE_5 {
            self.hero = SKSpriteNode(texture: SKTexture(imageNamed: "left_0"))
            
        }
        if DeviceType.IS_IPHONE_6P {
            self.hero = SKSpriteNode(texture: SKTexture(imageNamed: "walkleft_0"))
            self.hero.size.width = self.hero.size.width / 3
            self.hero.size.height = self.hero.size.height / 3
        }
        if DeviceType.IS_IPAD{
           self.hero = SKSpriteNode(texture: SKTexture(imageNamed: "left_0"))  
        }
        
        self.hero.name = "hero"
        
        let halfHero =  hero.size.width / 2
        deathPosition = hero.position
        
        
        
        
        currentSound = rainbowHitSounds
        randomIndexRainbowHit = 0
        rainbowHitSounds = [rainbowHit1, rainbowHit2, rainbowHit3]
        super.init(size: size)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    override func didMoveToView(view: SKView) {
        println("We are at the new scene!")

        
        
        playMusicLoop("gameMusic.caf")
        
        self.anchorPoint = CGPointMake(0.5, 0.0)
        
        currentDelay = generateDelay()
        loadLevel()
        runWaveMedium()
        
        self.physicsWorld.contactDelegate = self
        
        // The anchorpoint of the spawningbar
        self.floor.anchorPoint = CGPointMake(0, 0.5)
        
        // The position of the floor
        self.floor.position = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame) + (self.floor.size.height / 2))
        
        self.origRunningFloorPositionXPoint = self.floor.position.x
        self.maxBarX = self.floor.size.width - self.frame.size.width// geeft de total width van de spawningBar aan
        self.maxBarX *= -1
        
        // Position of the baseline(where the hero walk on top of)
        self.heroBaseline = self.floor.position.y + self.floor.size.height
        
        self.waveMedium1.position = CGPointMake(CGRectGetMidX(self.frame) - self.frame.width / 5, CGRectGetMidY(self.frame) - self.frame.height / 8)
        
 
        
      
        var diff:CGFloat = 30.0
        if DeviceType.IS_IPHONE_6{
            diff = 475.3
        }
        if DeviceType.IS_IPHONE_6P{
            diff = 523.3
        }
        if DeviceType.IS_IPHONE_5{
            diff = 404.0
        }
        if DeviceType.IS_IPHONE_4_OR_LESS{
            diff = 404.8
        }
        if DeviceType.IS_IPAD{
            diff = 728.7
        }
        
        
        if DeviceType.IS_IPAD{
            availableSlots = [Slot(x: -343), Slot(x: -229), Slot(x: -114), Slot(x: 0), Slot(x: 114), Slot(x: 229), Slot(x: 343)]
        }
        if DeviceType.IS_IPHONE_6P{
            availableSlots = [Slot(x: -185), Slot(x: -123), Slot(x: -62), Slot(x: 0), Slot(x: 62), Slot(x: 123), Slot(x: 185)]
        }
        if DeviceType.IS_IPHONE_5 {
            rainbowDelays = [ 45, 43, 47, 49, 52, 64, 48, 63]
        }
        if DeviceType.IS_IPAD {
            rainbowDelays = [90,95,85,115,78,130,120,85,105,10,20,140,90,95,100]
        }
        
        
        
        self.background.anchorPoint = CGPointMake(0.5, 0)
        self.background.size.width = self.frame.size.width
        self.background.size.height = self.frame.size.height
        self.background.position = CGPointMake(CGRectGetMidX(self.frame), 0)
        
        // Starting position of the hero
        self.hero.anchorPoint = CGPointMake(0.5, 0)
        self.hero.position = CGPointMake(0, floor.size.height - diff)
        
        
        self.frameMaxLeft = CGRectGetMidX(self.frame) - (self.frame.width / 2) + (self.hero.size.width / 2.9)
        self.frameMaxRight = CGRectGetMidX(self.frame) + (self.frame.width / 2) - (self.hero.size.width / 2.9)
        
        
        /* Enable the physics*/
        //self.hero.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(self.hero.size.width ) )
        self.hero.physicsBody?.affectedByGravity = false
        self.hero.physicsBody?.categoryBitMask = ColliderType.Hero.rawValue
        self.hero.physicsBody?.contactTestBitMask = ColliderType.Rainbow.rawValue
        self.hero.physicsBody?.contactTestBitMask = ColliderType.DarkRainbow.rawValue
        self.hero.physicsBody?.collisionBitMask = ColliderType.Rainbow.rawValue
        self.hero.physicsBody?.collisionBitMask = ColliderType.DarkRainbow.rawValue
        
        
        self.scoreText.text = "0"
        self.scoreText.fontSize = 30
        self.scoreText.zPosition = 3
        if DeviceType.IS_IPAD {
            self.scoreText.fontSize = 60
        }
        self.scoreText.fontColor = UIColor.yellowColor()
        
        self.scoreText.position = CGPointMake(CGRectGetMidX(self.frame), (CGRectGetMinY(self.frame) + 1.10 * self.scoreBox.size.height))
        self.clouds.position = CGPointMake(CGRectGetMidX(self.frame), (self.frame.size.height) - self.clouds.size.height / 2)
        self.scoreBox.position = CGPointMake(CGRectGetMidX(self.frame), (CGRectGetMinY(self.frame) + 1.39 * self.scoreBox.size.height))
        
       
        
        self.leftArrow.position = CGPointMake(CGRectGetMinX(self.frame) + self.scoreBox.size.width / 3.5, (CGRectGetMinY(self.frame) + 2.14 * self.scoreBox.size.height))
        self.leftArrow.size.height = 0.72 * self.leftArrow.size.height
        self.leftArrow.size.width = 0.72 * self.leftArrow.size.width
        
        self.rightArrow.position = CGPointMake(CGRectGetMaxX(self.frame) - self.scoreBox.size.width / 3.5, (CGRectGetMinY(self.frame) + 2.14 * self.scoreBox.size.height))
        self.rightArrow.size.height = 0.72 * self.rightArrow.size.height
        self.rightArrow.size.width = 0.72 * self.rightArrow.size.width
        
        
        
        self.clouds.zPosition = 10
        self.hero.xScale = 1
        
        
      
        
        self.addChild(self.waveMedium1)
        self.addChild(self.background)
        self.addChild(self.floor)
        self.addChild(self.hero)
        self.addChild(self.clouds)
        self.addChild(self.scoreBox)
        self.addChild(self.scoreText)
        self.addChild(self.leftArrow)
        self.addChild(self.rightArrow)
        
        
        arrowTimeUpdate()
        updateArrowCounter()
        updateCounter()
        
        animateCloud()
        //showCloudAnimation()
        
    }
    
    
    /* Function that loads the InGameScene level and all of its textures */
    func loadLevel() {
        
        //loadAllWaveTextures()
        //runWaveAnimations()
        loadHeroDeath()
        if DeviceType.IS_IPAD {
            loadHeroTextures()
            loadAnimation1()
            loadAnimation2()
            loadAnimation3()
            loadAnimation4()
            loadAnimation5()
        }
        if DeviceType.IS_IPHONE_5 {
            loadWaveMediumAnimation()
            loadHeroTextures()
            loadAnimation1()
            loadAnimation2()
            loadAnimation3()
            loadAnimation4()
            loadAnimation5()
        }
        if DeviceType.IS_IPHONE_6 {
            loadHeroTextures()
            loadAnimation1()
            loadAnimation2()
            loadAnimation3()
            loadAnimation4()
            loadAnimation5()
        }
        if DeviceType.IS_IPHONE_6P {
            loadHeroTexturesIphone6P()
        }
        
        loadHeroMovement()
        
    }
    
    
    
    
    
    
    
    
        
    
    func animateCloud() {
        
            var textureCloudArray = [cloudAnimation1, cloudAnimation2, cloudAnimation3, cloudAnimation4, cloudAnimation5]
            var randomIndex = Int(arc4random_uniform(UInt32(textureCloudArray.count)))
            
            clouds.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(textureCloudArray[randomIndex], timePerFrame: 0.12)))
            println("THIS ARRAY POSITION \(randomIndex)")
        
    }
    
    
    func loadAnimation1() {
        var loadingLeftBlack = SKTextureAtlas(named: "CloudAnimation1")
        
        for i in 1...84 {
            var textureName = "cloud\(i)"
            var temp = loadingLeftBlack.textureNamed(textureName)
            cloudAnimation1.append(temp)
        }
    }
    func loadAnimation2() {
        var loadingRightBlack = SKTextureAtlas(named: "CloudAnimation2")
        
        for i in 1...84 {
            var textureName = "cloud\(i)"
            var temp = loadingRightBlack.textureNamed(textureName)
            cloudAnimation2.append(temp)
        }
    }
    func loadAnimation3() {
        var loadingNormalLeft = SKTextureAtlas(named: "CloudAnimation3")
        
        for i in 1...84 {
            var textureName = "cloud\(i)"
            var temp = loadingNormalLeft.textureNamed(textureName)
            cloudAnimation3.append(temp)
        }
    }
    func loadAnimation4() {
        var loadingNormalRight = SKTextureAtlas(named: "CloudAnimation4")
        
        for i in 1...84 {
            var textureName = "cloud\(i)"
            var temp = loadingNormalRight.textureNamed(textureName)
            cloudAnimation4.append(temp)
        }
    }
    func loadAnimation5() {
        var loadingNormalRight = SKTextureAtlas(named: "CloudAnimation5")
        
        for i in 1...84 {
            var textureName = "cloud\(i)"
            var temp = loadingNormalRight.textureNamed(textureName)
            cloudAnimation5.append(temp)
        }
    }
    
   /* func loadAnimationIphone6Plus1() {
        var loadingLeftBlack = SKTextureAtlas(named: "DarkRainbowcloudleftIphone6Plus")
        
        for i in 1...16 {
            var textureName = "cloud\(i)"
            var temp = loadingLeftBlack.textureNamed(textureName)
            cloudLeftBlack.append(temp)
        }
    }
    func loadAnimationIphone6Plus2() {
        var loadingRightBlack = SKTextureAtlas(named: "DarkRainbowcloudrightIphone6Plus")
        
        for i in 1...16 {
            var textureName = "cloud\(i)"
            var temp = loadingRightBlack.textureNamed(textureName)
            cloudRightBlack.append(temp)
        }
    }
    func loadAnimationIphone6Plus3() {
        var loadingNormalLeft = SKTextureAtlas(named: "RainbowcloudleftIphone6Plus")
        
        for i in 1...16 {
            var textureName = "cloud\(i)"
            var temp = loadingNormalLeft.textureNamed(textureName)
            cloudLeftNormal.append(temp)
        }
    }
    func loadAnimationIphone6Plus4() {
        var loadingNormalRight = SKTextureAtlas(named: "RainbowcloudrightIphone6Plus")
        
        for i in 1...16 {
            var textureName = "cloud\(i)"
            var temp = loadingNormalRight.textureNamed(textureName)
            cloudRightNormal.append(temp)
        }
    }
    func loadAnimationIphone6Plus5() {
        var loadingNormalRight = SKTextureAtlas(named: "RainbowcloudrightIphone6Plus")
    
        for i in 1...16 {
            var textureName = "cloud\(i)"
            var temp = loadingNormalRight.textureNamed(textureName)
            cloudRightNormal.append(temp)
        }
    }
    
    */
    
    
    
    
    
    
    
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
        
        musicLoop.numberOfLoops = -1
        musicLoop.prepareToPlay()
        musicLoop.volume = 0.4
        musicLoop.play()
        
    }
    
    
    
    
    func arrowTimeUpdate() {
        arrowTimer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("updateArrowCounter"), userInfo: nil, repeats: true)
    }
    func updateArrowCounter() {
        arrowCounter++
        if arrowCounter == 10 {
            removingArrows()
        }
    }
   
    func removingArrows() {
        leftArrow.runAction(SKAction.fadeOutWithDuration(5))
        rightArrow.runAction(SKAction.fadeOutWithDuration(5))
    }
    
    
    
    
    
    
    
    
    
    
    func didBeginContact(contact:SKPhysicsContact){
        let node1:SKNode = contact.bodyA.node!
        let node2:SKNode = contact.bodyB.node!
        
        println("the \(contact.bodyA) is touching the \(contact.bodyB)")
    }
    
    
    
    
    
    
    
    
    /* Whenever the hero touches a dark rainbow this takes place*/
    func death() {
        let randomIndex = Int(arc4random_uniform(UInt32(adScreenTransition.count)))
        var defaults = NSUserDefaults()
        var otherDefaults = NSUserDefaults()
        var highscore = defaults.integerForKey("highscore")
        
        if (score > highscore){
            defaults.setInteger(score, forKey: "highscore")
        }
        
        otherDefaults.setInteger(adScreenTransition[randomIndex], forKey: "add")
        
        var highscoreshow = defaults.integerForKey("highscore")
        var addTransition = otherDefaults.integerForKey("add")
        
        var transitionFade = SKTransition.moveInWithDirection(SKTransitionDirection.Up, duration: 0.5)
        var scene = MainMenu(size: self.size)
        let skView = self.view as SKView!
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .ResizeFill
        scene.size = skView.bounds.size
        skView.presentScene(scene, transition: transitionFade)
    }
    
    
    
    
    
    
    func loadWaveMediumAnimation() {
        var runningLeftAtlas = SKTextureAtlas(named: "waveMedium")
        
        for i in 0...1 {
            var textureName = "waveMedium\(i)"
            var temp = runningLeftAtlas.textureNamed(textureName)
            waveTexturesMedium.append(temp)
        }
    }
    
    // This will start running the wave loop
     func runWaveMedium() {
        waveMedium1.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(waveTexturesMedium, timePerFrame: 1.00, resize: false, restore: true)), withKey: "runWave1")
        waveMedium1.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(waveTexturesMedium, timePerFrame: 1.00, resize: false, restore: true)), withKey: "runWave1")
    }
    
    
    
    /* Looping the animation of the hero*/
    func loadHeroTextures() {
        var runningLeftAtlas = SKTextureAtlas(named: "MovingLeft")
        
        for i in 1...9 {
            var textureName = "left_\(i)"
            var temp = runningLeftAtlas.textureNamed(textureName)
            runningHeroTextures.append(temp)
        }
    }
    func loadHeroTexturesIphone6P() {
        var runningLeftAtlas = SKTextureAtlas(named: "MovingLeftOnIphone6Plus")
        
        for i in 1...9 {
            var textureName = "walkleft_\(i)"
            var temp = runningLeftAtlas.textureNamed(textureName)
            runningHeroTexturesIphone6Plus.append(temp)
        }
    }
    // This will start running the run loop
    func runHero() {
        hero.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(runningHeroTextures, timePerFrame: 0.099, resize: false, restore: true)), withKey: "runHero")
    }
    func runHeroIphone6P() {
        hero.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(runningHeroTexturesIphone6Plus, timePerFrame: 0.099, resize: false, restore: true)), withKey: "runHeroIphone6P")
    }
    
    
    func loadHeroDeath() {
        var runningLeftAtlas = SKTextureAtlas(named: "DeathAnimation")
        for i in 0...24 {
            var textureName = "death\(i)"
            var temp = runningLeftAtlas.textureNamed(textureName)
            deathAnimationTextures.append(temp)
        }
    }
    // This will start running the run loop
    func runDeath() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("updateCounter"), userInfo: nil, repeats: true)
        hero.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(deathAnimationTextures, timePerFrame: 0.093, resize: false, restore: false)), withKey: "runHeroDeath")
    }
    /* Updates the counter*/
    func updateCounter() {
        counter++
        if counter == 3 {
            death()
            musicLoop.stop()
        }
    }
    
    
    
    
    
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /* this loads the hero movement-animations*/
    func loadHeroMovement() {
        hero.position.y -= hero.size.height / 2
        hero.position.x = -(scene!.size.width / 2)  + hero.size.width * 2
    }
    
    
    /* The function that makes the hero move into a certain direction*/
    func moveHero(direction: String) {
        if direction == "right" {
            heroMovingLeft = false
            hero.xScale = -1
            heroMovingRight = true
        } else {
            heroMovingRight = false
            hero.xScale = 1
            heroMovingLeft = true
        }
    }
    
    
    
    func generateDelay() -> Int{
        
        var value = 0
        let randomIndex = Int(arc4random_uniform(UInt32(rainbowDelays.count)))
        value = rainbowDelays[randomIndex]
        
        return value
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches {
            if gameOver == false {
                if heroSpeed == 0.0 {
                    heroSpeed = 1.2
                }
    
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
    
                heroSpeed = -1 * heroSpeed
                hero.xScale = -1 * hero.xScale
            }
            if gameOver == true {
                cancelHeroMoves()
            }


    
    
        }
    }
    
    
    
    
    
    
    
   
    
    func cancelHeroMoves() {
        heroSpeed = 0
        //hero.removeAllActions()
    }
    
    func updateDirection() {
        
        
        if hero.position.x <= frameMaxLeft {
            heroSpeed = -1.5
            hero.xScale = -1
        }
        
        if hero.position.x >= frameMaxRight {
            heroSpeed = +1.5
            hero.xScale = 1
        }
    }
    

    
    func playRainbowHitSounds() {
        randomIndexRainbowHit = Int(arc4random_uniform(UInt32(rainbowHitSounds.count)))
        currentSound = rainbowHitSounds[randomIndexRainbowHit]
        runAction(currentSound as! SKAction)
    }
    
    
    override func didEvaluateActions()  {
        checkCollisions()
    }
    
    
    func checkCollisions(){
        let timeInterval:NSTimeInterval = 0.35
        var blackHitRainbows: [SKSpriteNode] = []
        var heroContact = self.hero.frame
        enumerateChildNodesWithName(RainbowsType.Black.rawValue) { node, _ in
            let rainbow = node as! SKSpriteNode
            if CGRectIntersectsRect(rainbow.frame, heroContact) && rainbow.alpha >= 1 {
                blackHitRainbows.append(rainbow)
            }
        }
        for rainbow in blackHitRainbows {
            
            /* Do whatever you want with every single collision*/
            rainbow.removeFromParent()
            musicLoop.volume = 0.15
            if ifDeathIsTrue == false {
                runDeath()
                runAction(deathSound)
            }
            ifDeathIsTrue = true
            gameOver = true
            
            
        }
        
        
        var normalHitRainbows: [SKSpriteNode] = []
        enumerateChildNodesWithName(RainbowsType.Normal.rawValue) { node, _ in
            let rainbow = node as! SKSpriteNode
            if CGRectIntersectsRect(rainbow.frame, self.hero.frame) {
                normalHitRainbows.append(rainbow)
            }
        }
        for rainbow in normalHitRainbows {
            
            /* Do whatever you want with every single collision*/
            if gameOver == false {
            self.score += 10
            playRainbowHitSounds()
            }
            rainbow.removeFromParent()
        }
        // println("---- blackHitRainbows \(blackHitRainbows)")
        // println("---- normalHitRainbows \(normalHitRainbows)")
    }
    
    
    func isBlackNeeded()->Bool{
        
        var count = 0, value = true
        
        for rainbow:Rainbow in rainbows{
            
            if rainbow.isBlack{
                
                count++;
            }
        }
        
        if count > 4/*4*/ {
            
            value = false
            
        }
        
        return value
    }
    
    
    
    var rainbows:[Rainbow] = []
    enum Rainbows: Int { // Data about the rainbow generation
        
        case Max = 7
        case Distance = 12
        case Speed = 2
        case topDistance = 10
        
    }
    
    var currentDelay:Int?
    
    enum RainbowsType:String{
        
        case Black = "Blackrainbow"
        case Normal = "Rainbow"
    }
    
    
    
    
    func generateRainbows(){
        
        // Generate a new Rainbow
        if rainbows.count < Rainbows.Max.rawValue && delayer >= currentDelay{
            
            var positionX: CGFloat
            var current:Rainbow
            var texture = rainbowTextures
            var spriteName:String
            
            if isBlackNeeded(){
                
                texture = SKTexture(imageNamed: "Blackrainbow")
                if DeviceType.IS_IPHONE_6 {
                    texture = SKTexture(imageNamed: "BlackrainbowIphone6Plus")
                }
                spriteName = RainbowsType.Black.rawValue
                
                
            }else{
                
                texture = SKTexture(imageNamed: "Rainbow")
                if DeviceType.IS_IPHONE_6 {
                    texture = SKTexture(imageNamed: "RainbowIphone6Plus")
                }
                spriteName = RainbowsType.Normal.rawValue
                
            }
            
            let distance = CGFloat(Rainbows.Distance.rawValue)
            let width = self.frame.size.width
            let randomSlot:Slot? = generateRandomRainbowPosition()
            
            if let slot = randomSlot {
                
                
                
                if rainbows.count == 0 {
                    
                    positionX = CGFloat(slot.x)
                    current = Rainbow(position: CGPoint(x: positionX, y: texture.size().height + (frame.height / 2)), texture: texture, index: rainbows.count)
                    
                    rainbows.insert(current, atIndex: 0)
                   
                    
                }else{
                    
                    let lastRainbow:Rainbow = rainbows.first!
                    var min = lastRainbow.position.x + distance
                    var max = width - distance
                    
                    if(min > max || (min + distance > max)){
                        
                        min  = CGFloat.random(min: -width/2, max: lastRainbow.position.x)
                        
                    }
                    
                    positionX = CGFloat(slot.x)// CGFloat.random(min: min, max: max)
                    current = Rainbow(position: CGPoint(x: positionX, y:  texture.size().height + (frame.height / 2)), texture: texture, index: rainbows.count)
                    
                    rainbows.insert(current, atIndex: 0)
                }
                
                delayer = 0
                currentDelay = generateDelay()
                
                current.name = spriteName
                current.slot = slot
                
                addChild(current)
            }
            
        }
        
        delayer++
        
    }
    
    
    func generateRandomRainbowPosition() -> Slot?{
        
        var value:Slot?
        var freeSlots:[Slot] = []
        
        for i in 0..<availableSlots.count{
            
            let slot = availableSlots[i]
            
            if slot.used == false{
                
                freeSlots.append(slot)
                
            }
            
        }
        
        var current:[Bool] = [];
        for p in availableSlots{
            current.append(p.used)
        }
        
        println("the status of the FR is \(current)")
        
        if freeSlots.count > 0 {
            
            var random = Int(arc4random_uniform(UInt32(freeSlots.count)))
            freeSlots[random].used = true
            
            var slotters:[Float] = []
            for s in freeSlots{
                slotters.append(s.x)
            }
            println("\n the available positions are \(slotters) \n the random index is \(random)\n and the value is \(freeSlots[random].x) \n")
            
            value = freeSlots[random]
            
        }
        
        return value
        
    }
    
    func moveAndCheckRainbows(){
        
        var abs:CGFloat, found: Int?
        let timeInterval:NSTimeInterval = 0.35
        
        for rainbow:Rainbow in rainbows{
            
            if !rainbow.colliding{
                
                rainbow.position.y -= CGFloat(Rainbows.Speed.rawValue)
                abs = rainbow.position.y
                
                rainbow.update()
                
                // TODO instead of an hardcoded value calculate the Y of the floor
                if abs < hero.position.y {
                    
                    rainbow.fadeOut(timeInterval)
                    rainbow.colliding = true
                    if let index = find(availableSlots, rainbow.slot) {
                        
                        if availableSlots[index].used {
                            println("I am searching for \(index)")
                            availableSlots[index].used = false
                            
                        }
                        
                        if let rainbowIndex = find(rainbows, rainbow){
                            rainbows.removeAtIndex(rainbowIndex)
                        }
                        
                        break
                    }
                    
                }
                
            }
        }
    }
    
    
    
    
    
    
    
    override func update(currentTime: NSTimeInterval) {
        updateDirection()
        hero.position.x -= heroSpeed
        
        
        self.scoreText.text = String(self.score)
        
        if  self.floor.position.x == maxBarX {
            
            self.floor.position.x = self.origRunningFloorPositionXPoint
        }
        
        
        if gameOver == true {
            hero.position = hero.position
            heroSpeed = 0
        }
        
        
        
        
        generateRainbows()
        moveAndCheckRainbows()
    }
    
}
