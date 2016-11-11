//
//  PoliceCarClass.swift
//  DodgeThePotholes
//
//  Created by Jonathan Buie on 11/8/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import SpriteKit

class policeCar {
    
    
    /*
    
    var textureAtlas = SKTextureAtlas(named: "Police.atlas")
    var textureArray = [SKTexture]()
    
    init(){
        for i in 1...textureAtlas.textureNames.count{
            let name = "police_0\(i).png"
            textureArray.append(SKTexture(imageNamed: name))
        }
        
        super.init(texture: textureArray[0], color: UIColor.clear , size: CGSize(width: 175, height: 175))
        self.yScale = fabs(self.yScale) * -1
        self.zPosition = 1 
        initPhysicsBody()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initPhysicsBody() {
        self.physicsBody?.isDynamic = true
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle.rawValue // of alien category
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Car.rawValue // object that collides with alien
        self.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue // Not sure what this is doing... yet
    }
    
    // We will probably need a function that takes the duration as a parameter to adjust as the 
    // levels increase speed
    func move(dest: CGPoint) {
        let flash = SKAction.repeat(SKAction.animate(with: textureArray, timePerFrame: 0.3),
                                    count:5)
        let siren = SKAction.playSoundFileNamed("police_s.wav", waitForCompletion: false)
        /*let moveAction = SKAction.move(by: CGVector(dx:0,
                                                    dy: -2*UIScreen.main.bounds.size.height), duration: 6)*/
        let moveAction = SKAction.move(to: dest, duration: 3)
        let group = SKAction.group([flash,moveAction,siren])
        let removeAction = SKAction.removeFromParent()
        self.run(SKAction.sequence([group,removeAction]))
 
    }
    */
}
