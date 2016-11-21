//
//  PoliceCarClass.swift
//  DodgeThePotholes
//
//  Created by Jonathan Buie on 11/8/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import SpriteKit
import GameplayKit

class policeCar: SKSpriteNode, ObstacleCreate {
    
    var textureAtlas = SKTextureAtlas(named: "Police")
    var textureArray = [SKTexture]()
    
    init(size: CGSize, duration:TimeInterval){
        for i in 1...textureAtlas.textureNames.count{
            let name = "police_0\(i)"
            textureArray.append(SKTexture(imageNamed: name))
        }
        
        super.init(texture: textureArray[0], color: UIColor.clear , size: CGSize(width: 125/2, height: 125))
        self.yScale = fabs(self.yScale) * -1
        self.zPosition = 1
        self.name = "police"
        initPhysicsBody()
        generatePosition(size)
        begin(size, duration)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func generatePosition(_ size:CGSize){
        let randomPolicePosition = GKRandomDistribution(lowestValue: Int(-size.width/4) + Int(self.size.width/2),
                                                        highestValue: Int(-self.size.width/2))
        let position = CGFloat(randomPolicePosition.nextInt())
        self.position = CGPoint(x:position, y: size.height/2 + self.size.height/2)
        
    }

    
    func initPhysicsBody() {
        self.physicsBody?.isDynamic = true
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Car.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
        self.physicsBody?.usesPreciseCollisionDetection = true

    }
    
    func begin(_ size: CGSize, _ dur: TimeInterval) {
        
        let flash = SKAction.repeat(SKAction.animate(with: textureArray, timePerFrame: 0.3), count: 5)
        let siren = SKAction.playSoundFileNamed("police_s.wav", waitForCompletion: false)
        let moveAction = SKAction.move(to: CGPoint(x:self.position.x, y:-size.height/2 - self.size.height), duration: dur)
        let group = SKAction.group([flash,moveAction,siren])
        let removeAction = SKAction.removeFromParent()
        self.run(SKAction.sequence([group,removeAction]))
    }
    
}
