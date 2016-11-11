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

class Dog {
    
    /*
    
    override init(frameHeight: CGFloat, frameWidth: CGFloat){
        super.init(frameHeight: frameHeight, frameWidth: frameWidth)
        let thisObstacle = SKSpriteNode(imageNamed: "Shepherd_run_1.imageset") //creating dummy obstacle because some methods cannot read in 'self.obstacle'
        self.node = thisObstacle
        self.node.setScale(3)
        self.randomPosition = GKRandomDistribution(lowestValue: Int(frameWidth * positionRange.dog.low.rawValue) + Int(thisObstacle.size.width),highestValue: Int(frameWidth * positionRange.dog.high.rawValue) - Int(thisObstacle.size.width))
        self.position = CGFloat(self.randomPosition.nextInt())
        self.node.position = CGPoint(x: self.position, y:frameHeight/2 + thisObstacle.size.height)
        /*
        self.node.physicsBody = SKPhysicsBody(rectangleOf: thisObstacle.size)
        
        self.node.physicsBody?.isDynamic =  true
        self.node.physicsBody?.categoryBitMask = PhysicsCategory.MoveableObstacle.rawValue
        self.node.physicsBody?.contactTestBitMask = PhysicsCategory.Car.rawValue// | PhysicsCategory.Horn.rawValue
        self.node.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
        self.node.physicsBody?.usesPreciseCollisionDetection = true*/
        
        self.animationDuration = 6
        self.action = SKAction.move(to: CGPoint(x: self.position, y: -frameHeight/2 - thisObstacle.size.height), duration: self.animationDuration)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func runAnimation(){
        var textureArray = [SKTexture]()
        let picArray: [String] = ["Shepherd_run_1.imageset", "Shepherd_run_2.imageset", "Shepherd_run_3.imageset", "Shepherd_run_4.imageset", "Shepherd_run_5.imageset"]
        for pic in picArray {
            textureArray.append(SKTexture(imageNamed: pic))
        }
        let action = SKAction.animate(with: textureArray, timePerFrame: 0.1)
        self.node.run(SKAction.repeatForever(action))
    }
 */
}
