//
//  MultiplierPowerUp.swift
//  DodgeThePotholes
//
//  Created by Jonathan Buie on 12/1/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import SpriteKit
import GameplayKit

class MultiplierPowerUp: SKSpriteNode {
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize){
        
        super.init(texture: texture, color: color, size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getValue(){
        
    }
}
