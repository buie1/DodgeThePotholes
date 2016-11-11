//
//  AudioScene.swift
//  DodgeThePotholes
//
//  Created by Colby Stanley on 11/8/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//  
/** This scene has three buttons: sfx, music, and back.
    Upon selecting the sfx button it is either enabled or disabled
    depending on what is currently stored as the user default (same for the music button).
    The button is changed from on to off or vice versa when pressed
    for both enabling/disabling music and sfx.
*/

import SpriteKit

var sfxToggleNode: SKSpriteNode!
var musicToggleNode: SKSpriteNode!
var backAudioNode: SKSpriteNode!

var sfx: Bool!
var music: Bool!

class AudioScene: SKScene{
    
    override func didMove(to view: SKView) {
        sfxToggleNode = self.childNode(withName: "SFXButton") as! SKSpriteNode!
        musicToggleNode = self.childNode(withName: "MusicButton") as! SKSpriteNode!
        backAudioNode = self.childNode(withName: "BackButton") as! SKSpriteNode!
        //Get user's saved defaults for sfx and music and set sfx and music equal to these here
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            
            let nodesArray = self.nodes(at: location)
            let transition = SKTransition.flipHorizontal(withDuration: 1.0)
            let node = nodesArray.first as? SKSpriteNode
            
            if nodesArray.first?.name == "SFXButton" {
                if(node?.texture?.description == SKTexture(imageNamed: "onButton").description){
                    node?.texture = SKTexture(imageNamed: "offButton")
                    sfx = false
                }
                else{
                    node?.texture = SKTexture(imageNamed: "onButton")
                    sfx = true
                }
                updateSoundDefaults()
            }
            else if nodesArray.first?.name == "MusicButton" {
                if(node?.texture?.description == SKTexture(imageNamed: "music").description){
                    node?.texture = SKTexture(imageNamed: "music_pressed")
                    music = false
                }
                else{
                    node?.texture = SKTexture(imageNamed: "music")
                    music = true
                }
                updateSoundDefaults()
            }
            
            //Back Button is pressed
            else if nodesArray.first?.name == "BackButton"{
                let settingsScene = SKScene(fileNamed: "SettingsScene")
                settingsScene?.scaleMode = .aspectFit
                self.view?.presentScene(settingsScene!, transition: transition)
            }
        }
    }
    
    func updateSoundDefaults(){
        //Updates user defaults for sound that are persisted
        //If no file exists, a file is created and the defaults are stored
        
    }
}