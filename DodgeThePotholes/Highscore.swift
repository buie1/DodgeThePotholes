//
//  Highscores.swift
//  DodgeThePotholes
//
//  Created by Colby Stanley on 11/20/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import SpriteKit
import FirebaseDatabase


class Highscore: SKScene {
    
    var highscoreTitleLabelNode:SKLabelNode!
    var highscoreLabelNode:SKLabelNode!
    var backNode:SKSpriteNode!
    var firebaseRef: FIRDatabaseReference!
    
    override func didMove(to view: SKView) {
        
        highscoreTitleLabelNode = self.childNode(withName: "highscoreTitleLabel") as! SKLabelNode!
        highscoreTitleLabelNode.fontName = "PressStart2p"
    
        highscoreLabelNode = self.childNode(withName: "highscoreLabel") as! SKLabelNode!
        highscoreLabelNode.fontName = "PressStart2p"
        highscoreLabelNode.text = "\(preferences.value(forKey: "highscore") as! Int)"

        backNode = self.childNode(withName: "BackButton") as! SKSpriteNode!
        print("---------------------------------\n FirebaseReference \n---------------------\n")
        
        firebaseRef = FIRDatabase.database().reference(fromURL: "https://dodge-the-potholes-55009884.firebaseio.com/Leaderboard")

        let leaderboardquery = firebaseRef.queryLimited(toFirst: 100).queryOrderedByValue()
        leaderboardquery.observe(.value, with: { snapshot in
            var myDict = snapshot.value as! NSDictionary
            print("\(myDict)")
        })
        //let userscore = ("cts1992", 20)
        //firebaseRef.child("1").setValue(userscore)

        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            
            let nodesArray = self.nodes(at: location)
            let transition = SKTransition.flipHorizontal(withDuration: 1.0)
            
            if nodesArray.first?.name == "BackButton"{
                let menuScene = SKScene(fileNamed: "MenuScene")
                menuScene?.scaleMode = .aspectFit
                self.view?.presentScene(menuScene!, transition: transition)
            }
        }
    }

}
