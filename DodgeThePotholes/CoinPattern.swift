//
//  CoinPattern.swift
//  DodgeThePotholes
//
//  Created by Jonathan Buie on 11/11/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import SpriteKit
import GameplayKit




class CoinPattern:SKNode {
    
    var patterns = ["pattern1","pattern2"]
    var NumColumns:Int!
    var NumRows:Int!
    var size:CGSize
    
    // This will need to be dynamic
    let tileWidth = 32
    let tileHeight = 32
    // This will need to be read from the json file
    fileprivate var coins:Array2D<Coin>!

    init(scene: SKScene, duration:TimeInterval){
        //1. Chose a random pattern to generate
        
        patterns = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: patterns) as! [String]
        
        //2. load json file and set initial values
        let dictionary = Dictionary<String,Any>.loadJSONFromBundle(filename: patterns[0])
        let array = dictionary?["tiles"] as? [[Int]]
        NumColumns = dictionary?["numCols"] as? Int
        print("number of cols: \(NumColumns)")
        NumRows = dictionary?["numRows"] as? Int
        print("number of rows: \(NumRows)")
        coins = Array2D<Coin>(columns: NumColumns, rows: NumRows)
        self.size = CGSize(width: tileWidth*NumColumns, height: tileHeight*NumRows)
        //3. Generate pattern
        super.init()
        let rand = GKRandomDistribution(lowestValue: Int(-size.width/2) + Int(self.size.width/2),highestValue: Int(size.width/2) - Int(self.size.width/2))
        let randN = CGFloat(rand.nextInt())
        for (row,array) in (array?.enumerated())!{
            let currRow = NumRows - row - 1 // Start indexing at 0 not 1
            for (col, value) in array.enumerated(){
                if value == 1 {
                    // Add a Coin :)
                    coins[col,currRow] = Coin(width: tileWidth, height: tileHeight)
                    coins[col,currRow]?.position = pointFor(column: col, row: currRow,
                                                            random:randN, size:scene.size)
                    coins[col,currRow]?.begin(tileHeight: tileHeight, row: row, size:scene.size, pattern:self.size, dur:duration)

                    scene.addChild(coins[col,currRow]!)
                }
            }
        }
        //addCoins(scene:scene,duration:duration)
        //generatePosition(scene.size)
        //begin(scene.size,duration)
    }
    
    func addCoins(scene:SKScene, duration:TimeInterval){
        //self.position = CGPoint(x:CGFloat(rand.nextInt()),y:size.height/2 + self.size.height/2)
        let rand = GKRandomDistribution(lowestValue: Int(-size.width/2) + Int(self.size.width/2),highestValue: Int(size.width/2) - Int(self.size.width/2))
        let randN = CGFloat(rand.nextInt())
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                let currCoin = self.coinAt(column: column, row: row)
                if currCoin != nil {
                    //let moneyNode = SKSpriteNode(imageNamed: "dollar")
                    //let moneyNode = Coin(width: tileWidth, height: tileHeight)
                    //moneyNode.position = pointFor(column: column, row: row, random:randN, size:scene.size)
                    //moLayer.addChild(tileNode)
                    scene.addChild(currCoin!)
                    currCoin?.position  = pointFor(column: column, row: row, random:randN, size:scene.size)
                    currCoin?.begin(tileHeight: tileHeight, row: row, size:scene.size, pattern:self.size, dur:duration)
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    func generatePosition(_ size:CGSize){
        let rand = GKRandomDistribution(lowestValue: Int(-size.width/2) + Int(self.size.width/2),highestValue: Int(size.width/2) - Int(self.size.width/2))
        self.position = CGPoint(x:CGFloat(rand.nextInt()),y:size.height/2 + self.size.height/2)
    }*/
    
    
    func coinAt(column: Int, row: Int) -> Coin? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return coins[column, row]
    }

    
    func pointFor(column:Int, row:Int, random:CGFloat, size:CGSize)->CGPoint {
        let xPos = Int(random) + column * tileWidth + tileWidth/2
        let y =  row * tileHeight + tileHeight/2
        let yPos = Int(size.height/2) + Int(self.size.height/2) + y
        return CGPoint(x: xPos,y: yPos)
    }
    
    /*
    func begin(_ size:CGSize, _ dur: TimeInterval){
        let moveAction = SKAction.moveTo(y: -size.height/2 - self.size.height, duration: dur)
        let removeAction = SKAction.removeFromParent()
        self.run(SKAction.sequence([moveAction,removeAction]))
    }*/
    
}
