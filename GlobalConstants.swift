//
//  GlobalConstants.swift
//  DodgeThePotholes
//
//  Created by Jonathan Buie on 11/8/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import Foundation
import UIKit



// MARK: Physics Categories
/*let alienCategory:UInt32 = 0x1 << 1
enum obstacleBitmasks: UInt32 {
    case none = 0x0
    case generic = 0x1
    case torpedo = 0x2
}*/

// MARK: Physics Categories
// update when adding new physics categories for the physics bodies

let photonTorpedoCategory:UInt32 = 0x100

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
var previousHighscore = 0
