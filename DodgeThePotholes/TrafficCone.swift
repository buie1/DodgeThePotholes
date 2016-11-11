//
//  TrafficCone.swift
//  DodgeThePotholes
//
//  Created by Peter Murphy on 11/8/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class TrafficCone {
    
    /*
    
    /*override init(frameHeight: CGFloat, frameWidth: CGFloat){
        super.init(frameHeight: frameHeight, frameWidth: frameWidth)
        let thisObstacle = SKSpriteNode(imageNamed: "traffic_cone.png") //creating dummy obstacle because some methods cannot read in 'self.obstacle'
        self.node = thisObstacle
        self.randomPosition = GKRandomDistribution(lowestValue: Int(frameWidth * positionRange.trafficCone.low.rawValue) + Int(thisObstacle.size.width),highestValue: Int(frameWidth * positionRange.trafficCone.high.rawValue) - Int(thisObstacle.size.width))
        self.position = CGFloat(self.randomPosition.nextInt())
        self.node.position = CGPoint(x: self.position, y:frameHeight/2 + thisObstacle.size.height)
        self.node.physicsBody = SKPhysicsBody(rectangleOf: thisObstacle.size)
        
        self.node.physicsBody?.isDynamic =  true
        self.node.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle.rawValue
        self.node.physicsBody?.contactTestBitMask = PhysicsCategory.Car.rawValue
        self.node.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
        self.node.physicsBody?.usesPreciseCollisionDetection = true

        self.animationDuration = 6
        self.action = SKAction.move(to: CGPoint(x: self.position, y: -frameHeight/2 - thisObstacle.size.height), duration: self.animationDuration)
    }*/
    
    init(){
        super.init(im: "traffic_cone.png")
        randomPosition = GKRandomDistribution(lowestValue: Int(frameWidth * positionRange.trafficCone.low.rawValue) + Int(self.size.width),highestValue: Int(frameWidth * positionRange.trafficCone.high.rawValue) - Int(self.size.width))
        self.position = CGFloat(randomPosition.nextInt())
        initPhysicsBody()
        begin()
    }
    
    override func initPhysicsBody() {
        self.physicsBody?.isDynamic =  true
        self.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Car.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    func begin(){
        let animationDuration = 6
        self.action = SKAction.move(to: CGPoint(x: self.position, y: -frameHeight/2 - self.size.height), duration: self.animationDuration)
    }
    */
}
