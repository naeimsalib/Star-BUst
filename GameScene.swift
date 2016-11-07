//
//  GameScene.swift
//  StarBust_
//
//  Created by naeim on 10/27/16.
//  Copyright © 2016 naeim. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit
import AVFoundation

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let objectCategory  : UInt32 = 0b1       // 1
    static let characterCategory: UInt32 = 0b10      // 2
    static let CoinsCategory: UInt32 = 0b11 //3
    static let WallCategory:UInt32 = 0b100 //4
}




class GameScene: SKScene,SKPhysicsContactDelegate {
    

    
    
    
    var starfield:SKEmitterNode!
    var player:SKSpriteNode!
    
    var CoinObject = SKSpriteNode()
    
    var scoreLabel :SKLabelNode!
    var score:Int = 0{
        didSet{
            scoreLabel.text = " \(score)"
        }
    }
    
    var countdownLabel:SKLabelNode!
    var countdownTime = 4


    var animationDuration:TimeInterval = 5
    var animationDurationForCoins:TimeInterval = 4.5
    
    var gamePlay:Bool = true
    
    var gameplay2:Bool = false //to stop the score count
  
    
    var isPlayerDead = false

  var checkIfScored = true
    
    var coins: Int = 0
    
    var audioPlayer = AVAudioPlayer()
    
    
    
    var middleLign:SKSpriteNode!
    
    var impulseDirection = 40
    
    var possibleObjects = ["Object1","Object2","Object3"]
    var coinsXPossition = [70,100,150,200,250,300,450,500,600,700]
    
    
    
    var gameTimer_FirstHalf:Timer!
    var gameTimer_SecondHalf:Timer!
    var gameTimer_Coins:Timer!

    
    var countdownTimer = Timer()
    
    var PlayerBoughtOneLife:Bool = false
    
    var anotherChanceIsCalled:Bool = false

    var anotherChanceNode:SKSpriteNode!
    
    var anotherChanceTime:Bool = false
    
    var countDownDone:Bool = false
    
    
    
