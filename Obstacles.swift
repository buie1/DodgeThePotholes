//
//  Obstacles.swift
//  DodgeThePotholes
//
//  Created by Peter Murphy on 11/8/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import SpriteKit
import GameplayKit


class Obstacle {
    var node: SKSpriteNode!
    var randomPosition: GKRandomDistribution!
    var position: CGFloat!
    var animationDuration: TimeInterval!
    var action: SKAction!
    
    //default to pothole
    init(frameHeight: CGFloat, frameWidth: CGFloat){
        let thisObstacle = SKSpriteNode(imageNamed: "hole1.png") //creating dummy obstacle because some methods cannot read in 'self.obstacle'
        self.node = thisObstacle
        self.randomPosition = GKRandomDistribution(lowestValue: -414 + Int(thisObstacle.size.width),highestValue: 414 - Int(thisObstacle.size.width))
        self.position = CGFloat(self.randomPosition.nextInt())
        self.node.position = CGPoint(x: self.position, y:frameHeight/2 + thisObstacle.size.height)
        /*
        self.node.physicsBody = SKPhysicsBody(rectangleOf: thisObstacle.size)
        
        self.node.physicsBody?.isDynamic =  true
        self.node.physicsBody?.categoryBitMask = PhysicsCategor
        self.node.physicsBody?.contactTestBitMask = 0x1 << 0
        self.node.physicsBody?.collisionBitMask = 0
        */
        self.animationDuration = 6
        self.action = SKAction.move(to: CGPoint(x: self.position, y: -frameHeight/2 - thisObstacle.size.height), duration: self.animationDuration)
    }
    
}
