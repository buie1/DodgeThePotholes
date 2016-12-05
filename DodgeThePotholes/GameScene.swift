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

class GameScene: SKScene, SKPhysicsContactDelegate, Alerts {
    
    
    // MARK: -Temporary Booleans for TESTING
    let music:Bool = preferences.bool(forKey: "music")
    //let noWrap:Bool = true
    var isGameOver:Bool!
    var oneCollision:Bool = false
    
    
    var player:Player!
    var gameTimer:Timer!
    var bgTimer:Timer!
    var envTimer:Timer!
    var powerUpTimer:Timer!
    var monsterTruckTimer:Timer!
    var textTimer:Timer!
    var lifeCount:Int = GameSettings.BeginningLifeCount.rawValue
    var bgAudio = SKAudioNode(fileNamed: preferences.value(forKey: "song_selected")! as! String)
    
    // MARK: HUD Variables
    var scoreLabel:SKLabelNode!
    var moneyLabel:SKLabelNode!
    var timerLabel:SKLabelNode!
    var livesArray:[SKSpriteNode]!
    var playerIsInvincible = false
    var textCount:Int = 0
    
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
    
    var powerUpTime:Int = 15 {
        didSet {
            timerLabel.text = String(format: "Time: 00:%02d", powerUpTime)
        }
    }
    
    var possibleObstacles = ["pothole", "pothole", "pothole", "pothole",
                             "police", "police",
                             "dog", "dog", "dog",
                             "coin", "coin", "coin",
                             "car", "car", "car",
                             "human", "human", "human", "human",
                             "ambulance", "ambulance",
                             "cone",
                             "ice", "ice", "ice"]
    
    let motionManager = CMMotionManager()
    var xAcceleration:CGFloat = 0
    
    var gameSpeed: CGFloat = CGFloat(startGameSpeed)
    
    
    
    override func didMove(to view: SKView) {
        
        isGameOver = false;
        // Set up game background
        let bg = roadBackground(size: self.size)
        bg.position = CGPoint(x: 0.0, y: 0.0)
        //bg.size.height = 4*self.size.height
        //bg.size.width = self.size.width
        self.addChild(bg)
        bg.zPosition = -1;
        bg.start(duration: gameSpeed)
        
        // TIMER TO PERIODICALLY SPEED UP GAME
        bgTimer = Timer.scheduledTimer(timeInterval: bgTimeInterval, target: self, selector: #selector(GameScene.updateBackground), userInfo: nil, repeats: true)
        
        // MARK: Shaders may be the key to blurring the screen but I have no idea how to use them... yet
        // jab165 11/8/16
        // https://developer.apple.com/reference/spritekit/skshader
        // http://chrislanguage.blogspot.com/2015/02/fragment-shaders-with-spritekit.html
        // https://www.raywenderlich.com/70208/opengl-es-pixel-shaders-tutorial
        
        
        // Set up background Audio
        if music {
            //let bgAudio = SKAudioNode(fileNamed: "hot-pursuit.wav")
            bgAudio.autoplayLooped = true;
            self.addChild(bgAudio)
        }
        
        // MARK: Player on Screen
        
        player = Player(size: self.size)
        self.addChild(player)
        
        // MARK: Physics World
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self; // include SKPhysicsContactDelegate
        self.view?.showsPhysics = false;
        
        
        // MARK: Set up HUD
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x:-self.size.width*0.25, y: self.frame.height / 2 - 60)
        scoreLabel.fontName = "PressStart2P"
        scoreLabel.fontSize = 24
        scoreLabel.fontColor = UIColor.white
        score = 0;
        self.addChild(scoreLabel)
        
        moneyLabel = SKLabelNode(text: "Money: \(preferences.value(forKey: "money"))")
        moneyLabel.position = CGPoint(x:-self.size.width*0.25, y: self.frame.height / 2 - 60*2)
        moneyLabel.fontName = "PressStart2P"
        moneyLabel.fontSize = 24
        moneyLabel.fontColor = UIColor.white
        money = 0
        self.addChild(moneyLabel)
        
        timerLabel = SKLabelNode(text: "Time: \(powerUpTime)")
        timerLabel.position = CGPoint(x:-self.size.width*0.25, y: self.frame.height / 2 - 60*3)
        timerLabel.fontName = "PressStart2P"
        timerLabel.fontSize = 24
        timerLabel.fontColor = UIColor.yellow
        timerLabel.isHidden = true
        self.addChild(timerLabel)
        
        addLivesDisplay(num_lives: self.lifeCount)

        
        // MARK: - GameTimer code
        // aparently a better way to implement this is with SKActions and using a "wait" time
        // instead of the gametimers
        
        print("run game timer")
        gameTimer = Timer.scheduledTimer(timeInterval: 1.75, target: self, selector: #selector(self.addObstacle), userInfo: nil, repeats: true)
        
        envTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.addEnvObstacle), userInfo: nil, repeats: true)
        
        powerUpTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.addPowerUp), userInfo: nil, repeats: true)
       
        
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
    func addLivesDisplay (num_lives:Int){
        
        livesArray = [SKSpriteNode]()
        
        for live in 1 ... num_lives {
            let liveNode = SKSpriteNode(imageNamed: "wheel")
            liveNode.name = "live\(live)"
            liveNode.position = CGPoint(x: self.frame.size.width/2 - 40 - CGFloat((4 - live)) * liveNode.size.width, y: self.frame.size.height/2 - 60)
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
            self.lifeCount -= 1
        } else {
            print("Out of lives.  Cannot remove another life.")
        }
        if self.livesArray.count == 0 {
            //let transition = SKTransition.flipHorizontal(withDuration: 0.5)
            print("GAME OVER")
            self.isGameOver = true
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
            envTimer.invalidate()
            powerUpTimer.invalidate()
            if(monsterTruckTimer != nil){
                monsterTruckTimer.invalidate()
            }
            self.removeAllActions()
            self.removeAllChildren()
            self.view?.presentScene(gameOver, transition: transition)
        }
    }
    
    
    // MARK: Add Obstalces and Other GameplayItems to Screen
    
    func addAmbulance(){
        let amb = Ambulance(size:self.size, duration:TimeInterval(gameSpeed))
        self.addChild(amb)
    }
    
    func addCars(){
        let c = MovingCar(size:self.size, duration:TimeInterval(gameSpeed))
        self.addChild(c)
    }
    
    func addPolice(){
        let police = policeCar(size:self.size, duration:TimeInterval(gameSpeed))
        self.addChild(police)
    }
    
    func addPothole(){
        let pothole = Pothole(size:self.size, duration:TimeInterval(gameSpeed))
        self.addChild(pothole)
    }
    func addTextMessage(){
        textCount += 1
        let textMessage = TextMessage(size:self.size, duration:TimeInterval(gameSpeed))
        self.addChild(textMessage)
    }
   
    func addConePattern(){
        self.gameTimer.invalidate()
        let alertLabel = SKLabelNode(text: "Traffic Zone Approaching!")
        alertLabel.fontName = "PressStart2P"
        alertLabel.fontSize = 28
        alertLabel.fontColor = UIColor.red
        alertLabel.position = CGPoint(x:self.size.width, y:0)
        self.addChild(alertLabel)
        alertLabel.run(SKAction.sequence([flyInFunction(t: TimeInterval(Double(gameSpeed)/startGameSpeed)),removeNodeAction]))
        
        let alertSign = SKSpriteNode(imageNamed: "alert")
        alertSign.position = CGPoint(x: 0, y: self.size.height/2 - alertSign.size.height)
        alertSign.size = CGSize(width: alertSign.size.width*3, height: alertSign.size.height*3)
        self.addChild(alertSign)
        alertSign.run(SKAction.sequence([flashAction,removeNodeAction]))
        
        let conePat = ConePattern(scene: self, duration: TimeInterval(self.gameSpeed))
        let resumeGameTimer = SKAction.run {
            self.gameTimer = Timer.scheduledTimer(timeInterval: 1.75, target: self, selector: #selector(self.addObstacle), userInfo: nil, repeats: true)
        }
        print("pause time before next obstacle: \(conePat.returnPauseTime())")
        self.run(SKAction.sequence([pauseFunction(t: conePat.returnPauseTime()),resumeGameTimer]))
    }
    func addDog(){
        let dog = Dog(size:self.frame.size, duration: TimeInterval(gameSpeed))
        self.addChild(dog)
    }
    func addHuman(){
        let human = Human(size:self.frame.size, duration: TimeInterval(gameSpeed))
        self.addChild(human)
    }
    func addPlant(){
        //self.gameTimer.invalidate()
        let plant = Plant(size:self.frame.size, duration: TimeInterval(gameSpeed))
        self.addChild(plant)
    }
    func addCoinPattern(){
        _ = CoinPattern(scene:self, duration:TimeInterval(self.gameSpeed))

    }
    func addWrap(){
        let powWrap = PowerupWrap(scene:self, duration:TimeInterval(self.gameSpeed))
        self.addChild(powWrap)
    }
    
    func addMultiplier(){
        var val:Int!
        let rand = arc4random_uniform(2)
        if rand == 0{
            val = 2
        } else{
            val = 3
        }
        let mult = MultiplierPowerUp(scene:self, duration:TimeInterval(self.gameSpeed), val:val)
        self.addChild(mult)
    }
    
    func addEnvObstacle(){
        let rand = GKRandomDistribution(lowestValue: 0,highestValue: 10)
        if (rand.nextInt()  > 1){
            self.addPlant()
        }else{
            addCoinPattern()
        }
    }
    
    func addPowerUp(){
        let rand = GKRandomDistribution(lowestValue: 0,highestValue: 5)
        if (rand.nextInt()  == 5){
            self.addOneUp()
        }else if(rand.nextInt() == 4){
            self.addWrap()
        }else if(rand.nextInt() == 3){
            self.addMultiplier()
        }else if(rand.nextInt() == 2){
            print("Incoming text!")
            self.addTextMessage()
        }else if(rand.nextInt() <= 1){
            self.addMonsterTruck()
        }
    }
    /*
    func addPowerUp(){
        let rand = GKRandomDistribution(lowestValue: 0,highestValue: 1)
        if (rand.nextInt()  == 0){
            self.addWrap()
        }else{
            self.addMultiplier()
        }
    }*/
    func addMonsterTruck(){
        let powMonsterTruck = PowerupMosterTruck(scene:self, duration:TimeInterval(self.gameSpeed))
        self.addChild(powMonsterTruck)
    }
    func addOneUp(){
        let powOneUp = PowerupOneUp(scene:self, duration:TimeInterval(self.gameSpeed))
        self.addChild(powOneUp)
    }
    func addIce(){
        let ice = blackIce(size:self.frame.size, duration:TimeInterval(self.gameSpeed))
        self.addChild(ice)
    }
    func addObstacle(){
        possibleObstacles = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleObstacles) as! [String]
        switch possibleObstacles[0] {
        case "pothole":
            print("pothole obstacle")
            addPothole()
            break
        case "police":
            print("police obstacle")
            addPolice()
            break
        case "dog":
            print("dog obstacle")
            addDog()
            break
        case "car":
            print("car obstacle")
            addCars()
            break
        case "cone":
            addConePattern()
            break
        case "human":
            print("human obstacle")
            addHuman()
            break
        case "ambulance":
            print("ambulance obstacle")
            addAmbulance()
            break
        case "ice":
            print("Black Ice!")
            addIce()
            break
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
            self.run(SKAction.playSoundFileNamed("car_honk.mp3", waitForCompletion: true))
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
                                                   y: self.frame.size.height/4 + hornNode.size.height),
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
        if !self.isGameOver{
            let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
            switch contactMask {
                
            case PhysicsCategory.Car.rawValue | PhysicsCategory.Obstacle.rawValue:
                print("handle collision with car ")
                if(!self.oneCollision){
                    self.oneCollision = true
                    if contact.bodyA.categoryBitMask == PhysicsCategory.Car.rawValue{
                        carDidHitObstacle(car: contact.bodyA.node as! Player,
                                               obj: contact.bodyB.node as! SKSpriteNode)
                    } else{
                        carDidHitObstacle(car: contact.bodyB.node as! Player,
                                               obj: contact.bodyA.node as! SKSpriteNode)
                    }
                }
                
            case PhysicsCategory.MonsterTrucker.rawValue | PhysicsCategory.Obstacle.rawValue:
                print("handle collision with Monster Truck ")
                if contact.bodyA.categoryBitMask == PhysicsCategory.MonsterTrucker.rawValue{
                    monsterTruckDidHitObstacle(car: contact.bodyA.node as! Player,
                                      obj: contact.bodyB.node as! SKSpriteNode)
                } else{
                    monsterTruckDidHitObstacle(car: contact.bodyB.node as! Player,
                                      obj: contact.bodyA.node as! SKSpriteNode)
                }
                
            case PhysicsCategory.MonsterTrucker.rawValue | PhysicsCategory.MoveableObstacle.rawValue:
                
                if contact.bodyA.categoryBitMask == PhysicsCategory.MonsterTrucker.rawValue{
                    monsterTruckDidHitObstacle(car: contact.bodyA.node as! Player,
                                              obj: contact.bodyB.node as! MoveableObstacle)
                } else{
                    monsterTruckDidHitObstacle(car: contact.bodyB.node as! Player,
                                              obj: contact.bodyA.node as! MoveableObstacle)
                }
                
            case PhysicsCategory.Car.rawValue | PhysicsCategory.MoveableObstacle.rawValue:
                
                if(!self.oneCollision){
                    self.oneCollision = true
                    if contact.bodyA.categoryBitMask == PhysicsCategory.Car.rawValue{
                        carDidHitMoveableObstacle(car: contact.bodyA.node as! Player,
                                          obj: contact.bodyB.node as! MoveableObstacle)
                    } else{
                        carDidHitMoveableObstacle(car: contact.bodyB.node as! Player,
                                          obj: contact.bodyA.node as! MoveableObstacle)
                    }
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
            case PhysicsCategory.MonsterTrucker.rawValue | PhysicsCategory.Coin.rawValue:
                print("Monstertruck hit a coin")
                if contact.bodyA.categoryBitMask == PhysicsCategory.MonsterTrucker.rawValue {
                    carDidHitCoin(car: contact.bodyA.node as! SKSpriteNode,
                                  coin: contact.bodyB.node as! SKSpriteNode)
                }else{
                    carDidHitCoin(car: contact.bodyB.node as! SKSpriteNode,
                                  coin: contact.bodyA.node as! SKSpriteNode)
                }
            case PhysicsCategory.Car.rawValue | PhysicsCategory.Wrap.rawValue:
                print("Car hit a wrap powerup")
                
                if(!powerUps.wrap){
                    // if you can already wrap ignore it!
                    if contact.bodyA.categoryBitMask == PhysicsCategory.Car.rawValue {
                        carCanWrap(car: contact.bodyA.node as! SKSpriteNode,
                                    wrap: contact.bodyB.node as! PowerupWrap)
                    } else if (contact.bodyA.categoryBitMask == PhysicsCategory.MonsterTrucker.rawValue) {
                            
                        
                    }else{
                        carCanWrap(car: contact.bodyB.node as! SKSpriteNode,
                                   wrap: contact.bodyA.node as! PowerupWrap)
                    }
                }
            case PhysicsCategory.MonsterTrucker.rawValue | PhysicsCategory.Wrap.rawValue:
                print("Car hit a wrap powerup")
                
                if(!powerUps.wrap){
                    // if you can already wrap ignore it!
                    if contact.bodyA.categoryBitMask == PhysicsCategory.MonsterTrucker.rawValue {
                        carCanWrap(car: contact.bodyA.node as! SKSpriteNode,
                                   wrap: contact.bodyB.node as! PowerupWrap)
                    }else{
                        carCanWrap(car: contact.bodyB.node as! SKSpriteNode,
                                   wrap: contact.bodyA.node as! PowerupWrap)
                    }
                }
            case PhysicsCategory.Car.rawValue | PhysicsCategory.OneUp.rawValue:
                print("Plus one Life!")
                if contact.bodyA.categoryBitMask == PhysicsCategory.Car.rawValue {
                    carDidHitOneUp(car: contact.bodyA.node as! SKSpriteNode, oneup: contact.bodyB.node as! PowerupOneUp)
                }else{
                    carDidHitOneUp(car: contact.bodyB.node as! SKSpriteNode, oneup: contact.bodyA.node as! PowerupOneUp)
                }
            case PhysicsCategory.MonsterTrucker.rawValue | PhysicsCategory.OneUp.rawValue:
                print("Plus one Life!")
                if contact.bodyA.categoryBitMask == PhysicsCategory.MonsterTrucker.rawValue {
                    carDidHitOneUp(car: contact.bodyA.node as! SKSpriteNode, oneup: contact.bodyB.node as! PowerupOneUp)
                }else{
                    carDidHitOneUp(car: contact.bodyB.node as! SKSpriteNode, oneup: contact.bodyA.node as! PowerupOneUp)
                }
            case PhysicsCategory.Car.rawValue | PhysicsCategory.Star.rawValue:
                print ("You are now a MOOOONSTER TRUUUUUCK")
                if contact.bodyA.categoryBitMask == PhysicsCategory.Car.rawValue {
                    carDidHitStar(car: contact.bodyA.node as! SKSpriteNode, star: contact.bodyB.node as! PowerupMosterTruck)
                }else{
                    carDidHitStar(car: contact.bodyB.node as! SKSpriteNode, star: contact.bodyA.node as! PowerupMosterTruck)
                }
            case PhysicsCategory.MonsterTrucker.rawValue | PhysicsCategory.Star.rawValue:
                print ("You are now a MOOOONSTER TRUUUUUCK")
                if contact.bodyA.categoryBitMask == PhysicsCategory.MonsterTrucker.rawValue {
                   // carDidHitStar(car: contact.bodyA.node as! SKSpriteNode, star: contact.bodyB.node as! PowerupMosterTruck)
                }else{
                   //carDidHitStar(car: contact.bodyB.node as! SKSpriteNode, star: contact.bodyA.node as! PowerupMosterTruck)
                }
                
            case PhysicsCategory.Car.rawValue | PhysicsCategory.Multiplier.rawValue:
                if(powerUps.multiplier == 1){
                    if contact.bodyA.categoryBitMask == PhysicsCategory.Car.rawValue {
                        carHitMultiplier(car: contact.bodyA.node as! SKSpriteNode,
                                      mult: contact.bodyB.node as! MultiplierPowerUp)
                    }else{
                        carHitMultiplier(car: contact.bodyB.node as! SKSpriteNode,
                                      mult: contact.bodyA.node as! MultiplierPowerUp)
                    }
                }
                print("already have a multiplier applied")

            case PhysicsCategory.MonsterTrucker.rawValue | PhysicsCategory.Multiplier.rawValue:
                if(powerUps.multiplier == 1){
                    if contact.bodyA.categoryBitMask == PhysicsCategory.MonsterTrucker.rawValue {
                        carHitMultiplier(car: contact.bodyA.node as! SKSpriteNode,
                                         mult: contact.bodyB.node as! MultiplierPowerUp)
                    }else{
                        carHitMultiplier(car: contact.bodyB.node as! SKSpriteNode,
                                         mult: contact.bodyA.node as! MultiplierPowerUp)
                    }
                }
                print("already have a multiplier applied")

                
            default:
                
                // Nobody expects this, so satisfy the compiler and catch
                // ourselves if we do something we didn't plan to
                //fatalError("other collision: \(contactMask)")
                
                
                print("other collision: \(contactMask)")
            }
        }
    }
    
    // MARK: Collision Handlers
    
    
    func carHitMultiplier(car:SKSpriteNode, mult:MultiplierPowerUp){
        mult.removeFromParent()
        powerUpTime = 30
        mult.timerStart(self, TimeInterval(self.gameSpeed))
    }
    
    func carCanWrap(car:SKSpriteNode, wrap:PowerupWrap){
        print("Able to wrap Screen for 15 seconds")
        wrap.removeFromParent()
        powerUpTime = 15
        wrap.timerStart(self,TimeInterval(self.gameSpeed))
        print("wrap is true")
        powerUps.wrap = true
    }
    
    func hornDidHitMoveableObstacle(horn:SKSpriteNode, obj:MoveableObstacle){        
        horn.removeFromParent()
        obj.removeAllActions()
        // If moveable obstacle is hit by horn remove the cat bit mask so it can't be hit again!
        obj.physicsBody?.categoryBitMask = PhysicsCategory.None.rawValue
        obj.runAway(self.frame.size, 2)
        
    }
    
    func carDidHitOneUp(car: SKSpriteNode, oneup: PowerupOneUp){
        print("added life!")
        oneup.removeFromParent()
        if self.lifeCount < 4 {
            for life in 0...self.lifeCount-1 {
                self.livesArray[life].removeFromParent()
            }
            self.lifeCount+=1
            self.addLivesDisplay(num_lives: self.lifeCount)
        }
    }
    func carDidHitStar(car: SKSpriteNode, star: PowerupMosterTruck){
        self.playerIsInvincible = true
        bgAudio.removeFromParent()
        star.removeFromParent()
        player.becomeMonsterTruck()
        monsterTruckTimer = Timer.scheduledTimer(timeInterval: TimeInterval(GameTimers.MonsterTruck.rawValue), target: self, selector: #selector(self.becomeCar), userInfo: nil, repeats: false)
    }
    
    func becomeCar(){
        self.playerIsInvincible = false
        bgAudio.autoplayLooped = true;
        self.addChild(bgAudio)
        player.becomeCar()
        monsterTruckTimer.invalidate()
    }
    
    func carDidHitObstacle(car:Player, obj:SKSpriteNode){
        let name = obj.name
        switch  name! {
        case "pothole":
            car.spinOut()
            break
        case "ice":
            car.spinOut()
            break
        case "phone":
            obj.removeFromParent()
            if(textCount >= GameSettings.maxTextCount.rawValue){
                textCount = 0
                textTimer.invalidate()
            } else {
                showText(index: textCount)
                textTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.addTextMessage), userInfo: nil, repeats: true)
            }
            
            return
        default:
            print("do nothing")
        }
        car.recover(scene:self)
        loseLife()
        obj.removeFromParent()
    }
    
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
        car.recover(scene:self)
        loseLife()
       
        
    }
    
    func carDidHitCoin(car:SKSpriteNode, coin:SKSpriteNode){
        if preferences.bool(forKey: "sfx") == true && playerIsInvincible == false {
            self.run(SKAction.playSoundFileNamed("money.aiff", waitForCompletion: true))
        }
        self.money += (1 * powerUps.multiplier)
        preferences.setValue(preferences.value(forKey:"money") as! Int + 1, forKey: "money")
        preferences.synchronize()
        coin.removeFromParent()
    }
    
    func monsterTruckDidHitObstacle(car:SKSpriteNode, obj:SKSpriteNode){
        let explosion = SKEmitterNode(fileNamed: "Explosion")
        explosion?.position = obj.position
        self.addChild(explosion!)
        
        obj.removeFromParent()
        
        if preferences.bool(forKey: "sfx") == true {
            self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        }
        self.run(SKAction.wait(forDuration: 2)){
            explosion?.removeFromParent()
        }
    }
    
    
    // This function is to wrap around the screen
    // Is this dynamic enough?
    override func didSimulatePhysics() {
        self.player.position.x += xAcceleration * 50
        
        if !powerUps.wrap{
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
            print("current game speed is")
            print(gameSpeed)
        }else{
            bg.loopForever(duration: gameSpeed)
        }
    }
 
    
}
