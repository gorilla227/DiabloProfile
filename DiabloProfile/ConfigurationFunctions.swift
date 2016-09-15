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
        if let filePath = Bundle.main.path(forResource: "Configuration", ofType: "plist") {
            if let configuration = NSDictionary(contentsOfFile: filePath) as? [String: AnyObject] {
                return configuration
            }
        }
        return nil
    }
    
    class func gameData(locale: String?) -> [String: AnyObject]? {
        return getLocalizedFile(locale: locale, fileName: "GameData", ofType: "plist")
    }
    
    class func uiStrings(locale: String?) -> [String: AnyObject]? {
        return getLocalizedFile(locale: locale, fileName: "UIStrings", ofType: "plist")
    }
    
    class func getLocalizedFile(locale: String?, fileName: String?, ofType: String?) -> [String: AnyObject]? {
        if let locale = locale {
            if let configurations = configurations(), let languageCodes = configurations["LanguageCodeMatching"] as? [String: String], let languageCode = languageCodes[locale],
                let bundlePath = Bundle.main.path(forResource: languageCode, ofType: "lproj"), let bundle = Bundle(path: bundlePath) {
                    
                if let filePath = bundle.path(forResource: fileName, ofType: ofType) {
                    if let gameData = NSDictionary(contentsOfFile: filePath) as? [String: AnyObject] {
                        return gameData
                    }
                }
            }
        }
        
        if let filePath = Bundle.main.path(forResource: fileName, ofType: ofType) {
            if let gameData = NSDictionary(contentsOfFile: filePath) as? [String: AnyObject] {
                return gameData
            }
        }
        return nil
    }
}
