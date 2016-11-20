//
//  Player.swift
//  DodgeThePotholes
//
//  Created by Jonathan Buie on 11/10/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import SpriteKit
class Player: SKSpriteNode, ObstacleCreate {
    
    var moveLeftTextureAtlas = SKTextureAtlas(named: "Car_Left")
    var moveLeftTextureArray = [SKTexture]()
    var moveRightTextureAtlas = SKTextureAtlas(named: "Car_Right")
    var moveRightTextureArray = [SKTexture]()
    
    init(size: CGSize){
        for i in 1...moveLeftTextureAtlas.textureNames.count{
            let name = "car_left_\(i)"
            moveLeftTextureArray.append(SKTexture(imageNamed: name))
        }
        for i in 1...moveRightTextureAtlas.textureNames.count{
            let name = "car_right_\(i)"
            moveRightTextureArray.append(SKTexture(imageNamed: name))
        }
        
        
        super.init(texture: SKTexture(imageNamed:"car"), color: UIColor.clear, size: CGSize(width : 125/2, height:125))
        generatePosition(size)
        initPhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func generatePosition(_ size:CGSize){
        self.position = CGPoint(x: 0, y: 3*self.size.height/2 - size.height/2)
        self.zPosition = 1
    }
    
    func initPhysicsBody(){
        self.physicsBody?.isDynamic = true
        //self.physicsBody = SKPhysicsBody(rectangleOf: self.size)

        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: self.size.width/2, y:self.size.height/2),
                                CGPoint(x: -self.size.width/2, y:self.size.height/2),
                                CGPoint(x: -self.size.width/2, y:0),
                                CGPoint(x: self.size.width/2, y: 0)])
        path.closeSubpath()
        self.physicsBody = SKPhysicsBody(polygonFrom: path)
        self.physicsBody?.categoryBitMask = PhysicsCategory.Car.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle.rawValue | PhysicsCategory.MoveableObstacle.rawValue |
            PhysicsCategory.Coin.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    
    func begin(_ size:CGSize, _ dur: TimeInterval){
        //Do nothing
    }
    
    
    // MARK: Move Left and Move right = Stretch goals. will need to create group actions with the a tiny duration to see the blinker
    func moveRight(){
        let flash = SKAction.repeat(SKAction.animate(with: moveRightTextureArray, timePerFrame: 0.2), count: 2)
        self.run(flash)
    }
    
    func moveLeft(){
        let flash = SKAction.repeat(SKAction.animate(with: moveLeftTextureArray, timePerFrame: 0.2), count: 2)
        self.run(flash)
    }
    
    func spinOut(){
        let group:SKAction
        //let spin = SKAction.rotate(byAngle: 360, duration: 1)
        let spin = SKAction.rotate(toAngle: 4*3.14, duration: 0.75, shortestUnitArc: false)
        let reset = SKAction.setTexture(SKTexture(imageNamed: "car"))
        if preferences.bool(forKey: "sfx") == true {
            let sound = SKAction.playSoundFileNamed("carskid.wav", waitForCompletion: false)
            group = SKAction.group([spin,sound])
        }else{
            group = spin
        }
        self.run(SKAction.sequence([group,reset]))
    }
    
    func recover(){
        
        let hide = SKAction.run {
            self.physicsBody?.categoryBitMask = PhysicsCategory.None.rawValue
            print("remove category bit mask")
        }
        //let flash = SKAction.fadeAlpha(by: 0.25, duration: 1)
        let flashAct = SKAction.sequence([SKAction.fadeOut(withDuration: 0.3),
                                       SKAction.fadeIn(withDuration: 0.3)])
        let flash = SKAction.repeat(flashAct, count: 4)
        let restore = SKAction.run {
            self.physicsBody?.categoryBitMask = PhysicsCategory.Car.rawValue
        }
        self.run(SKAction.sequence([hide,flash,restore]))
        
    }
}
