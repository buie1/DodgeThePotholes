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
        
        let submitAction = UIAlertAction(title: "Submit", style: .cancel) { _ in
            print(alertController.textFields?.first?.text! ?? "scrub")
            self.submissionName = alertController.textFields?.first?.text!
            leaderboardquery.child(self.submissionName).setValue(preferences.value(forKey: "highscore"))
        }
        alertController.addAction(submitAction)
        
        self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertWithSettings(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in }
        alertController.addAction(okAction)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            
            if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.openURL(url as URL)
            }
        }
        alertController.addAction(settingsAction)
        
        self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
