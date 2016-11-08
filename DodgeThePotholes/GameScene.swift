//
//  GameScene.swift
//  DodgeThePotholes
//
//  Created by Jonathan Buie on 11/7/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//


import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    // MARK: -Temporary Booleans for TESTING
    let sfx:Bool = true
    let noWrap:Bool = true
    
    
    var player:SKSpriteNode!
    var gameTimer:Timer!
    
    var scoreLabel:SKLabelNode!
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score) m"
        }
    }
    
    var possibleObstacles = ["traffic_cone","alien2","alien3"]
    
    let alienCategory:UInt32 = 0x1 << 1
    let photonTorpedoCategory:UInt32 = 0x1 << 0
    
    
    
    
    let motionManager = CMMotionManager()
    var xAcceleration:CGFloat = 0
    
    
    
    override func didMove(to view: SKView) {
        /*
         // Starfield background
         starfield = SKEmitterNode(fileNamed: "Starfield")
         // MAKE DYNAMIC
         starfield.position = CGPoint(x: 0, y: 1472)
         starfield.advanceSimulationTime(10)
         self.addChild(starfield)
         
         starfield.zPosition = -1;
         */
        
        
        // Set up game background
        let bg = roadBackground(size: self.size)
        bg.position = CGPoint(x: 0.0, y: 0.0)
        //bg.size.height = 4*self.size.height
        //bg.size.width = self.size.width
        self.addChild(bg)
        bg.zPosition = -1;
        bg.start()
        
        // MARK: Shaders may be the key to blurring the screen but I have no idea how to use them... yet
        // jab165 11/8/16
        // https://developer.apple.com/reference/spritekit/skshader
        // http://chrislanguage.blogspot.com/2015/02/fragment-shaders-with-spritekit.html
        // https://www.raywenderlich.com/70208/opengl-es-pixel-shaders-tutorial
        
        //let shader = SKShader(fileNamed: "shader_water_movement.fsh")
        //bg.shader = shader
        
        // Set up background Audio
        if sfx {
            let bgAudio = SKAudioNode(fileNamed: "hot-pursuit.wav")
            bgAudio.autoplayLooped = true;
            self.addChild(bgAudio)
        }
        
        
        player = SKSpriteNode(imageNamed: "car1")
        // We're not adding a physics body b/c its not interacting with the physical world
        
        
        // MAKE DYNAMIC
        player.position = CGPoint(x: 0, y: -1*player.size.height/2 - 500)
        //player.position = CGPoint(x: self.frame.size.width / 2, y: player.size.height / 2 + 20)
        
        self.addChild(player)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self; // include SKPhysicsContactDelegate
        
        
        // MARK: - For score
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x:-200, y: self.frame.height / 2 - 60)
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 35
        scoreLabel.fontColor = UIColor.white
        score = 0;
        self.addChild(scoreLabel)
        
        // MARK: - GameTimer code
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)
        
        
        
        // MARK: Initialization for Motion Manage gyro (accelerometer)
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) {(data: CMAccelerometerData?, error:Error?) in
            if let accerometerData = data {
                let acceleration = accerometerData.acceleration
                self.xAcceleration = CGFloat(acceleration.x) * 0.75 + self.xAcceleration * 0/25
                
            }
        }
        
        
    }
    
    func addAlien(){
        possibleObstacles = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleObstacles) as! [String]
        // Always gives us a random alien
        let alien = SKSpriteNode(imageNamed: possibleObstacles[0])
        
        
        // should be dynamic but hardcoded right now
        // MAKE DYNAMIC
        let randomAlienPosition = GKRandomDistribution(lowestValue: -414 + Int(alien.size.width),
                                                       highestValue: 414 - Int(alien.size.width))
        let position = CGFloat(randomAlienPosition.nextInt())
        
        // position alien off the screen
        alien.position = CGPoint(x: position, y:self.frame.size.height/2 + alien.size.height)
        
        //Need to create physics body
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        // Need the bitmask to determine when being hit by torpedo.
        
        alien.physicsBody?.categoryBitMask = alienCategory // of alien category
        alien.physicsBody?.contactTestBitMask = photonTorpedoCategory // object that collides with alien
        alien.physicsBody?.collisionBitMask = 0 // Not sure what this is doing... yet
        
        self.addChild(alien)
        
        let animationDuration:TimeInterval = 6
        
        //Array of actions of aliens
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: position,
                                                     y: -self.frame.size.height/2 - alien.size.height),
                                         duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        alien.run(SKAction.sequence(actionArray))
        
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireTorpedo()
    }
    
    
    // MARK: - Firing Torpedo
    
    func fireTorpedo(){
        self.run(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
        
        let torpedoNode = SKSpriteNode(imageNamed: "torpedo")
        torpedoNode.position = player.position
        torpedoNode.position.y += 5
        
        torpedoNode.physicsBody = SKPhysicsBody(circleOfRadius: torpedoNode.size.width / 2)
        torpedoNode.physicsBody?.isDynamic = true
        
        torpedoNode.physicsBody?.categoryBitMask = photonTorpedoCategory // of torpedo category
        torpedoNode.physicsBody?.contactTestBitMask = alienCategory // object that collides with torpedo
        torpedoNode.physicsBody?.collisionBitMask = 0 // Not sure what this is doing... yet
        torpedoNode.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(torpedoNode)
        
        let animationDuration:TimeInterval = 0.4 //Can be calculated depending on screen size
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: player.position.x,
                                                     y: self.frame.size.height/2 + torpedoNode.size.height),
                                         duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        torpedoNode.run(SKAction.sequence(actionArray))
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask & photonTorpedoCategory) != 0 &&
            (secondBody.categoryBitMask & alienCategory) != 0 {
            
            // Function for what happens when torpedo and alien collide
            torpedoDidCollideWithAlien(torpedoNode: firstBody.node as! SKSpriteNode,
                                       alienNode: secondBody.node as! SKSpriteNode)
            
            
        }
    }
    
    func torpedoDidCollideWithAlien (torpedoNode:SKSpriteNode, alienNode:SKSpriteNode){
        
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = alienNode.position
        self.addChild(explosion)
        self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        
        torpedoNode.removeFromParent()
        alienNode.removeFromParent()
        
        // We need to let explosion run and then remove it
        self.run(SKAction.wait(forDuration: 2)){
            explosion.removeFromParent()
        }
        
        score += 5 // Increase the score!
        
        
    }
    
    
    // This function is to wrap around the screen
    // Is this dynamic enough?
    override func didSimulatePhysics() {
        player.position.x += xAcceleration * 50
        if noWrap{
            if player.position.x < -self.size.width/2 + player.frame.width/4 {
                player.position = CGPoint(x: -self.size.width/2 + player.frame.width/4, y:player.position.y)
            }else if player.position.x > self.size.width/2 - player.frame.width/4{
                player.position = CGPoint(x: self.size.width/2 - player.frame.width/4, y: player.position.y)
            }
        }else{
            if player.position.x < -self.size.width/2 {
                player.position = CGPoint(x: self.size.width/2 - 20, y:player.position.y)
            }else if player.position.x > self.size.width/2 {
                player.position = CGPoint(x: -self.size.width/2 + 20, y: player.position.y)
            }
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        score += 1
    }
    
}
