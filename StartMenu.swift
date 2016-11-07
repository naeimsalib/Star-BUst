//
//  StartMenu.swift
//  StarBust_
//
//  Created by naeim on 10/27/16.
//  Copyright © 2016 naeim. All rights reserved.
//

import  SpriteKit
import GameplayKit
import UIKit
import AVFoundation
import GameKit
import GoogleMobileAds



struct Variables {
    
    
    
    static let userDefaults = UserDefaults.standard
    static let kCoinsKey = "Coins"
    
    static var CoinsCollected: Int {
        get {
            return userDefaults.integer(forKey: self.kCoinsKey)
        }
        
        set(value) {
            userDefaults.setValue(value, forKey: self.kCoinsKey)
        }
    }
    
    
    static let KHighScore = "HighScore"
    
    static var HighScore: Int {
        get {
            return userDefaults.integer(forKey: self.KHighScore)
        }
        
        set(value) {
            userDefaults.setValue(value, forKey: self.KHighScore)
        }
    }
    
    
}



class StartMenu: SKScene, GKGameCenterControllerDelegate,GADInterstitialDelegate {
    

   
     var viewController: GameViewController!
    
    var interstitial : GADInterstitial!
    
    var PlayGameButton:SKSpriteNode!
    var storeButton:SKSpriteNode!
    var imagelogo:SKSpriteNode!
    
    let defaults = UserDefaults.standard
    
    var starfield:SKEmitterNode!
    
    var middleLign:SKSpriteNode!
    var TitleLabel :SKLabelNode!
    var howToPlay : SKLabelNode!
    
    var touchlocation : CGPoint!
    
    var coinsCollectedLabel : SKLabelNode!
    
    var HighScore : SKLabelNode!
    
    var gameCenterLogo: SKSpriteNode!
    
    var extraCoinsButton : SKSpriteNode!

     var admobDelegate = AdMobDelegate()


    
       override func didMove(to view: SKView) {
        

        
      
        //call the function to add how to play.
        
        authPlayer()

        
        
        let scene = GameScene(size: view.bounds.size)
       scene.size = view.bounds.size
       
        
        
       
        
        
        //add the play button
        PlayGameButton = SKSpriteNode(imageNamed: "play")
        PlayGameButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        PlayGameButton.size.width = PlayGameButton.size.width / 2 + 10
        PlayGameButton.size.height = PlayGameButton.size.height / 2 + 10
        PlayGameButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.addChild(PlayGameButton)
        
        // add a label to hold the High Score that the user Did
        HighScore = SKLabelNode(text: "High Score: \(Variables.HighScore)")
        HighScore.zPosition = 2
        HighScore.position = CGPoint(x: self.frame.minX + PlayGameButton.size.width / 1.5, y: self.frame.size.height - (self.frame.size.height / 9))
        HighScore.fontName = "Snickles"
        HighScore.fontSize = 25
        HighScore.fontColor = UIColor.yellow
        self.addChild(HighScore)
        
        // add a label to hold the coins that the user collects
        coinsCollectedLabel = SKLabelNode(text: "coins: \(Variables.CoinsCollected)")
        coinsCollectedLabel.zPosition = 2
        coinsCollectedLabel.position = CGPoint(x: self.frame.minX + PlayGameButton.size.width / 2, y: self.frame.size.height - (self.frame.size.height / 12))
        coinsCollectedLabel.fontName = "Snickles"
        coinsCollectedLabel.fontSize = 25
        coinsCollectedLabel.fontColor = UIColor.yellow
        self.addChild(coinsCollectedLabel)
        
        //add the store button
        storeButton = SKSpriteNode(imageNamed: "store")
        storeButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - (PlayGameButton.size.height))
        storeButton.size.width = storeButton.size.width / 2
        storeButton.size.height = storeButton.size.height / 2
        self.addChild(storeButton)
        
