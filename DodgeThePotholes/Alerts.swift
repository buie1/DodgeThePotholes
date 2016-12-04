//
//  Alerts.swift
//  DodgeThePotholes
//
//  Created by Colby Stanley on 12/1/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//  Found at: http://stackoverflow.com/questions/39557344/swift-spritekit-how-to-present-alert-view-in-gamescene

import SpriteKit

protocol Alerts { }
extension Alerts where Self: GameOverScene {
    
    func showAlert(title: String, message: String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
            print(alertController.textFields?.first?.text! ?? "scrub")
            let indexStartOfText = alertController.textFields?.first?.text!.index((alertController.textFields?.first?.text!.startIndex)!, offsetBy: 3)
            let first_three = alertController.textFields?.first?.text!.substring(to: indexStartOfText!)
            self.submissionName = first_three! + "," + UIDevice.current.identifierForVendor!.uuidString
            leaderboardquery.child(self.submissionName).setValue(preferences.value(forKey: "highscore"))
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in}
        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        
        self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func doPurchase(title: String, message: String, cost: Int){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField()
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            if(cost > preferences.value(forKey: "money") as! Int){
                //insufficient funds: Call insufficient funds alert
                self.insufficientFunds(title: "Insufficient Funds!!!", message: "This item costs $\(cost)")
            }
            else{
                //update money
                preferences.set(preferences.value(forKey: "money") as! Int - cost, forKey: "money")
                //update unlocked items
            }
        }
        let noAction = UIAlertAction(title: "No", style: .cancel){ _ in}
        
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func insufficientFunds(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField()
        
        let okAction = UIAlertAction(title: "Ok", style: .cancel){ _ in}
        alertController.addAction(okAction)
        self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
}

extension Alerts where Self: SKScene{
    func doPurchase(title: String, message: String, cost: Int, item: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField()
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            //update money
            preferences.set(preferences.value(forKey: "money") as! Int - cost, forKey: "money")
            //update unlocked items
            preferences.set(true, forKey: item)
        }
        let noAction = UIAlertAction(title: "No", style: .cancel){ _ in}
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func insufficientFunds(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .cancel){ _ in}
        alertController.addAction(okAction)
        self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func notUnlocked(){
        let alertController = UIAlertController(title: "Item Locked", message: "This item is not yet unlocked! You must first purchase it in the store!", preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel){ _ in}
        alertController.addAction(dismissAction)
        self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func alreadyPurchased(){
        let alertController = UIAlertController(title: "Item Already Purchased!", message: "You have this item!", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel){ _ in}
        alertController.addAction(dismissAction)
        self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
