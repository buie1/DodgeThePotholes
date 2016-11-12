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
    
    init(size: CGSize) {
        let text = SKTexture(imageNamed: "road_long")

        // MARK: We need a way to make this more dynamic
        
        super.init(texture: text, color: UIColor.clear, size: text.size())
        self.size = CGSize(width: size.width, height: 4*size.height)
        //let screenSize = UIScreen.main.bounds
        //self.size = CGSize(width: self.screenSize.width, height: self.screenSize.height)
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder) not yet implemented")
    }
    
    func start(duration: CGFloat){
        print("starting new level")
        let moveDown = SKAction.moveBy(x: 0.0, y: -frame.size.height/4, duration: TimeInterval(duration))
        let restart = SKAction.moveBy(x: 0.0, y: frame.size.height/4, duration: 0)
        let moveSeq = SKAction.sequence([moveDown, restart])
        //run(SKAction.repeatForever(moveSeq))
        self.removeAllActions()
        run(SKAction.repeat(moveSeq, count: 50))
    }
    
    func changeLevel(duration: CGFloat){
        let level = SKTexture(imageNamed: "ruralLevel")
        let levelTransition = SKTexture(imageNamed: "ruralLevelTransition")
        let moveDown = SKAction.moveBy(x: 0.0, y: -frame.size.height/4, duration: TimeInterval(duration))
        let restart = SKAction.moveBy(x: 0.0, y: frame.size.height/4, duration: 0)
        let moveSeq = SKAction.sequence([moveDown, restart])
        self.texture = levelTransition
        //run(SKAction.wait(forDuration: TimeInterval(duration)))
        //self.texture = level
        self.removeAllActions()
        run(SKAction.repeat(moveSeq, count: 1),
            completion: {
            self.texture = level
        }
        )
    }
    
    func loopForever(duration: CGFloat){
        let moveDown = SKAction.moveBy(x: 0.0, y: -frame.size.height/4, duration: TimeInterval(duration))
        let restart = SKAction.moveBy(x: 0.0, y: frame.size.height/4, duration: 0)
        let moveSeq = SKAction.sequence([moveDown, restart])
        self.removeAllActions()
        run(SKAction.repeatForever(moveSeq))
    }
}
