//
//  Dog.swift
//  DodgeThePotholes
//
//  Created by Peter Murphy on 11/8/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class Human: MoveableObstacle, ObstacleCreate {
    
    var textureAtlas = SKTextureAtlas(named: "old_man_walk")
    var textureArray = [SKTexture]()
    
    var orientation: CGFloat = 1
    
    init(size: CGSize, duration:TimeInterval){
        
        for i in 0...textureAtlas.textureNames.count-1{
            let name = "old_man_walk_\(i)"
            textureArray.append(SKTexture(imageNamed: name))
        }
        
        super.init(texture: SKTexture(imageNamed:"old_man_walk_0"), color: UIColor.clear, size: CGSize(width :60/2, height:60))
        self.name = "human"
        generatePosition(size)
        initPhysicsBody()
        
        
        begin(size,duration)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func generatePosition(_ size:CGSize){
        let rand = arc4random_uniform(2)
        if rand == 0{
            orientation = -1
        } else{
            orientation = 1
        }
        self.position = CGPoint(x: orientation*(size.width/2), y: size.height/2 + self.size.height)
        self.xScale = fabs(self.xScale) * orientation
        //self.position = CGPoint(x:CGFloat(rand.nextInt()),y:size.height/2 + self.size.height/2)
    }
    
    func initPhysicsBody(){
        self.physicsBody?.isDynamic = true
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.categoryBitMask = PhysicsCategory.MoveableObstacle.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Car.rawValue | PhysicsCategory.Horn.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    override func destroy(){
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.None.rawValue
        
        var group:SKAction
        textureArray.removeAll()
        for i in 0...textureAtlas.textureNames.count-1{
            let name = "old_man_dead_\(i)"
            textureArray.append(SKTexture(imageNamed: name))
        }
        let die = SKAction.animate(with: textureArray, timePerFrame: 0.1)
        
        if preferences.bool(forKey: "sfx") == true {
            let scream = SKAction.playSoundFileNamed("scream_in_pain.mp3", waitForCompletion: false)
            group = SKAction.group([die,scream])
        }else{
            group = die
        }
        
        self.run(group)
    }
    
    
    func begin(_ size:CGSize, _ dur: TimeInterval){
        
        let run = SKAction.repeat(SKAction.animate(with: textureArray, timePerFrame: 0.2), count: 5)
        let moveAction = SKAction.moveTo(y: -size.height - self.size.height, duration: dur)
        let runDir = SKAction.moveTo(x: orientation*(size.width/4), duration: dur*0.75)
        // Add barking sounds
        let runGroup = SKAction.group([run,runDir,moveAction])
        
        let removeAction = SKAction.removeFromParent()
        self.run(SKAction.sequence([runGroup,removeAction]))
        
    }
    
    override func runAway(_ Size:CGSize, _ dur: TimeInterval){
        self.xScale = -1*orientation
        textureArray.removeAll()
        for i in 0...textureAtlas.textureNames.count-1{
            let name = "old_man_jump_0\(i)"
            textureArray.append(SKTexture(imageNamed: name))
        }
        let scream = SKAction.playSoundFileNamed("oh_my_god.mp3", waitForCompletion: false)
        let runAway = SKAction.animate(with: textureArray, timePerFrame: 0.05)
        //let runAway = SKAction.repeat(SKAction.animate(with: textureArray, timePerFrame: 0.1), count: 10)
        let runDir = SKAction.moveTo(x:orientation*(Size.width/2 + self.size.width), duration: dur*0.25)
        let moveAction = SKAction.moveTo(y: -Size.height/2 - self.size.height, duration: dur/2)
        let runAction = SKAction.group([runAway,runDir,moveAction, scream])
        self.run(SKAction.sequence([runAction,removeNodeAction]))
        
    }
}
