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
    var gameTimer2:Timer!
    
    var scoreLabel:SKLabelNode!
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score) m"
        }
    }
    
    var possibleObstacles = ["pothole"]
    //var possibleObstacles = ["traffic_cone","pothole", "dog","police"]
    
    
    let motionManager = CMMotionManager()
    var xAcceleration:CGFloat = 0
    
    
    
    override func didMove(to view: SKView) {

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
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.isDynamic = true
        player.zPosition = 1
        player.physicsBody?.categoryBitMask = PhysicsCategory.Car.rawValue
        player.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle.rawValue | PhysicsCategory.MoveableObstacle.rawValue
        player.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
        //player.position = CGPoint(x: self.frame.size.width / 2, y: player.size.height / 2 + 20)
        
        self.addChild(player)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self; // include SKPhysicsContactDelegate
        
        
        // MARK: - For score
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x:-200, y: self.frame.height / 2 - 60)
        scoreLabel.fontName = "PressStart2P"
        scoreLabel.fontSize = 24
        scoreLabel.fontColor = UIColor.white
        score = 0;
        self.addChild(scoreLabel)
        
        // MARK: - GameTimer code
        // aparently a better way to implement this is with SKActions and using a "wait" time
        // instead of the gametimers
        

        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(addObastacle), userInfo: nil, repeats: true)
        //gameTimer2 = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector (addPolice), userInfo:nil, repeats:true)
        
        // MARK: Initialization for Motion Manage gyro (accelerometer)
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) {(data: CMAccelerometerData?, error:Error?) in
            if let accerometerData = data {
                let acceleration = accerometerData.acceleration
                self.xAcceleration = CGFloat(acceleration.x) * 0.75 + self.xAcceleration * 0/25
                
            }
        }
        
        
    }
    // MARK: - Police can be considered a street Obstacle. So may make a more general function later
    // jab165 11/8/16
    /*
    func addPolice(){

        
        // should be dynamic but hardcoded right now
        // MAKE DYNAMIC
        let police = policeCar()
        let randomPolicePosition = GKRandomDistribution(lowestValue: Int(-self.frame.size.width/4) + Int(police.size.width/2),
                                                       highestValue: Int(-police.size.width/2))
        let position = CGFloat(randomPolicePosition.nextInt())
        
        police.position = CGPoint(x:position ,y:self.frame.size.height/2 + police.size.height)
        police.move(dest: CGPoint(x: police.position.x, y: -self.frame.size.height/2 - police.size.height))


        self.addChild(police)
        
        
    }
    */
    func addPothole(){
        let pothole = Pothole(size:self.frame.size, duration: 2)
        self.addChild(pothole)
    }

    
 /*
    func addTrafficCone(){
        let trafficCone = TrafficCone(frameHeight: self.frame.size.height, frameWidth: self.frame.size.width)
        self.addChild(trafficCone.node)
        var actionArray = [SKAction]()
        actionArray.append(trafficCone.action)
        trafficCone.node.run(SKAction.sequence(actionArray))

    }
*/
    func addObastacle(){
        possibleObstacles = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleObstacles) as! [String]
        switch possibleObstacles[0] {
/*
        case "pothole":
            addPothole()
            break
        case "dog":
            addDog()
            break
        case "police":
            addPolice()
            break
        case "traffic_cone":
            addTrafficCone()
            break*/
        default:
            addPothole()
            break
        }
    }
/*
    func addDog(){
        let dog = Dog(frameHeight: self.frame.size.height, frameWidth: self.frame.size.width)
        self.addChild(dog.node)
        var actionArray = [SKAction]()
        actionArray.append(dog.action)
        dog.node.run(SKAction.sequence(actionArray))
        dog.runAnimation()
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
        
        
    }*/
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireTorpedo()
    }
    
    
    // MARK: - Firing Torpedo
    
    func fireTorpedo(){
        self.run(SKAction.playSoundFileNamed("car_honk.mp3", waitForCompletion: false))
        
        let torpedoNode = SKSpriteNode(imageNamed: "carHorn")
        torpedoNode.position = player.position
        torpedoNode.position.y += 5
        
        torpedoNode.physicsBody = SKPhysicsBody(circleOfRadius: torpedoNode.size.width / 2)
        torpedoNode.physicsBody?.isDynamic = true
        
        torpedoNode.physicsBody?.categoryBitMask = photonTorpedoCategory // of torpedo category
        torpedoNode.physicsBody?.contactTestBitMask = PhysicsCategory.MoveableObstacle.rawValue // object that collides with torpedo
        torpedoNode.physicsBody?.collisionBitMask = 0 // Not sure what this is doing... yet
        torpedoNode.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(torpedoNode)
        
        let animationDuration:TimeInterval = 1 //Can be calculated depending on screen size
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: player.position.x,
                                                     y: self.frame.size.height/2 + torpedoNode.size.height),
                                         duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        torpedoNode.run(SKAction.sequence(actionArray))
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Step 1. Bitiwse OR the bodies' categories to find out what kind of contact we have
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch contactMask {
            
        case PhysicsCategory.Car.rawValue | PhysicsCategory.Obstacle.rawValue:
            
            // Step 2. Disambiguate the bodies in the contact
            print("handle collision with car ")

            if contact.bodyA.categoryBitMask == PhysicsCategory.Car.rawValue {
                //handleCollision(enemy: contact.bodyA.node as SKSpriteNode,
                //                bullet: contact.bodyB.node as SKSpriteNode)
                
                print("handle collision with car A")
                
            } else {
                //handleCollision(enemy: contact.bodyB.node as SKSpriteNode, bullet: contact.bodyA.node as SKSpriteNode)
                print("handle collision with car B")

            }
            
            //1. Lose a life and
            
            
        case PhysicsCategory.Car.rawValue | PhysicsCategory.MoveableObstacle.rawValue:
            
            // Here we don't care which body is which, the scene is ending
            print("car hit moveable object")
            
        default:
            
            // Nobody expects this, so satisfy the compiler and catch
            // ourselves if we do something we didn't plan to
            //fatalError("other collision: \(contactMask)")
            
            
            print("other collision: \(contactMask)")
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
        
        var speed = 0.0;
        if score % 1000 == 0{
           speed += 0.1
        }
        
    }
    
}
