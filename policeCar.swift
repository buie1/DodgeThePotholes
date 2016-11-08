//
//  PoliceCarClass.swift
//  DodgeThePotholes
//
//  Created by Jonathan Buie on 11/8/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import SpriteKit

class policeCar: SKSpriteNode{
    
    var textureAtlas = SKTextureAtlas(named: "police")
    var textureArray = [SKTexture]()
    
    init(){
        for i in 1...textureAtlas.textureNames.count{
            let name = "police_0\(i).png"
            textureArray.append(SKTexture(imageNamed: name))
        }
        
        super.init(texture: textureArray[0], color: UIColor.clear , size: CGSize(width: 175, height: 175))
        //self.yScale = fabs(self.yScale) * -1
        
        //self.begin()
                
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func begin() {
        let flash = SKAction.repeatForever(SKAction.animate(withNormalTextures: textureArray, timePerFrame: 1))
        self.run(flash)
    }
    
}
