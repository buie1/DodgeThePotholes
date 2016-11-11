//
//  Player.swift
//  DodgeThePotholes
//
//  Created by Jonathan Buie on 11/10/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import SpriteKit
class Player: SKSpriteNode, ObstacleCreate {
    
    enum pothole: CGFloat {
        case low = -0.25
        case high = 0.25
    }
    
    init(size: CGSize, duration:TimeInterval){
        super.init(texture: SKTexture(imageNamed:"car1"), color: UIColor.clear, size: CGSize(width :40, height:40))
        generatePosition(size)
        initPhysicsBody()
        begin(size,duration)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func generatePosition(_ size:CGSize){
        self.position = CGPoint(x: 0, y: -1*self.size.height/2 - 500)
    }
    
    func initPhysicsBody(){
        self.physicsBody?.isDynamic = true
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.categoryBitMask = PhysicsCategory.Car.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle.rawValue | PhysicsCategory.MoveableObstacle.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    
    func begin(_ size:CGSize, _ dur: TimeInterval){
        //Do nothing
    }
}
