//
//  MainMenu.swift
//  CompletedRainbowRun
//
//  Created by Alexander Saleh on 5/20/15.
//  Copyright (c) 2015 Moonwalk Studios. All rights reserved.
//

import Foundation

import SpriteKit
import UIKit
import Foundation
import AudioToolbox
import AVFoundation
import GameKit
import GoogleMobileAds




class MainMenu: SKScene {
    
    var floor: SKSpriteNode // The floor image that is placed infront of the background
    var background: SKSpriteNode
    var startButton: SKSpriteNode
    var startButtonTextures = [SKTexture]()
    var helpButton: SKSpriteNode
    var helpButtonTextures = [SKTexture]()
    var helpButtonTexturesIphone6Plus = [SKTexture]()
    var startButtonTexturesIphone6Plus = [SKTexture]()
    var highscoreButtonTexturesIphone6Plus = [SKTexture]()
    
    var highscoreButton: SKSpriteNode
    var highscoreButtonTextures = [SKTexture]()
    
    let playButtonSound = SKAction.playSoundFileNamed("RainbowRunButton.caf", waitForCompletion: false)
    let transitionSound = SKAction.playSoundFileNamed("gameStart.caf", waitForCompletion: false)
    
    let transitionFade = SKTransition.fadeWithDuration(1.3)
    let transitionDoors = SKTransition.doorsCloseVerticalWithDuration(1.3)
    var musicLoop: AVAudioPlayer!
    
    let highscoreText = SKLabelNode(fontNamed: "Menlo Bold")
    var highscoreshow = NSUserDefaults().integerForKey("highscore")
    var highscoreBox : SKSpriteNode
    var addTransition = NSUserDefaults().integerForKey("add")
    
