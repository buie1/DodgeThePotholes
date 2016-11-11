//
//  MenuScene.swift
//  DodgeThePotholes
//
//  Created by Jonathan Buie on 11/7/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import SpriteKit

class GameOver: SKScene {
    
    var score:Int = 0
    var gameOverLabelNode:SKLabelNode!
    var scoreLabelNode:SKLabelNode!
    var newGameButtonNode:SKSpriteNode!
    
    override func didMove(to view: SKView) {
        
        
        gameOverLabelNode = self.childNode(withName: "gameOverLabel") as! SKLabelNode!
        gameOverLabelNode.fontName = "PressStart2p"
        
        scoreLabelNode = self.childNode(withName: "scoreLabel") as! SKLabelNode!
        scoreLabelNode.fontName = "PressStart2p"
        scoreLabelNode.text = "\(score)"
        
        newGameButtonNode = self.childNode(withName: "newGameButton") as! SKSpriteNode
        newGameButtonNode.texture = SKTexture(imageNamed: "newGameButton")

        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            
            let nodesArray = self.nodes(at: location)
            let transition = SKTransition.flipHorizontal(withDuration: 1.0)
            
            if nodesArray.first?.name == "NewGameButton" {
                self.run(SKAction.playSoundFileNamed("start.wav", waitForCompletion: false))
                let gameScene = GameScene(size: self.size)
                gameScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                self.view?.presentScene(gameScene, transition: transition)
            }
        }
    }
}