    override func didMove(to view: SKView) {
        
        
        self.physicsWorld.contactDelegate = self
        
        CreatStarField()
        addBackGroundMusic()
        addCharacter()
        player.physicsBody?.affectedByGravity = false
        
        CreateScoreLabel()
        DrawMiddleLine()

        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameScene.callFunctionCreateCountDownLabel), userInfo: nil, repeats: true)
        
    }
    
    func callFunctionCreateCountDownLabel(){
        
        countdownTime -= 1
        if (countdownTime == 0)
        {
            countDownDone = true
             self.countdownLabel.removeFromParent()
        }else{
            
        CreateCountDownLabel(CountDownINT: countdownTime)
            
            self.run(SKAction.wait(forDuration: 0.9)) {
                self.countdownLabel.removeFromParent()
            }

        }
        
    }
    
    func CreateCountDownLabel(CountDownINT:Int){

            print(CountDownINT)
            countdownLabel = SKLabelNode(text: "\(CountDownINT)")
            countdownLabel.zPosition = 8
            countdownLabel.position = CGPoint(x: self.frame.size.width / 2 - (self.player.size.width), y: self.frame.size.height / 2)
            countdownLabel.fontName = "Snickles"
            countdownLabel.fontSize = 150
            countdownLabel.fontColor = UIColor.yellow
            
            self.addChild(countdownLabel)
        


        
    }
    
    func callAllFunctions(){
         player.physicsBody?.affectedByGravity = true
        countDownDone = false
        allTimers()
        
    }

    
    func allTimers(){
        gameTimer_FirstHalf = Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(addAlienFirstHalf), userInfo: nil, repeats: true)
        gameTimer_SecondHalf = Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(addAlienSecondHalf), userInfo: nil, repeats: true)
        
        gameTimer_Coins = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(addcoins), userInfo: nil, repeats: true)
        gameplay2 = true
    }
    

    
    
    func addCharacter(){
        
        anotherChanceIsCalled = false
        player = SKSpriteNode(imageNamed: "ball")
        player.position = CGPoint(x: self.frame.midX - (player.size.width), y: player.size.height * 3)
        player.physicsBody = SKPhysicsBody(texture: player.texture!,size: player.texture!.size())
        player.physicsBody?.isDynamic = true
        player.physicsBody?.affectedByGravity = true
        player.physicsBody?.categoryBitMask = PhysicsCategory.characterCategory
        player.physicsBody?.contactTestBitMask = PhysicsCategory.objectCategory | PhysicsCategory.CoinsCategory
        player.physicsBody?.collisionBitMask = PhysicsCategory.None
        player.physicsBody?.usesPreciseCollisionDetection = true
        self.addChild(player)
       
        
    }
    
    func addBackGroundMusic(){
        do{
            
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "jump", ofType: "wav")!))
            audioPlayer.prepareToPlay()
            
        }
        catch{
            print(error)
        }
        
    }
    


    
    
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if (gameplay2)
        {
        score += 1
        player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        player.physicsBody?.applyImpulse(CGVector(dx: impulseDirection, dy: 0))
            
        }
        
            if (anotherChanceIsCalled && anotherChanceTime)
            {
                anotherChanceIsCalled = false
                
               let touch = touches.first!
                
                if (anotherChanceNode.contains(touch.location(in: self)) && PlayerBoughtOneLife == false) {
                    
                afterAnotherChanceIsCalled()
                
            }else{
                    anotherChanceIsCalled = false
                    self.anotherChanceNode.removeFromParent()
                    isPlayerDead = true
                    
                   gameOver(message: " ")
        }

        }
            if gamePlay == false {
            

                
            let scene = StartMenu(fileNamed: "StartMenu")
            
            let skView = self.view!
            
            skView.presentScene(scene)
                
            scene?.scaleMode = .aspectFill
        
            skView.ignoresSiblingOrder = true

            
                    }
        
        
        
        
          }
    
 
    func gameOver(message: String) {
        
        


        
        let scaleUp = SKAction.scale(to: 1.5, duration: 2)
        let scale = SKAction.scale(to: 1, duration: 0.25)
        let scaleSequence = SKAction.sequence([scaleUp, scale])
        
        let NewHighScoreLabel = SKLabelNode(fontNamed: "Snickles")
        NewHighScoreLabel.fontSize = 50
        NewHighScoreLabel.fontColor = SKColor.red
        NewHighScoreLabel.zPosition = 3
        NewHighScoreLabel.text = "NEW ! "
        NewHighScoreLabel.position = CGPoint(x: self.frame.size.width / 1.5 , y: self.frame.size.height / 2 + (self.frame.size.height / 20 ))
        NewHighScoreLabel.run(scaleSequence)
 
        
        
        if (score > Variables.HighScore){
            Variables.HighScore = score
            self.addChild(NewHighScoreLabel)
        }

        
        
        let gameOverLabelNode = SKLabelNode(fontNamed: "Snickles")
        gameOverLabelNode.fontSize = 40
        gameOverLabelNode.fontColor = SKColor.white
        gameOverLabelNode.zPosition = 3
        gameOverLabelNode.text = message + "\n your score is \(score)"
        gameOverLabelNode.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        self.addChild(gameOverLabelNode)

        
        
        gameOverLabelNode.run(scaleSequence) { () -> Void in
            
            
           let gameOverStatusNode = SKLabelNode(fontNamed: "Snickles")
            gameOverLabelNode.fontSize = 40
            gameOverLabelNode.fontColor = SKColor.white
            gameOverLabelNode.zPosition = 3
            self.gamePlay = false
            gameOverLabelNode.text = "Tap to restart"
            gameOverLabelNode.position = CGPoint(x: gameOverLabelNode.position.x, y: self.frame.midY - gameOverStatusNode.frame.height - 50)
            self.addChild(gameOverStatusNode)
            
            let scaleUp = SKAction.scale(to: 1.25, duration: 0.5)
            let scaleBack = SKAction.scale(to: 1, duration: 0.25)
            let wait = SKAction.wait(forDuration: 1.0)
            let sequence = SKAction.sequence([wait, scaleUp, scaleBack, wait])
            let scaleForEver = SKAction.repeatForever(sequence)
            gameOverStatusNode.run(scaleForEver)
        
            }
            
            
            
           
       }
    
    
        
    
        func addcoins(){
            


            
            CoinObject = SKSpriteNode(imageNamed: "coin(2)")
            let randomAlienPosition = GKRandomDistribution(lowestValue: 0, highestValue: Int(9) )
            
            
            let position = Int(randomAlienPosition.nextInt())

            
            
  
            
            CoinObject.size = CGSize(width: 60, height: 90)
            CoinObject.position = CGPoint(x: coinsXPossition[position], y: Int(self.frame.size.height))
                CoinObject.physicsBody?.isDynamic = true
            CoinObject.physicsBody?.allowsRotation = true
            CoinObject.physicsBody?.categoryBitMask = PhysicsCategory.CoinsCategory
            CoinObject.physicsBody?.contactTestBitMask = PhysicsCategory.characterCategory
            CoinObject.physicsBody?.collisionBitMask = 0
            CoinObject.physicsBody = SKPhysicsBody(texture: CoinObject.texture!,size: CoinObject.texture!.size())
             CoinObject.physicsBody?.affectedByGravity = false
            CoinObject.physicsBody?.mass = 200

    
            
    
            var actionArray = [SKAction]()
    
    
            actionArray.append(SKAction.move(to: CGPoint(x: CoinObject.position.x, y: -CoinObject.size.height), duration: animationDurationForCoins))
            actionArray.append(SKAction.removeFromParent())
    
            CoinObject.run(SKAction.sequence(actionArray))
            
    
            self.addChild(CoinObject)
                
            
            
            
        } /// end of coin function
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if (player.position.x < middleLign.position.x)
        {
            self.physicsWorld.gravity = CGVector(dx: -6.5, dy: 0)
            impulseDirection = 40
            
        }else if (player.position.x >= middleLign.position.x)
        {
            self.physicsWorld.gravity = CGVector(dx: 6.5, dy: 0)
            impulseDirection = -40
        }
        
        if(player.position.x <=  ( player.size.width / 4) && !isPlayerDead)
        {
            characterDidCollideWithObject(characterNode: player, objectNode: player)
            isPlayerDead = true
            
        }else if(player.position.x >= self.frame.size.width - ( player.size.width / 4) && !isPlayerDead)
        {
            isPlayerDead = true
            characterDidCollideWithObject(characterNode: player, objectNode: player)
        }
        
        if (isPlayerDead == false && anotherChanceNode != nil)
        {
            anotherChanceNode.removeAllChildren()
        }
        
        if (countDownDone)
        {
            callAllFunctions()
            countdownTimer.invalidate()
        }


        if score == 100
        {
            animationDuration = 4.5
            animationDurationForCoins = 4.0
        }else if score == 250 {
            animationDuration = 4.0
            animationDurationForCoins = 3.5
        }
        
        

    }
    

    // a function that creates and controlls the falling stars
    func CreatStarField(){
        starfield = SKEmitterNode(fileNamed: "Starfield")
        starfield.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height)
        starfield.advanceSimulationTime(10)
        starfield.zPosition = -1
        self.addChild(starfield)
    }
    
    // a funcion to create the Character and it's aspects

    
    func CreateScoreLabel(){
        scoreLabel = SKLabelNode(text: "0")
        scoreLabel.zPosition = 2
        scoreLabel.position = CGPoint(x: self.frame.size.width - (self.frame.size.width - 50), y: self.frame.size.height - (self.frame.size.height / 15))
        scoreLabel.fontName = "Snickles"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = UIColor.white
        score = 0
        self.addChild(scoreLabel)

    }
    
    func DrawMiddleLine(){
        middleLign = SKSpriteNode(imageNamed: "middleLine")
        middleLign.position = CGPoint(x: self.frame.size.width / 2 , y: self.frame.size.height / 2)
        middleLign.size.height = middleLign.size.height * 4
        self.addChild(middleLign)
    }
    
    
    // this function spawns the objects on the left hand side of the game and controls the action of those objects
    
    func addAlienFirstHalf () {
        

            
        possibleObjects = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleObjects) as! [String]
        
        let object = SKSpriteNode(imageNamed: possibleObjects[0])
        
        let randomAlienPosition = GKRandomDistribution(lowestValue: Int(CGFloat(object.size.width / 2)), highestValue: Int(self.frame.size.width / 2 -  object.size.width / 2))
        
        
        let position = CGFloat(randomAlienPosition.nextInt())
        
        
        object.position = CGPoint(x: position, y: self.frame.size.height + object.size.height)
        
        object.physicsBody = SKPhysicsBody(texture: object.texture!,size: object.texture!.size())
        object.physicsBody?.isDynamic = true
        
        object.physicsBody?.categoryBitMask = PhysicsCategory.objectCategory
        object.physicsBody?.contactTestBitMask = PhysicsCategory.characterCategory
        object.physicsBody?.collisionBitMask = PhysicsCategory.None
        object.physicsBody?.affectedByGravity = false
        object.physicsBody?.mass = 200
        
        
        self.addChild(object)
        
        
        var actionArray = [SKAction]()
        
        
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -object.size.height), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        object.run(SKAction.sequence(actionArray))
            
        
        
    
    } // end of first half alien function
    
    
    // This function spawns the objects on the Right hand side of the game and controls the action of those objects
    
    func addAlienSecondHalf () {
        
        

        
        possibleObjects = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleObjects) as! [String]
        
        let object = SKSpriteNode(imageNamed: possibleObjects[0])
        
        let randomAlienPosition = GKRandomDistribution(lowestValue: Int(self.frame.size.width / 2 + object.size.width / 2), highestValue: Int(self.frame.size.width -  object.size.width / 2))
        
        
        let position = CGFloat(randomAlienPosition.nextInt())
        
        
        object.position = CGPoint(x: position, y: self.frame.size.height + object.size.height)
        
        object.physicsBody = SKPhysicsBody(texture: object.texture!,size: object.texture!.size())
        object.physicsBody?.isDynamic = true
        object.color = UIColor.cyan
        object.colorBlendFactor = 1
        
        
        object.physicsBody?.categoryBitMask = PhysicsCategory.objectCategory
        object.physicsBody?.contactTestBitMask = PhysicsCategory.characterCategory
        object.physicsBody?.collisionBitMask = PhysicsCategory.None
        object.physicsBody?.affectedByGravity = false
        object.physicsBody?.mass = 200
        
        
        
        self.addChild(object)
        
        
        
        var actionArray = [SKAction]()
        
        
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -object.size.height), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        object.run(SKAction.sequence(actionArray))
        
                    
            
        
    }  // end of second half alien function
    


    
    func characterDidCollideWithObject (characterNode:SKSpriteNode, objectNode:SKSpriteNode) {
        
        
        gameplay2 = false // to stop the score count
        
        
        gameTimer_Coins.invalidate()
        gameTimer_FirstHalf.invalidate()
        gameTimer_SecondHalf.invalidate()
        


        
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = objectNode.position
        self.addChild(explosion)
        
        self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        
        
        characterNode.removeFromParent()
        
        self.run(SKAction.wait(forDuration: 2)) {
            explosion.removeFromParent()
        }
        
        if(Variables.CoinsCollected >= 1 && PlayerBoughtOneLife == false)
        {
            anotherChancefunction()
        }else{

            gameOver(message: "Game Over !")
            
        }

    }
    
    func anotherChancefunction(){
        
       
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 1.5)
        let scale = SKAction.scale(to: 1, duration: 0.25)
        let scaleSequence = SKAction.sequence([scaleUp, scale])
        
        self.run(SKAction.wait(forDuration: 1.4)) {
            self.anotherChanceTime = true
        }

        
        
        anotherChanceIsCalled = true
        anotherChanceNode = SKSpriteNode(imageNamed: "AnotherChance")
        anotherChanceNode.position = CGPoint(x: self.frame.midX - (self.anotherChanceNode.size.width / 85), y: self.frame.midY)
        anotherChanceNode.physicsBody?.affectedByGravity = false
        anotherChanceNode.physicsBody?.isDynamic = false
        anotherChanceNode.size.width = anotherChanceNode.size.width * 1.5
        anotherChanceNode.size.height = anotherChanceNode.size.height * 1.5
        anotherChanceNode.color = UIColor.white
        anotherChanceNode.colorBlendFactor = 100
        anotherChanceNode.zPosition = 7
        
        self.addChild(anotherChanceNode)
        
        anotherChanceNode.run(scaleSequence)
        
    }
    
    func afterAnotherChanceIsCalled(){
        isPlayerDead = false
        PlayerBoughtOneLife = true
        Variables.CoinsCollected = Variables.CoinsCollected - 1
        self.anotherChanceNode.removeFromParent()
        addCharacter()
        player.physicsBody?.categoryBitMask = PhysicsCategory.None
        player.physicsBody?.affectedByGravity = false
        self.run(SKAction.wait(forDuration: 1.9)) {
            self.allTimers()
            self.player.physicsBody?.categoryBitMask = PhysicsCategory.characterCategory
            self.player.physicsBody?.affectedByGravity = true
            
        }

        
    }
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        // 1
        var firstBody: SKPhysicsBody!
        var secondBody: SKPhysicsBody!
        var thirdBody:SKPhysicsBody!
        
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
            
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            secondBody = contact.bodyA
            thirdBody = contact.bodyB
            
        } else {
            thirdBody = contact.bodyB
            secondBody = contact.bodyA
        }


        
        // 2
      
        
        
        if ((firstBody.categoryBitMask & PhysicsCategory.objectCategory != 0) && (secondBody.categoryBitMask & PhysicsCategory.characterCategory != 0))
        {
        
            checkIfScored = false
            characterDidCollideWithObject(characterNode: secondBody.node as! SKSpriteNode , objectNode: firstBody.node as! SKSpriteNode)
            
        }

       
        
            if ((secondBody.categoryBitMask & PhysicsCategory.characterCategory != 0) && (thirdBody.categoryBitMask & PhysicsCategory.CoinsCategory != 0))
        {
            
            if (checkIfScored)
            {
                self.CoinObject.removeFromParent()
                Variables.CoinsCollected += 1
                
                let addCoinsLabel = SKLabelNode(fontNamed: "Snickles")
                addCoinsLabel.text = "+1"
                addCoinsLabel.fontSize = 50
                addCoinsLabel.fontColor = UIColor.white
                addCoinsLabel.zPosition = 200
                addCoinsLabel.position = CGPoint(x: CoinObject.position.x, y: CoinObject.position.y)
                self.addChild(addCoinsLabel)
                
                let actionLabelfadeIn = SKAction.fadeIn(withDuration: 0.5)
                let actionLabelMove = SKAction.move(by: CGVector(dx: 0.0, dy: 100), duration: 0.5)
                let actionRemoveFromParent = SKAction.removeFromParent()
                
                let sequence = SKAction.sequence([actionLabelfadeIn, actionLabelMove, actionLabelfadeIn, actionRemoveFromParent])
                
                addCoinsLabel.run(sequence)
                
            self.run(SKAction.playSoundFileNamed("coinSound.mp3", waitForCompletion: false))
                checkIfScored = false
            }else{
            
                checkIfScored = true
            }
        }

    
        }
    
    

    
}

    