        //adding the label
        TitleLabel = SKLabelNode(text: "Star Bust!")
        TitleLabel.zPosition = 2
        TitleLabel.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height - (self.frame.size.height / 4))
        TitleLabel.fontName = "Snickles"
        TitleLabel.fontSize = 50
        TitleLabel.fontColor = UIColor.white
        
        self.addChild(TitleLabel)
        
        
        //adding the logo next to the label
        imagelogo = SKSpriteNode(imageNamed: "ball")
        imagelogo.position = CGPoint(x:TitleLabel.position.x + (imagelogo.size.width * 1.2), y: TitleLabel.position.y + (imagelogo.size.height))
        imagelogo.size.width = imagelogo.size.width
        imagelogo.size.height = imagelogo.size.height
        self.addChild(imagelogo)
        
        //adding the game Center logo
        gameCenterLogo = SKSpriteNode(imageNamed: "GameCenter")
        gameCenterLogo.position = CGPoint(x: self.frame.midX, y: self.storeButton.position.y - (self.gameCenterLogo.size.height / 1.2))
        gameCenterLogo.zPosition = 5
        gameCenterLogo.size.height = gameCenterLogo.size.height / 2
        gameCenterLogo.size.width = gameCenterLogo.size.width / 2
        self.addChild(gameCenterLogo)
        
        
        addHowToPlayTheGame()
        
        starfield = SKEmitterNode(fileNamed: "Starfield")
        starfield.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height)
        starfield.particleSize = CGSize(width: starfield.particleSize.width / 2, height: starfield.particleSize.height / 2)
        starfield.advanceSimulationTime(10)
        self.addChild(starfield)
        starfield.zPosition = -1
        
        //add the extra coins button
        extraCoinsButton = SKSpriteNode(imageNamed: "play")
        extraCoinsButton.position = CGPoint(x: self.frame.width / 5, y: self.frame.height / 2)
        extraCoinsButton.size.width = extraCoinsButton.size.width / 2 + 10
        extraCoinsButton.size.height = extraCoinsButton.size.height / 2 + 10
        self.addChild(extraCoinsButton)
        
        
        
        

    }
    
    func addHowToPlayTheGame(){
        
      
        howToPlay = SKLabelNode(text: "How To Play")
        howToPlay.position = CGPoint(x: self.frame.midX, y: self.storeButton.position.y - (self.storeButton.size.height ))
        howToPlay.zPosition = 3
        howToPlay.fontSize = 25
        howToPlay.fontName = "Snickles"
        
        self.addChild(howToPlay)
        
    }

    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        let touch = touches.first!
        if PlayGameButton.contains(touch.location(in: self)) {
            

            
            if let view = self.view {
                // Load the SKScene from 'StartMenu.sks'
                if let scene = GameScene(fileNamed: "GameScene") {
                    
                   
                   
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view.presentScene(scene)
                }
                
            }
        }

        if extraCoinsButton.contains(touch.location(in: self)) {
            
           
       
            
            
        }
        

        
        if howToPlay.contains(touch.location(in: self)) {
            if let view = self.view {
                // Load the SKScene from 'StartMenu.sks'
                if let scene = HowToPlayScene(fileNamed: "HowToPlayScene") {
                    
                    
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view.presentScene(scene)
                }
                
            }
            
        }
        
        if storeButton.contains(touch.location(in: self)) {
            if let view = self.view {
                // Load the SKScene from 'StartMenu.sks'
                if let scene = StoreScene(fileNamed: "StoreScene") {

                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view.presentScene(scene)
                    
                }
                
            }
            
        }
        
        if gameCenterLogo.contains(touch.location(in: self)) {
            
            saveHighScore(number: Variables.HighScore)
            authPlayer()
            showLeaderBoard()
            
            
        }

    }
    
    func authPlayer(){
        
        let localPlayer = GKLocalPlayer.localPlayer()
        
        
            localPlayer.authenticateHandler = {
                (view,error) in
                
                if view != nil{
                    self.view?.window?.rootViewController?.present(view!, animated: true, completion: nil)
                    
                }else{
                    print(GKLocalPlayer.localPlayer().isAuthenticated)
                }
            }
        }
    
    func saveHighScore(number:Int){
        if GKLocalPlayer.localPlayer().isAuthenticated{
            let scoreReporter = GKScore(leaderboardIdentifier: "GameCenterIdentifier")
            scoreReporter.value = Int64(number)
            
            let scoreArray : [GKScore] = [scoreReporter]
            
            GKScore.report(scoreArray, withCompletionHandler: nil)
        }
    }
    
    func showLeaderBoard(){
    let ViewController = self.view?.window?.rootViewController
        let gcvc = GKGameCenterViewController()
        gcvc.gameCenterDelegate = self
        ViewController?.present(gcvc, animated: true, completion: nil)
    
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        PlayGameButton.zRotation += 0.05
    }
    
    

    
    
}
