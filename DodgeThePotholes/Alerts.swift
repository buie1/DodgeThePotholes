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
    
}
