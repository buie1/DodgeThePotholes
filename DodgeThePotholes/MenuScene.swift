//
//  MenuScene.swift
//  DodgeThePotholes
//
//  Created by Jonathan Buie on 11/7/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    var newGameButtonNode:SKSpriteNode!
    var settingsButtonNode:SKSpriteNode!
    var gameCenterButtonNode:SKSpriteNode!

    override func didMove(to view: SKView) {
        
        newGameButtonNode = self.childNode(withName: "NewGameButton") as! SKSpriteNode!
        settingsButtonNode = self.childNode(withName: "SettingsButton") as! SKSpriteNode!
        gameCenterButtonNode = self.childNode(withName: "GameCenterButton") as! SKSpriteNode!
        
        
    }
    
}
