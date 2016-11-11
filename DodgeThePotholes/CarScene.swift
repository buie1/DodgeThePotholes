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

var car1Node: SKSpriteNode!
var car2Node: SKSpriteNode!
var car3Node: SKSpriteNode!
var car4Node: SKSpriteNode!
var backCarNode: SKSpriteNode!

var currentCar: String!

class CarScene: SKScene{
    
    override func didMove(to view: SKView) {
        car1Node = self.childNode(withName: "Car1") as! SKSpriteNode!
        car2Node = self.childNode(withName: "Car2") as! SKSpriteNode!
        car3Node = self.childNode(withName: "Car3") as! SKSpriteNode!
        car4Node = self.childNode(withName: "Car4") as! SKSpriteNode!
        backCarNode = self.childNode(withName: "BackButton") as! SKSpriteNode!
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            
            let nodesArray = self.nodes(at: location)
            let transition = SKTransition.flipHorizontal(withDuration: 1.0)
            
            if nodesArray.first?.name == "Car1"{
                currentCar = "Car1"
                preferences.setValue(currentCar, forKey: "car")
                preferences.synchronize()
            }
            else if nodesArray.first?.name == "Car2"{
                currentCar = "Car2"
                preferences.setValue(currentCar, forKey: "car")
                preferences.synchronize()
            }
            else if nodesArray.first?.name == "Car3"{
                currentCar = "Car3"
                preferences.setValue(currentCar, forKey: "car")
                preferences.synchronize()
            }
            else if nodesArray.first?.name == "Car4"{
                currentCar = "Car4"
                preferences.setValue(currentCar, forKey: "car")
                preferences.synchronize()
            }
            let settingsScene = SKScene(fileNamed: "SettingsScene")
            settingsScene?.scaleMode = .aspectFit
            self.view?.presentScene(settingsScene!, transition: transition)
            
        }
    }
    
}
