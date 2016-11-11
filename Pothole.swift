//
//  Potholes.swift
//  DodgeThePotholes
//
//  Created by Peter Murphy on 11/8/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import SpriteKit
import GameplayKit

class Pothole: SKSpriteNode, ObstacleCreate {
    
    enum pothole: CGFloat {
        case low = -0.25
        case high = 0.25
    }
    
    init(size: CGSize, duration:TimeInterval){
        super.init(texture: SKTexture(imageNamed:"pothole1"), color: UIColor.clear, size: CGSize(width :40, height:40))
        generatePosition(size)
        initPhysicsBody()
        begin(size,duration)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func generatePosition(_ size:CGSize){
        let rand = GKRandomDistribution(lowestValue: Int(-size.width*pothole.low.rawValue) + Int(self.size.width/2),highestValue: Int(size.width*pothole.high.rawValue) - Int(self.size.width/2))
        self.position = CGPoint(x:CGFloat(rand.nextInt()),y:size.height/2 + self.size.height/2)
    }
    
    func initPhysicsBody(){
        self.physicsBody?.isDynamic = true
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle.rawValue // of alien category
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Car.rawValue // object that collides with alien
        self.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    
    func begin(_ size:CGSize, _ dur: TimeInterval){
        let moveAction = SKAction.moveBy(x: 0, y: -size.height/2 * CGFloat(1/dur), duration: dur)
        let removeAction = SKAction.removeFromParent()
        self.run(SKAction.sequence([moveAction,removeAction]))
        
    }
}
