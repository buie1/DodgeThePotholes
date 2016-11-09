//
//  PoliceCarClass.swift
//  DodgeThePotholes
//
//  Created by Jonathan Buie on 11/8/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import SpriteKit

class policeCar: SKSpriteNode{
    
    var textureAtlas = SKTextureAtlas(named: "Police.atlas")
    var textureArray = [SKTexture]()
    
    init(){
        for i in 1...textureAtlas.textureNames.count{
            let name = "police_0\(i).png"
            textureArray.append(SKTexture(imageNamed: name))
        }
        
        super.init(texture: textureArray[0], color: UIColor.clear , size: CGSize(width: 175, height: 175))
        self.yScale = fabs(self.yScale) * -1
        self.position = CGPoint(x: 0, y: UIScreen.main.bounds.size.height/2+self.size.height/2)
        
        self.begin()
                
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func begin() {
        let flash = SKAction.repeat(SKAction.animate(with: textureArray, timePerFrame: 0.3),
                                    count:5)
        let moveAction = SKAction.move(by: CGVector(dx:0,
                                                    dy: -2*UIScreen.main.bounds.size.height), duration: 3.0)
        let group = SKAction.group([flash,moveAction])
        let removeAction = SKAction.removeFromParent()
        self.run(SKAction.sequence([group,removeAction]))
 
    }
    
}
