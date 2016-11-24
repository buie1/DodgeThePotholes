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
    let music:Bool = preferences.bool(forKey: "music")
    let noWrap:Bool = true
    
    
    let backgroundQueue = DispatchQueue(label: "com.app.queue",
                                        qos: .background,
                                        target: nil)
    
    
    var player:Player!
    var gameTimer:Timer!
    var bgTimer:Timer!

    
    // MARK: HUD Variables
    var scoreLabel:SKLabelNode!
    var moneyLabel:SKLabelNode!
    var livesArray:[SKSpriteNode]!

    var money:Int = 0 {
        didSet {
            moneyLabel.text = "Money: $ \(money)"
        }
    }
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score) m"
        }
    }
    
    var possibleObstacles = ["pothole", "police","dog","coin","cone", "human"]
    
    let motionManager = CMMotionManager()
    var xAcceleration:CGFloat = 0
    
    var gameSpeed: CGFloat = 2.0
    
    
    
    override func didMove(to view: SKView) {
        

        // Set up game background
        let bg = roadBackground(size: self.size)
        bg.position = CGPoint(x: 0.0, y: 0.0)
        //bg.size.height = 4*self.size.height
        //bg.size.width = self.size.width
        self.addChild(bg)
        bg.zPosition = -1;
        bg.start(duration: gameSpeed)
        
        // TIMER TO PERIODICALLY SPEED UP GAME
        bgTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(GameScene.updateBackground), userInfo: nil, repeats: true)
        
        // MARK: Shaders may be the key to blurring the screen but I have no idea how to use them... yet
        // jab165 11/8/16
        // https://developer.apple.com/reference/spritekit/skshader
        // http://chrislanguage.blogspot.com/2015/02/fragment-shaders-with-spritekit.html
        // https://www.raywenderlich.com/70208/opengl-es-pixel-shaders-tutorial
        
        //let shader = SKShader(fileNamed: "shader_water_movement.fsh")
        //bg.shader = shader
        
        // Set up background Audio
        if music {
            let bgAudio = SKAudioNode(fileNamed: "hot-pursuit.wav")
            bgAudio.autoplayLooped = true;
            self.addChild(bgAudio)
        }
        
        // MARK: Player on Screen
        
        player = Player(size: self.size)
        self.addChild(player)
        
        // MARK: Physics World
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self; // include SKPhysicsContactDelegate
        self.view?.showsPhysics = true;
        
        
        // MARK: - For score
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x:-self.size.width*0.25, y: self.frame.height / 2 - 60)
        scoreLabel.fontName = "PressStart2P"
        scoreLabel.fontSize = 24
        scoreLabel.fontColor = UIColor.white
        score = 0;
        self.addChild(scoreLabel)
        
        // MARK: - For Money
        moneyLabel = SKLabelNode(text: "Money: \(preferences.value(forKey: "money"))")
        moneyLabel.position = CGPoint(x:-self.size.width*0.25, y: self.frame.height / 2 - 60*2)
        moneyLabel.fontName = "PressStart2P"
        moneyLabel.fontSize = 24
        moneyLabel.fontColor = UIColor.white
        money = 0
        self.addChild(moneyLabel)
        
        
        addLives()

        
        // MARK: - GameTimer code
        // aparently a better way to implement this is with SKActions and using a "wait" time
        // instead of the gametimers
        
        print("run game timer")
        gameTimer = Timer.scheduledTimer(timeInterval: 1.75, target: self, selector: #selector(self.addObastacle), userInfo: nil, repeats: true)
        
        
        // MARK: Initialization for Motion Manage gyro (accelerometer)
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) {(data: CMAccelerometerData?, error:Error?) in
            if let accerometerData = data {
                let acceleration = accerometerData.acceleration
                self.xAcceleration = CGFloat(acceleration.x) * 0.75 + self.xAcceleration * 0/25
            }
        }
        
        
    }
    
    
    // MARK: Initialize Lives
    func addLives (){
        
        livesArray = [SKSpriteNode]()
        
        for live in 1 ... 3 {
            let liveNode = SKSpriteNode(imageNamed: "wheel")
            liveNode.name = "live\(live)"
            liveNode.position = CGPoint(x: self.frame.size.width/2 - 30 - CGFloat((4 - live)) * liveNode.size.width, y: self.frame.size.height/2 - 60)
            liveNode.size = CGSize(width: 4*scoreLabel.frame.size.height, height: 4*scoreLabel.frame.size.height)
            self.addChild(liveNode)
            livesArray.append(liveNode)
        }
    }
    
    func loseLife() {
        let lifeNode = self.livesArray.first
        if lifeNode != nil {
            lifeNode!.removeFromParent()
            self.livesArray.removeFirst()
        } else {
            print("Out of lives.  Cannot remove another life.")
        }
        if self.livesArray.count == 0 {
            //let transition = SKTransition.flipHorizontal(withDuration: 0.5)
            print("GAME OVER")
            let transition = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOver = SKScene(fileNamed: "GameOverScene") as! GameOverScene
            gameOver.previousHighscore = preferences.value(forKey: "highscore") as! Int
            updateHighScore()
            gameOver.score = self.score
            gameOver.scaleMode = .aspectFill
            gameOver.money = money
            
            // In order to stop the game from playing before game over scene
            bgTimer.invalidate()
            gameTimer.invalidate()
            self.removeAllActions()
            self.removeAllChildren()
            self.view?.presentScene(gameOver, transition: transition)
        }
    }
    
    
    // MARK: Add Obstalces and Other GameplayItems to Screen
    func addPolice(){
        let police = policeCar(size:self.size, duration:TimeInterval(gameSpeed))
        self.addChild(police)
    }
    
    func addPothole(){
        let pothole = Pothole(size:self.size, duration:TimeInterval(gameSpeed))
        self.addChild(pothole)
    }
    func addConePattern(){
        self.gameTimer.invalidate()
        let alertLabel = SKLabelNode(text: "Traffic Zone Approaching!")
        alertLabel.fontName = "PressStart2P"
        alertLabel.fontSize = 24
        alertLabel.fontColor = UIColor.red
        alertLabel.position = CGPoint(x:self.size.width, y:0)
        self.addChild(alertLabel)
        alertLabel.run(SKAction.sequence([SKAction.group([flashAction,flyAction]),removeNodeAction]))
        
        let alertSign = SKSpriteNode(imageNamed: "alert")
        alertSign.position = CGPoint(x: 0, y: self.size.height/2 - alertSign.size.height)
        alertSign.size = CGSize(width: alertSign.size.width*3, height: alertSign.size.height*3)
        self.addChild(alertSign)
        alertSign.run(SKAction.sequence([flashAction,removeNodeAction]))
        
        _ = ConePattern(scene: self, duration: TimeInterval(self.gameSpeed))
        let resumeGameTimer = SKAction.run {
            self.gameTimer = Timer.scheduledTimer(timeInterval: 1.75, target: self, selector: #selector(self.addObastacle), userInfo: nil, repeats: true)
        }
        self.run(SKAction.sequence([pauseForObstacles,resumeGameTimer]))
    }
    func addDog(){
        let dog = Dog(size:self.frame.size, duration: TimeInterval(gameSpeed))
        self.addChild(dog)
    }
    func addHuman(){
        let human = Human(size:self.frame.size, duration: TimeInterval(gameSpeed))
        self.addChild(human)
    }
    func addCoinPattern(){
        _ = CoinPattern(scene:self, duration:TimeInterval(self.gameSpeed))

    }
    
    func addObastacle(){
                possibleObstacles = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleObstacles) as! [String]
        switch possibleObstacles[0] {
        case "pothole":
            addPothole()
            break
        case "police":
            addPolice()
            break
        case "dog":
            addDog()
            break
        case "coin":
            addCoinPattern()
            break
        case "cone":
            addConePattern()
            break
        case "human":
            addHuman()
            break;
        default:
            addPothole()
            break
        }
    }

    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        honkHorn()
    }
    
    
    // MARK: - honking horn
    
    func honkHorn(){
        if preferences.bool(forKey: "sfx") == true {
            self.run(SKAction.playSoundFileNamed("car_honk.mp3", waitForCompletion: false))
        }
        
        let hornNode = SKSpriteNode(imageNamed: "carHorn")
        hornNode.position = player.position
        hornNode.position.y += 5
        
        hornNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: hornNode.size.width * 5, height: hornNode.size.height))
        
        hornNode.physicsBody?.isDynamic = true
        
        hornNode.physicsBody?.categoryBitMask = PhysicsCategory.Horn.rawValue
        hornNode.physicsBody?.contactTestBitMask = PhysicsCategory.MoveableObstacle.rawValue
        hornNode.physicsBody?.collisionBitMask = 0
        hornNode.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(hornNode)
        
        let animationDuration:TimeInterval = 1 //Can be calculated depending on screen size
        
        var hornArray = [SKAction]()
        var removeHornArray = [SKAction]()

        
        hornArray.append(SKAction.move(to: CGPoint(x: player.position.x,
                                                     y: /*self.frame.size.height +*/ hornNode.size.height),
                                         duration: animationDuration))
        hornArray.append(SKAction.resize(toWidth: hornNode.size.width * 15, duration: animationDuration))
        let hornGroup = SKAction.group(hornArray)
        removeHornArray.append(hornGroup)
        removeHornArray.append(SKAction.removeFromParent())
        hornNode.run(SKAction.sequence(removeHornArray))
        

    }
    
    //MARK: Upadate Highscore
    func updateHighScore(){
        if score > preferences.value(forKey: "highscore") as! Int {
            preferences.set(score, forKey: "highscore")
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Step 1. Bitiwse OR the bodies' categories to find out what kind of contact we have
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        switch contactMask {
            
        case PhysicsCategory.Car.rawValue | PhysicsCategory.Obstacle.rawValue:
            
            // Step 2. Disambiguate the bodies in the contact
            print("handle collision with car ")

            if contact.bodyA.categoryBitMask == PhysicsCategory.Car.rawValue{
                carDidHitObstacle(car: contact.bodyA.node as! Player,
                                       obj: contact.bodyB.node as! SKSpriteNode)
            } else{
                carDidHitObstacle(car: contact.bodyB.node as! Player,
                                       obj: contact.bodyA.node as! SKSpriteNode)
            }
            
            
        case PhysicsCategory.Car.rawValue | PhysicsCategory.MoveableObstacle.rawValue:
            
            // Here we don't care which body is which, the scene is ending
            if contact.bodyA.categoryBitMask == PhysicsCategory.Car.rawValue{
                carDidHitMoveableObstacle(car: contact.bodyA.node as! Player,
                                  obj: contact.bodyB.node as! MoveableObstacle)
            } else{
                carDidHitMoveableObstacle(car: contact.bodyB.node as! Player,
                                  obj: contact.bodyA.node as! MoveableObstacle)
            }
            
            
            
        case PhysicsCategory.Horn.rawValue | PhysicsCategory.MoveableObstacle.rawValue:
            print("horn hit movabale object")
            if contact.bodyA.categoryBitMask == PhysicsCategory.Horn.rawValue {
                hornDidHitMoveableObstacle(horn: contact.bodyA.node as! SKSpriteNode,
                                           obj: contact.bodyB.node as! MoveableObstacle)
            } else{
                hornDidHitMoveableObstacle(horn: contact.bodyB.node as! SKSpriteNode,
                                           obj: contact.bodyA.node as! MoveableObstacle)
            }
            
        case PhysicsCategory.Car.rawValue | PhysicsCategory.Coin.rawValue:
            print("Car hit a coin")
            if contact.bodyA.categoryBitMask == PhysicsCategory.Car.rawValue {
                carDidHitCoin(car: contact.bodyA.node as! SKSpriteNode,
                              coin: contact.bodyB.node as! SKSpriteNode)
            }else{
                carDidHitCoin(car: contact.bodyB.node as! SKSpriteNode,
                              coin: contact.bodyA.node as! SKSpriteNode)
            }
            
        default:
            
            // Nobody expects this, so satisfy the compiler and catch
            // ourselves if we do something we didn't plan to
            //fatalError("other collision: \(contactMask)")
            
            
            print("other collision: \(contactMask)")
        }
    }
    
    // MARK: Collision Handlers
    
    func hornDidHitMoveableObstacle(horn:SKSpriteNode, obj:MoveableObstacle){
        
        horn.removeFromParent()
        obj.removeAllActions()
        // If moveable obstacle is hit by horn remove the cat bit mask so it can't be hit again!
        obj.physicsBody?.categoryBitMask = PhysicsCategory.None.rawValue
        obj.runAway(self.frame.size, 2)
        
    }
    
    
    func carDidHitObstacle(car:Player, obj:SKSpriteNode){
        let name = obj.name
        switch  name! {
        case "pothole":
            car.spinOut()
        default:
            print("do nothing")
        }
        car.recover()
        loseLife()
        obj.removeFromParent()
        
    }
    
    //func carDidHitMoveableObstacle(car:Player, obj:SKSpriteNode){
    func carDidHitMoveableObstacle(car:Player, obj:MoveableObstacle){
        let name = obj.name
        switch name! {
        case "dog":
            print("you hit a dog!")
            obj.destroy()
        case "human":
            print("you hit a human!")
            obj.destroy()
            
        default:
            print("hit a moveable obj")
            obj.removeFromParent()
        }
        car.recover()
        loseLife()
       
        
    }
    
    func carDidHitCoin(car:SKSpriteNode, coin:SKSpriteNode){
        self.money += 1
        preferences.setValue(preferences.value(forKey:"money") as! Int + 1, forKey: "money")
        preferences.synchronize()
        coin.removeFromParent()
    }
    
    
    
    
    // This function is to wrap around the screen
    // Is this dynamic enough?
    override func didSimulatePhysics() {
        self.player.position.x += xAcceleration * 50
        
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
    
    func updateBackground(){
        // Set up game background
        let bg = roadBackground(size: self.size)
        bg.position = CGPoint(x: 0.0, y: 0.0)
        //bg.size.height = 4*self.size.height
        //bg.size.width = self.size.width
        self.addChild(bg)
        bg.zPosition = -1;
        
        if(gameSpeed > 0.2){
        gameSpeed -= 0.1
        bg.start(duration: gameSpeed)
        print("current game speed is \n")
        print(gameSpeed)
        }
        else{
        bg.loopForever(duration: gameSpeed)
        }
    }
 
    
}
