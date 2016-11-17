//
//  ConePattern.swift
//  DodgeThePotholes
//
//  Created by Jonathan Buie on 11/11/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import SpriteKit
import GameplayKit




class ConePattern {
    
    var patterns = ["cone_pattern1","cone_pattern2"]
    var minRows = 9 // Hardcoded value. No pattern will be less that 9 rows, yet....
    var NumColumns:Int!
    var NumRows:Int!
    var size:CGSize
    
    // This will need to be dynamic
    let tileWidth = 40
    let tileHeight = 40
    // This will need to be read from the json file
    fileprivate var cones:Array2D<Cone>!

    init(scene: SKScene, duration:TimeInterval){
        //1. Chose a random pattern to generate
        
        patterns = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: patterns) as! [String]
        
        //2. load json file and set initial values
        let dictionary = Dictionary<String,Any>.loadJSONFromBundle(filename: patterns[0])
        let array = dictionary?["tiles"] as? [[Int]]
        NumColumns = dictionary?["numCols"] as? Int
        NumRows = dictionary?["numRows"] as? Int
        cones = Array2D<Cone>(columns: NumColumns, rows: NumRows)
        self.size = CGSize(width: tileWidth*NumColumns, height: tileHeight*NumRows)
        //3. Generate pattern
        //super.init()
        let rand = GKRandomDistribution(lowestValue: Int(scene.size.width*coneRange.low.rawValue) + Int(self.size.width/2),
                                        highestValue: Int(scene.size.width*coneRange.high.rawValue) - Int(self.size.width/2))
        let randN = CGFloat(rand.nextInt())
        print("random pt for cone position  = \(randN)")
        for (row,array) in (array?.enumerated())!{
            let currRow = NumRows - row - 1 // Start indexing at 0 not 1
            for (col, value) in array.enumerated(){
                if value == 1 {
                    // Add a Cone :)
                    cones[col,currRow] = Cone(width: tileWidth, height: tileHeight)
                    cones[col,currRow]?.position = pointFor(column: col, row: currRow,
                                                            random:randN, size:scene.size)
                    cones[col,currRow]?.begin(tileHeight: tileHeight, row: row, size:scene.size, pattern:self.size, dur:duration*Double(NumRows/minRows))

                    scene.addChild(cones[col,currRow]!)
                }
            }
        }
    }
    
    func addCones(scene:SKScene, duration:TimeInterval){
        let rand = GKRandomDistribution(lowestValue: Int(-size.width/2) + Int(self.size.width/2),highestValue: Int(size.width/2) - Int(self.size.width/2))
        let randN = CGFloat(rand.nextInt())
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                let currCone = self.coneAt(column: column, row: row)
                if currCone != nil {
                    scene.addChild(currCone!)
                    currCone?.position  = pointFor(column: column, row: row, random:randN, size:scene.size)
                    currCone?.begin(tileHeight: tileHeight, row: row, size:scene.size, pattern:self.size, dur:duration)
                }
            }
        }
    }
    
    
    func coneAt(column: Int, row: Int) -> Cone? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return cones[column, row]
    }

    
    func pointFor(column:Int, row:Int, random:CGFloat, size:CGSize)->CGPoint {
        let xPos = Int(random) + column * tileWidth + tileWidth/2
        let y =  row * tileHeight + tileHeight/2
        let yPos = Int(size.height/2) + Int(self.size.height/2) + y
        return CGPoint(x: xPos,y: yPos)
    }
    
}
