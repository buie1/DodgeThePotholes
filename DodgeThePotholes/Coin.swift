//
//  Coin.swift
//  DodgeThePotholes
//
//  Created by Jonathan Buie on 11/11/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import SpriteKit

class Coin: SKSpriteNode {
    
    // jab165 11/11
    // By inheriting SKSpriteNode, we inhert CustomStringConvertible (for description)
    // and Hashable... which allows us to use these in a SET (will we need sets?)
   /*
    override var hashValue: Int {
        return row*10 + column
    }
    
    override var description: String {
        return "dollar located at: (\(column),\(row))"
    }*/
    
    
    init(width:Int,height:Int){
        super.init(texture: SKTexture(imageNamed:"dollar"), color: UIColor.clear, size: CGSize(width :width/2, height:height/2))
        
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    static func==(lhs:Coin, rhs:Coin)->Bool {
        return lhs.column == rhs.column && lhs.row == rhs.row
    }
    */
    
    func initPhysicsBody(){
        self.physicsBody?.isDynamic = true
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.categoryBitMask = PhysicsCategory.Coin.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Car.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    
    
}
