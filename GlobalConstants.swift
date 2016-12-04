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
import Firebase

// MARK: Gameplay Constants

let bgTimeInterval = 10.0
let startGameSpeed = 2.0


//There is no way this is up to data.... stupid computer.


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
    case Multiplier         = 0x20
    case Wrap               = 0x40
    case OneUp              = 0x80
    //case Invincible         = UniqueID
    //case Jump               = UniqueID
    //case BlackIce           = UniqueID
    
}

enum GameSettings: Int {
    case MaxLives       = 4
    case BeginningLifeCount = 3
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
    case plant
}

enum dog: CGFloat {
    case low = -1
    case high = 1
    case height = 50
    case width = 51
}

enum pothole: CGFloat {
    case low = -0.25
    case high = 0.25
    case height = 65
    case width = 66
}

enum plant: CGFloat {
    case low = 0.4375
    case height = 100
    case width = 101
    case numPlantsMin = 0
    case numplantsMax = 10
}

enum human: CGFloat {
    //case low =
    //case high =
    case width = 40
    case height = 80
}

enum oneup: CGFloat {
    case width = 50
    case height = 51
}


// MARK: Protocols
protocol ObstacleCreate {
    func generatePosition(_ size:CGSize)
    func initPhysicsBody()
    func begin(_ size:CGSize, _ dur: TimeInterval)
}


// MARK: User Preferences Reference
let preferences = UserDefaults.standard


struct powerUpStructure {
    var multiplier = 1
    var wrap:Bool = false
}
var powerUps = powerUpStructure()


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
let flashAction = SKAction.repeat(flashAct, count: 8)
let removeNodeAction = SKAction.removeFromParent()

// MARK: Firebase info
let leaderboardquery = FIRDatabase.database().reference(fromURL: "https://dodge-the-potholes-55009884.firebaseio.com/Leaderboard")

// MARK: Store constants
let carCost = 2
let lifeCost = 5
let invincibilityUpgrade = 5000
