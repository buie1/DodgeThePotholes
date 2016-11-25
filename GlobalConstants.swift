//
//  GlobalConstants.swift
//  DodgeThePotholes
//
//  Created by Jonathan Buie on 11/8/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit


// MARK: Gameplay Constants

let bgTimeInterval = 10.0
let startGameSpeed = 2.0



// MARK: Physics Categories
// update when adding new physics categories for the physics bodies


enum PhysicsCategory:UInt32 {
    case None               = 0
    case All                = 0xFFFFFFFF
    case Car                = 0x1
    case Coin               = 0x2
    case Horn               = 0x4
    case Obstacle           = 0x8
    case MoveableObstacle   = 0x10
    //case Invincible         = UniqueID
    //case Jump               = UniqueID
    //case BlackIce           = UniqueID
    
}

// MARK: Ranges for Object generation
enum coneRange: CGFloat {
    case low = -0.375
    case high = 0.25
}

enum obstacleType {
    case pothole
    case trafficCone
    case dog
}

enum dog: CGFloat {
    case low = -1
    case high = 1
}

enum pothole: CGFloat {
    case low = -0.25
    case high = 0.25
}



// MARK: Protocols
protocol ObstacleCreate {
    func generatePosition(_ size:CGSize)
    func initPhysicsBody()
    func begin(_ size:CGSize, _ dur: TimeInterval)
}


// MARK: User Preferences Reference
let preferences = UserDefaults.standard


// MARK: Animations


func pauseFunction(t:TimeInterval)->SKAction{
    return SKAction.wait(forDuration: t)
}


func flyInFunction(t:TimeInterval)->SKAction{
    let flyIn = SKAction.moveTo(x: 0, duration: t)
    let pauseForAlert = SKAction.wait(forDuration: t)
    let flyOut = SKAction.moveTo(x: -1000, duration: t)
    return SKAction.sequence([flyIn,pauseForAlert,flyOut])
}

let flashAct = SKAction.sequence([SKAction.fadeOut(withDuration: 0.3),
                                  SKAction.fadeIn(withDuration: 0.3)])
let flashAction = SKAction.repeat(flashAct, count: 4)
let removeNodeAction = SKAction.removeFromParent()



