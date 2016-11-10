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
let photonTorpedoCategory:UInt32 = 0x1 << 0
enum obstacleBitmasks: UInt32 {
    case none = 0x0
    case generic = 0x1
    case torpedo = 0x2
}*/

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
