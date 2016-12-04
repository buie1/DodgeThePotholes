//
//  ShopScene.swift
//  DodgeThePotholes
//
//  Created by Colby Stanley on 12/3/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//

import SpriteKit


class ShopScene: SKScene, Alerts{
    
    var shopLabelNode:SKLabelNode!
    var moneyLabelNode:SKLabelNode!
    var lifeCostLabelNode:SKLabelNode!
    var carCostLabelNode:SKLabelNode!
    
    var buyNewCar:SKSpriteNode!
    var carBackground:SKSpriteNode!
    var buyLife:SKSpriteNode!
    var lifeBackground:SKSpriteNode!
    var backButton:SKSpriteNode!
    
    
    override func didMove(to view: SKView) {
        shopLabelNode = self.childNode(withName: "ShopLabel") as! SKLabelNode!
        shopLabelNode.fontName = "PressStart2p"
        shopLabelNode.text = "Shop"
        
        moneyLabelNode = self.childNode(withName: "MoneyLabel") as! SKLabelNode!
        moneyLabelNode.fontName = "PressStart2p"
        moneyLabelNode.text = "Money: $ \(preferences.value(forKey: "money")!)"
        
        carCostLabelNode = self.childNode(withName: "CarCost") as! SKLabelNode!
        carCostLabelNode.fontName = "PressStart2p"
        carCostLabelNode.text = " $ \(carCost)"
        
        lifeCostLabelNode = self.childNode(withName: "LifeCost") as! SKLabelNode!
        lifeCostLabelNode.fontName = "PressStart2p"
        lifeCostLabelNode.text = " $ \(lifeCost)"
        
        backButton = self.childNode(withName: "BackButton") as! SKSpriteNode!
        
        buyNewCar = self.childNode(withName: "PurchaseCar") as! SKSpriteNode!
        updateCarTexture()
        carBackground = self.childNode(withName: "CarBackground") as! SKSpriteNode!
        
        buyLife = self.childNode(withName: "PurchaseLife") as! SKSpriteNode!
        lifeBackground = self.childNode(withName: "LifeBackground") as! SKSpriteNode!
        
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
            else if nodesArray.first?.name == "PurchaseCar" || nodesArray.first?.name == "CarBackground" {
                if(carCost > preferences.value(forKey: "money") as! Int){
                    //insufficient funds: Call insufficient funds alert
                    insufficientFunds(title: "Insufficient Funds!!!", message: "This item costs $\(carCost)")
                }
                else{
                    var car = String()
                    if(preferences.value(forKey: "redcar") as! Bool == false){
                        car = "redcar"
                    }
                    else{
                        car = "greencar"
                    }
                    if(preferences.value(forKey: car) as! Bool == false){
                        doPurchase(title: "Purchase Car", message: "Do you want to buy this car?", cost: carCost, item: car)
                    }
                    else{
                        //already purchased alert
                        alreadyPurchased()
                    }
                }
                updateCarTexture()
            }
            else if nodesArray.first?.name == "PurchaseLife" || nodesArray.first?.name == "LifeBackground"{
                if(lifeCost > preferences.value(forKey: "money") as! Int){
                    //insufficient funds: Call insufficient funds alert
                    insufficientFunds(title: "Insufficient Funds!!!", message: "This item costs $\(lifeCost)")
                }
                else{
                    if(preferences.value(forKey: "life") as! Bool == false){
                        doPurchase(title: "Purchase Extra Life", message: "Do you want to purchase an extra life?", cost: carCost, item: "life")
                    }
                    else{
                        //already purchased alert
                        alreadyPurchased()
                    }
                }
            }
            moneyLabelNode.text = "Money: $ \(preferences.value(forKey: "money")!)"
        }
    }
    
    func updateCarTexture(){
        if(preferences.value(forKey: "redcar") as! Bool == false){
            buyNewCar.texture = SKTexture(imageNamed: "car2")
        }
        else{
            buyNewCar.texture = SKTexture(imageNamed: "car3")
        }
    }
}
