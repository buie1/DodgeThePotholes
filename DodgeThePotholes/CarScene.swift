//
//  CarScene.swift
//  DodgeThePotholes
//
//  Created by Colby Stanley on 11/8/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

/** This scene contains four car options to select from and
    a back button for returning to the Settings Scene.
 */

import SpriteKit

var selectCarLabelNode: SKLabelNode!
var car1Node: SKSpriteNode!
var car2Node: SKSpriteNode!
var car3Node: SKSpriteNode!

var backCarNode: SKSpriteNode!

var currentCar: String!

class CarScene: SKScene{
    
    override func didMove(to view: SKView) {
        selectCarLabelNode = self.childNode(withName: "CarLabel") as! SKLabelNode!
        selectCarLabelNode.fontName = "PressStart2P"
        
        car1Node = self.childNode(withName: "Car1") as! SKSpriteNode!
        car2Node = self.childNode(withName: "Car2") as! SKSpriteNode!
        car3Node = self.childNode(withName: "Car3") as! SKSpriteNode!
    
        backCarNode = self.childNode(withName: "BackButton") as! SKSpriteNode!
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            
            let nodesArray = self.nodes(at: location)
            let transition = SKTransition.flipHorizontal(withDuration: 1.0)
            
            if nodesArray.first?.name == "Car1"{
                currentCar = "car1"
                preferences.setValue(currentCar, forKey: "car")
                preferences.synchronize()
            }
            else if nodesArray.first?.name == "Car2"{
                currentCar = "car2"
                preferences.setValue(currentCar, forKey: "car")
                preferences.synchronize()
            }
            else if nodesArray.first?.name == "Car3"{
                currentCar = "car3"
                preferences.setValue(currentCar, forKey: "car")
                preferences.synchronize()
            }
            let settingsScene = SKScene(fileNamed: "SettingsScene")
            settingsScene?.scaleMode = .aspectFit
            self.view?.presentScene(settingsScene!, transition: transition)
            
        }
    }
    
}
