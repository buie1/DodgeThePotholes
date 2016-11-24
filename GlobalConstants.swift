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
    case high = 0.375
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

let pauseForObstacles = SKAction.wait(forDuration: 6)


