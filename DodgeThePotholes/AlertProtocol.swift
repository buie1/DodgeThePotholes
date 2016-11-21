//
//  AlertProtocol.swift
//  DodgeThePotholes
//
//  Created by Colby Stanley on 11/20/16.
//  Copyright © 2016 Jonathan Buie. All rights reserved.
//  Found on: http://stackoverflow.com/questions/39557344/swift-spritekit-how-to-present-alert-view-in-gamescene

import SpriteKit

protocol Alerts { }
extension Alerts where Self: SKScene {
    
    func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in }
        alertController.addAction(okAction)
        
        self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertWithSettings(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in }
        alertController.addAction(okAction)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            
            if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.canOpenURL(url as URL)
            }
        }
        alertController.addAction(settingsAction)
        
        self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
