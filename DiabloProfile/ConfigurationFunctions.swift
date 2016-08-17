//
//  ConfigurationFunctions.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/14/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import Foundation

extension AppDelegate {
    class func configurations() -> [String: AnyObject]? {
        if let filePath = NSBundle.mainBundle().pathForResource("Configuration", ofType: "plist") {
            if let configuration = NSDictionary(contentsOfFile: filePath) as? [String: AnyObject] {
                return configuration
            }
        }
        return nil
    }
    
    class func gameData() -> [String: AnyObject]? {
        if let filePath = NSBundle.mainBundle().pathForResource("GameData", ofType: "plist") {
            if let gameData = NSDictionary(contentsOfFile: filePath) as? [String: AnyObject] {
                return gameData
            }
        }
        return nil
    }
}