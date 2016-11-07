//
//  roadBackground.swift
//  SpaceGame
//
//  Created by Jonathan Buie on 11/7/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import UIKit
import SpriteKit


class roadBackground: SKSpriteNode {
    
    init() {
        let text = SKTexture(imageNamed: "road_long")

        // MARK: We need a way to make this more dynamic
        
        super.init(texture: text, color: UIColor.clear, size: text.size())
        self.size = CGSize(width: 2*frame.size.width+100, height: 4*frame.size.height)
        //let screenSize = UIScreen.main.bounds
        //self.size = CGSize(width: screenSize.width, height: screenSize.height)
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder) not yet implemented")
    }
    
    func start(){
        let moveDown = SKAction.moveBy(x: 0.0, y: -frame.size.height/4, duration: 1.5)
        let restart = SKAction.moveBy(x: 0.0, y: frame.size.height/4, duration: 0)
        let moveSeq = SKAction.sequence([moveDown, restart])
        run(SKAction.repeatForever(moveSeq))
    }
}