    var interstitialAd: GADInterstitial!
    
    
    override init(size: CGSize) {
        self.highscoreBox = SKSpriteNode(imageNamed: "HighscoreBox")
        self.highscoreButton = SKSpriteNode(texture: SKTexture(imageNamed: "highscoreButt0"))
        self.background = SKSpriteNode(imageNamed: "background")
        self.floor = SKSpriteNode(imageNamed: "floor")
        self.startButton = SKSpriteNode(texture: SKTexture(imageNamed: "StartButton0"))
        self.helpButton = SKSpriteNode(texture: SKTexture(imageNamed: "helpButton"))
        
        if DeviceType.IS_IPHONE_6 {
            self.highscoreButton = SKSpriteNode(texture: SKTexture(imageNamed: "highscoreButton"))
            self.startButton = SKSpriteNode(texture: SKTexture(imageNamed: "StartButt0"))
            self.helpButton = SKSpriteNode(texture: SKTexture(imageNamed: "helpButt0"))
            self.floor.size.width = self.floor.size.width * 1.172
            self.floor.size.height = self.floor.size.height * 1.174
            self.background.size.width = background.size.width * 1.172
            self.background.size.height = background.size.height * 1.174
            self.highscoreButton.size.width = highscoreButton.size.width * 1.172
            self.highscoreButton.size.height = highscoreButton.size.height * 1.174
            self.startButton.size.width = startButton.size.width * 1.172
            self.startButton.size.height = startButton.size.height * 1.174
            self.helpButton.size.width = helpButton.size.width * 1.172
            self.helpButton.size.height = helpButton.size.height * 1.174
            self.highscoreBox.size.width = highscoreBox.size.width * 1.172
            self.highscoreBox.size.height = highscoreBox.size.height * 1.174
            self.highscoreText.fontSize = self.highscoreText.fontSize * 1.173
        }
        if DeviceType.IS_IPHONE_5 {
            self.highscoreButton = SKSpriteNode(texture: SKTexture(imageNamed: "highscoreButton"))
            self.startButton = SKSpriteNode(texture: SKTexture(imageNamed: "StartButton0"))
            self.helpButton = SKSpriteNode(texture: SKTexture(imageNamed: "helpButton"))
        }
        if DeviceType.IS_IPHONE_6P {
         self.highscoreButton = SKSpriteNode(texture: SKTexture(imageNamed: "highscoreButt0"))
            self.highscoreButton.size.width = self.highscoreButton.size.width / 3
            self.highscoreButton.size.height = self.highscoreButton.size.height / 3
            self.startButton = SKSpriteNode(texture: SKTexture(imageNamed: "StartButt0"))
            self.startButton.size.width = self.startButton.size.width / 3
            self.startButton.size.height = self.startButton.size.height / 3
            self.helpButton = SKSpriteNode(texture: SKTexture(imageNamed: "helpButt0"))
            self.helpButton.size.width = self.helpButton.size.width / 3
            self.helpButton.size.height = self.helpButton.size.height / 3
            
        }
        if DeviceType.IS_IPAD {
            self.highscoreButton = SKSpriteNode(texture: SKTexture(imageNamed: "highscoreButton"))
            self.startButton = SKSpriteNode(texture: SKTexture(imageNamed: "StartButton0"))
            self.helpButton = SKSpriteNode(texture: SKTexture(imageNamed: "helpButton"))
        }

        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here*/
        
        NSUserDefaults().setInteger(highscoreshow, forKey: "highscore")
        NSUserDefaults().setInteger(addTransition, forKey: "add")

        
        
        
        
       /*if addTransition == 6 {
           println("SWEEEEEEEET")
            if(self.interstitial.isReady) {
                self.interstitial.presentFromRootViewController(GameViewController())
                self.interstitial = self.createAndLoadAd()
            }
            
            /////////////////////////
            ////////////////////////
        }*/

        playMusicLoop("menu.caf")
        
        loadTexturePacks()
        self.background.size.width = self.frame.size.width
        self.background.size.height = self.frame.size.height
        self.background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.addChild(self.background)
        
        self.floor.anchorPoint = CGPointMake(0, 0.5) // Placing the anchorpoint for the floor image
        self.floor.position = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame) + (self.floor.size.height / 2)) // positioning the floor
        self.addChild(self.floor) // This adds the floor to the view
        
        
        //loadStartButtonTextures()
        self.startButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + helpButton.size.height / 11.0)
        self.addChild(self.startButton)
        
        //loadHelpButtonTextures()
        self.helpButton.position = CGPointMake(CGRectGetMidX(self.frame) + (CGRectGetMidX(self.frame) / 2), CGRectGetMidY(self.frame) - (CGRectGetMidY(self.frame) / 1.545))
        self.addChild(self.helpButton)
        
        //loadHighscoreButtonTextures()
        self.highscoreButton.position = CGPointMake(CGRectGetMidX(self.frame) - (CGRectGetMidX(self.frame) / 2),CGRectGetMidY(self.frame) - (CGRectGetMidY(self.frame) / 1.545))
        self.addChild(self.highscoreButton)
        
        self.highscoreBox.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - helpButton.size.height / 0.55)
        self.addChild(self.highscoreBox)
        
        self.highscoreBox.size.height = self.highscoreBox.size.height / 1.95
        self.highscoreBox.size.width = self.highscoreBox.size.width / 1.85
        self.highscoreText.fontColor = UIColor.yellowColor()
        
        self.highscoreText.text = "\(highscoreshow)"
        self.highscoreText.fontSize = 25
        
        if DeviceType.IS_IPAD {
            self.highscoreText.fontSize = 55
        }
        self.highscoreText.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - helpButton.size.height / 0.485)
        self.addChild(self.highscoreText)
        
    }
    
    
    
    func playMusicLoop(filename: String) {
        let url = NSBundle.mainBundle().URLForResource(filename, withExtension: nil)
        if(url == nil) {
            print("could not find file: \(filename)")
            return
        }
        var error: NSError? = nil
        do {
            musicLoop = try AVAudioPlayer(contentsOfURL: url!)
        } catch let error1 as NSError {
            error = error1
            musicLoop = nil
        }
        if musicLoop == nil {
            print("Could not create audio player: \(error!)")
            return
        }
        
        musicLoop.numberOfLoops = -1
        musicLoop.prepareToPlay()
        musicLoop.volume = 0.4
        musicLoop.play()
        
    }
    
    
    func loadTexturePacks() {
        
        if DeviceType.IS_IPHONE_6 {
            loadStartButtonTextures()
            loadHighscoreButtonTextures()
            loadHelpButtonTextures()
        }
        if DeviceType.IS_IPHONE_5 {
            loadStartButtonTextures()
            loadHighscoreButtonTextures()
            loadHelpButtonTextures()
        }
        if DeviceType.IS_IPAD {
            loadStartButtonTextures()
            loadHighscoreButtonTextures()
            loadHelpButtonTextures()
        }
        if DeviceType.IS_IPHONE_6P {
            loadHelpButtonTexturesIphone6Plus()
            loadStartButtonTexturesIphone6Plus()
            loadHighscoreButtonTexturesIphone6Plus()
        }
    }
    
    
    
    func loadHelpButtonTextures() {
        let buttonAtlas = SKTextureAtlas(named: "HelpButtonAnimation")
        
        for i in 1...1 {
            let textureName = "helpButton\(i)"
            let temp = buttonAtlas.textureNamed(textureName)
            helpButtonTextures.append(temp)
        }
    }
    func loadHelpButtonTexturesIphone6Plus() {
        let buttonAtlas = SKTextureAtlas(named: "HelpButtonAnimationIphone6Plus")                                         
        
        for i in 1...1 {
            let textureName = "helpButt\(i)"
            let temp = buttonAtlas.textureNamed(textureName)
            helpButtonTexturesIphone6Plus.append(temp)
        }
    }
    
    func helpAnimation() {
        helpButton.runAction(SKAction.animateWithTextures(helpButtonTextures, timePerFrame: 0.7, resize: false, restore: true), withKey: "Help")
    }
    func helpAnimationIphone6Plus() {
        helpButton.runAction(SKAction.animateWithTextures(helpButtonTexturesIphone6Plus, timePerFrame: 0.7, resize: false, restore: true), withKey: "Help")
    }
    
    
    
    
    func loadHighscoreButtonTextures() {
        let buttonAtlas = SKTextureAtlas(named: "HighscoreButtonAnimation")
        
        for i in 1...1 {
            let textureName = "highscoreButton\(i)"
            let temp = buttonAtlas.textureNamed(textureName)
            highscoreButtonTextures.append(temp)
        }
    }
    func loadHighscoreButtonTexturesIphone6Plus() {
        let buttonAtlas = SKTextureAtlas(named: "HighscoreButtonAnimationIphone6Plus")
        
        for i in 1...1 {
            let textureName = "highscoreButt\(i)"
            let temp = buttonAtlas.textureNamed(textureName)
            highscoreButtonTexturesIphone6Plus.append(temp)
        }
    }
    
    func highscoreAnimation() {
        highscoreButton.runAction(SKAction.animateWithTextures(highscoreButtonTextures, timePerFrame: 0.7, resize: false, restore: true), withKey: "Highscore")
    }
    func highscoreAnimationIphone6Plus() {
        highscoreButton.runAction(SKAction.animateWithTextures(highscoreButtonTexturesIphone6Plus, timePerFrame: 0.7, resize: false, restore: true), withKey: "HighscoreIphone6Plus")
    }
    
    
    
    
    
    func loadStartButtonTextures() {
        let buttonAtlas = SKTextureAtlas(named: "StartbuttonAnimation")
        
        for i in 1...1 {
            let textureName = "StartButton\(i)"
            let temp = buttonAtlas.textureNamed(textureName)
            startButtonTextures.append(temp)
        }
    }
    func loadStartButtonTexturesIphone6Plus() {
        let buttonAtlas = SKTextureAtlas(named: "StartbuttonAnimationIphone6Plus")
        
        for i in 1...1 {
            let textureName = "StartButt\(i)"
            let temp = buttonAtlas.textureNamed(textureName)
            startButtonTexturesIphone6Plus.append(temp)
        }
    }
    
    func startAnimation() {
        startButton.runAction(SKAction.animateWithTextures(startButtonTextures, timePerFrame: 0.7, resize: false, restore: true), withKey: "Start")
    }
    func startAnimationIphone6Plus() {
        startButton.runAction(SKAction.animateWithTextures(startButtonTexturesIphone6Plus, timePerFrame: 0.7, resize: false, restore: true), withKey: "Start")
    }
    
    
    
    //send high score to leaderboard
    func saveHighscore(score:Int) {
        
        //check if user is signed in
        if GKLocalPlayer.localPlayer().authenticated {
            
            let scoreReporter = GKScore(leaderboardIdentifier: "MoonWalkStudios1Leaderboard") //leaderboard id here
            
            scoreReporter.value = Int64(highscoreshow) //score variable here (same as above)
            
            let scoreArray: [GKScore] = [scoreReporter]
            
            GKScore.reportScores(scoreArray, withCompletionHandler: {(error : NSError?) -> Void in
                if error != nil {
                    print("error")
                }
            })
            
        }
    }
    
    
   
    func createAndLoadAd() -> GADInterstitial {
        interstitialAd = GADInterstitial(adUnitID: "ca-app-pub-3703288349171008/9065448778")
        
        let request = GADRequest()
        
        request.testDevices = [kGADSimulatorID]
        interstitialAd!.loadRequest(request)
        return interstitialAd!
    }
    
   
    
   

    
    
    
    
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.startButton {
                if DeviceType.IS_IPHONE_6 {
                    startAnimation()
                }
                if DeviceType.IS_IPHONE_5 {
                    startAnimation()
                }
                if DeviceType.IS_IPAD {
                  startAnimation()
                }
                if DeviceType.IS_IPHONE_6P {
                    startAnimationIphone6Plus()
                }
                runAction(playButtonSound)
            }
            if self.nodeAtPoint(location) == self.highscoreButton {
                if DeviceType.IS_IPHONE_6 {
                 highscoreAnimation()
                }
                if DeviceType.IS_IPHONE_5 {
                    highscoreAnimation()
                }
                if DeviceType.IS_IPAD {
                    highscoreAnimation()
                }
                if DeviceType.IS_IPHONE_6P {
                    highscoreAnimationIphone6Plus()
                }
                runAction(playButtonSound)
                
            } else {
                if self.nodeAtPoint(location) == self.helpButton {
                    if DeviceType.IS_IPHONE_6 {
                     helpAnimation()
                    }
                    if DeviceType.IS_IPHONE_5 {
                        helpAnimation()
                    }
                    if DeviceType.IS_IPAD {
                        helpAnimation()
                    }
                    if DeviceType.IS_IPHONE_6P {
                      helpAnimationIphone6Plus()
                    }
                    runAction(playButtonSound)
                }
            }
        }
    }
    
    override func  touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.highscoreButton {
                
                saveHighscore(highscoreshow)
                GameViewController().showLeader()
            }
            if self.nodeAtPoint(location) == self.startButton {
                musicLoop.stop()
                runAction(transitionSound)
                let scene = InGameScene(size: self.size)
                let skView = self.view as SKView!
                skView.ignoresSiblingOrder = true
                scene.scaleMode = .AspectFill
                scene.size = skView.bounds.size
                scene.anchorPoint = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
                skView.presentScene(scene, transition: transitionFade)
                
               
            } else {
                if self.nodeAtPoint(location) == self.helpButton {
                    let scene = HelpScene(size: self.size)
                    //musicLoop.stop()
                    let skView = self.view as SKView!
                    skView.ignoresSiblingOrder = true
                    scene.scaleMode = .AspectFill
                    scene.size = skView.bounds.size
                    scene.anchorPoint = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
                    skView.presentScene(scene, transition: transitionDoors)
                    
                }
                
            }
            
        }
        
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        
        
    }
    
}



    